import 'dart:convert';

import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';

class KeyValueInputField extends StatefulWidget {
  final String? jsonData;
  final ValueChanged<String> onJsonChanged;
  final String? labelText;

  const KeyValueInputField({
    Key? key,
    this.jsonData,
    required this.onJsonChanged,
    this.labelText = 'Información adicional',
  }) : super(key: key);

  @override
  _KeyValueInputFieldState createState() => _KeyValueInputFieldState();
}

class _KeyValueInputFieldState extends State<KeyValueInputField> {
  final Map<String, String> _keyValueMap = {};
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  void _cargarDatosIniciales() {
    if (widget.jsonData != null && widget.jsonData!.isNotEmpty) {
      try {
        final Map<String, dynamic> parsed = jsonDecode(widget.jsonData!);
        _keyValueMap.clear();
        parsed.forEach((key, value) {
          _keyValueMap[key] = value.toString();
        });
      } catch (e) {
        _keyValueMap.clear();
      }
    }
  }

  void _agregarPar() {
    final clave = _keyController.text.trim();
    final valor = _valueController.text.trim();

    if (clave.isNotEmpty && valor.isNotEmpty) {
      if (_keyValueMap.containsKey(clave)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La clave "$clave" ya existe')),
        );
        return;
      }

      setState(() {
        _keyValueMap[clave] = valor;
        _keyController.clear();
        _valueController.clear();
      });
      _actualizarJson();
    }
  }

  void _eliminarPar(String clave) {
    setState(() {
      _keyValueMap.remove(clave);
    });
    _actualizarJson();
  }

  void _editarPar(String claveVieja, String nuevaClave, String nuevoValor) {
    final claveLimpia = nuevaClave.trim();
    final valorLimpio = nuevoValor.trim();

    if (claveLimpia.isNotEmpty && valorLimpio.isNotEmpty) {
      // Si cambió la clave, verificar que no exista
      if (claveVieja != claveLimpia && _keyValueMap.containsKey(claveLimpia)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La clave "$claveLimpia" ya existe')),
        );
        return;
      }

      setState(() {
        // Si cambió la clave, eliminar la vieja y agregar la nueva
        if (claveVieja != claveLimpia) {
          _keyValueMap.remove(claveVieja);
        }
        _keyValueMap[claveLimpia] = valorLimpio;
      });
      _actualizarJson();
    }
  }

  void _actualizarJson() {
    final jsonString = jsonEncode(_keyValueMap);
    widget.onJsonChanged(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorsUtils.terceroColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorsUtils.principalColor),
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

            // Formulario para añadir nuevos pares
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _keyController,
                        decoration: const InputDecoration(
                          labelText: 'Clave (ej: Lugar, Teléfono)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _valueController,
                        decoration: const InputDecoration(
                          labelText: 'Valor',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _agregarPar(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _agregarPar,
                  child: const Text('Añadir informacion extra'),
                ),
              ],
            ),

            // Vista previa del JSON
            /*if (_keyValueMap.isNotEmpty) ...[
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
                        jsonEncode(_keyValueMap),
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

            // Lista de pares existentes
            if (_keyValueMap.isNotEmpty) ...[
              const Text(
                'Pares clave-valor:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              ..._keyValueMap.entries.map((entry) {
                return _KeyValueCard(
                  clave: entry.key,
                  valor: entry.value,
                  onEliminar: () => _eliminarPar(entry.key),
                  onEditar: (nuevaClave, nuevoValor) =>
                      _editarPar(entry.key, nuevaClave, nuevoValor),
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
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}

class _KeyValueCard extends StatefulWidget {
  final String clave;
  final String valor;
  final VoidCallback onEliminar;
  final ValueChanged2<String, String> onEditar;

  const _KeyValueCard({
    required this.clave,
    required this.valor,
    required this.onEliminar,
    required this.onEditar,
  });

  @override
  __KeyValueCardState createState() => __KeyValueCardState();
}

// Necesitamos crear este typedef para la callback con dos parámetros
typedef ValueChanged2<A, B> = void Function(A a, B b);

class __KeyValueCardState extends State<_KeyValueCard> {
  final TextEditingController _claveController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  bool _editando = false;

  @override
  void initState() {
    super.initState();
    _claveController.text = widget.clave;
    _valorController.text = widget.valor;
  }

  void _toggleEditar() {
    setState(() {
      _editando = !_editando;
      if (!_editando) {
        _claveController.text = widget.clave;
        _valorController.text = widget.valor;
      }
    });
  }

  void _guardarEdicion() {
    final nuevaClave = _claveController.text.trim();
    final nuevoValor = _valorController.text.trim();

    if (nuevaClave.isNotEmpty && nuevoValor.isNotEmpty) {
      widget.onEditar(nuevaClave, nuevoValor);
    }
    setState(() => _editando = false);
  }

  void _cancelarEdicion() {
    _claveController.text = widget.clave;
    _valorController.text = widget.valor;
    setState(() => _editando = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_editando) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: _claveController,
                decoration: const InputDecoration(
                  labelText: 'Clave',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _cancelarEdicion,
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _guardarEdicion,
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          widget.clave,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.valor),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: _toggleEditar,
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: widget.onEliminar,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _claveController.dispose();
    _valorController.dispose();
    super.dispose();
  }
}
