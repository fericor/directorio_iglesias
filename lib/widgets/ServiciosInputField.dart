import 'dart:convert';

import 'package:conexion_mas/utils/ChurchTextFieldStyles.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';

class ServiciosInputField extends StatefulWidget {
  final String? serviciosJson;
  final ValueChanged<String> onServiciosChanged;
  final String? labelText;

  const ServiciosInputField({
    Key? key,
    this.serviciosJson,
    required this.onServiciosChanged,
    this.labelText = 'Horarios de Culto',
  }) : super(key: key);

  @override
  _ServiciosInputFieldState createState() => _ServiciosInputFieldState();
}

class _ServiciosInputFieldState extends State<ServiciosInputField> {
  final Map<String, List<String>> _servicios = {};
  final TextEditingController _diaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  String _diaSeleccionado = 'Domingo';

  @override
  void initState() {
    super.initState();
    _cargarServiciosIniciales();
  }

  void _cargarServiciosIniciales() {
    if (widget.serviciosJson != null && widget.serviciosJson!.isNotEmpty) {
      try {
        final Map<String, dynamic> parsed = jsonDecode(widget.serviciosJson!);
        _servicios.clear();
        parsed.forEach((key, value) {
          if (value is List) {
            _servicios[key] = List<String>.from(value);
          }
        });
      } catch (e) {
        _servicios.clear();
      }
    }
  }

  void _agregarHora() {
    final hora = _horaController.text.trim();
    if (hora.isNotEmpty) {
      setState(() {
        _servicios.putIfAbsent(_diaSeleccionado, () => []);
        if (!_servicios[_diaSeleccionado]!.contains(hora)) {
          _servicios[_diaSeleccionado]!.add(hora);
        }
        _horaController.clear();
      });
      _actualizarJson();
    }
  }

  void _eliminarHora(String dia, String hora) {
    setState(() {
      _servicios[dia]?.remove(hora);
      if (_servicios[dia]?.isEmpty ?? true) {
        _servicios.remove(dia);
      }
    });
    _actualizarJson();
  }

  void _eliminarDia(String dia) {
    setState(() {
      _servicios.remove(dia);
    });
    _actualizarJson();
  }

  void _actualizarJson() {
    final jsonString = jsonEncode(_servicios);
    widget.onServiciosChanged(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsUtils.segundoColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorsUtils.principalColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.labelText!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorsUtils.blancoColor,
              ),
            ),
            const SizedBox(height: 10),

            // Selector de día y entrada de hora
            Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _diaSeleccionado,
                  items: [
                    'Domingo',
                    'Lunes',
                    'Martes',
                    'Miércoles',
                    'Jueves',
                    'Viernes',
                    'Sábado'
                  ].map((dia) {
                    return DropdownMenuItem(
                      value: dia,
                      child: Text(dia),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _diaSeleccionado = value!),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: true,
                    fillColor: ColorsUtils.terceroColor,
                    hintText: 'Día de la semana',
                    hintStyle: TextStyle(color: ColorsUtils.blancoColor),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                  ),
                  dropdownColor: ColorsUtils.negroColor,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  isExpanded: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: ColorsUtils.blancoColor,
                        ),
                        controller: _horaController,
                        decoration: ChurchTextFieldStyles.churchTextField(
                          hintText: 'ej: 10:30',
                          labelText: 'Hora',
                        ),
                        onSubmitted: (_) => _agregarHora,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsUtils.principalColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: _agregarHora,
                      child: Text(
                        'Agregar',
                        style: TextStyle(
                          color: ColorsUtils.blancoColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Vista previa del JSON
            /*if (_servicios.isNotEmpty) ...[
              Card(
                color: Colors.grey[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Se guardará como JSON:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        jsonEncode(_servicios),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],*/

            // Lista de servicios
            if (_servicios.isNotEmpty) ...[
              const Text(
                'Horarios programados:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              ..._servicios.entries.map((entry) {
                return _DiaServiciosCard(
                  dia: entry.key,
                  horas: entry.value,
                  onEliminarHora: (hora) => _eliminarHora(entry.key, hora),
                  onEliminarDia: () => _eliminarDia(entry.key),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _diaController.dispose();
    _horaController.dispose();
    super.dispose();
  }
}

class _DiaServiciosCard extends StatelessWidget {
  final String dia;
  final List<String> horas;
  final ValueChanged<String> onEliminarHora;
  final VoidCallback onEliminarDia;

  const _DiaServiciosCard({
    required this.dia,
    required this.horas,
    required this.onEliminarHora,
    required this.onEliminarDia,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dia,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ColorsUtils.blancoColor),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: onEliminarDia,
                  tooltip: 'Eliminar día',
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: horas.map((hora) {
                return Chip(
                  label: Text(
                    hora,
                    style: TextStyle(color: ColorsUtils.blancoColor),
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => onEliminarHora(hora),
                  backgroundColor: ColorsUtils.principalColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
