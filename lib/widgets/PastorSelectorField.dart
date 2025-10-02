import 'package:conexion_mas/controllers/MisPastorService.dart';
import 'package:conexion_mas/models/Pastores.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';

class PastorSelectorField extends StatefulWidget {
  final String? pastorId;
  final ValueChanged<String?> onPastorChanged;
  final String token;
  final String idOrganizacion;

  const PastorSelectorField({
    Key? key,
    this.pastorId,
    required this.onPastorChanged,
    required this.token,
    required this.idOrganizacion,
  }) : super(key: key);

  @override
  _PastorSelectorFieldState createState() => _PastorSelectorFieldState();
}

class _PastorSelectorFieldState extends State<PastorSelectorField> {
  final MisPastorService _pastorService =
      MisPastorService(baseUrl: MainUtils.urlHostApi);
  List<Pastores> _pastores = [];
  bool _loading = true;
  String? _selectedPastorId;

  @override
  void initState() {
    super.initState();
    _cargarPastores();
    _selectedPastorId = widget.pastorId;
  }

  Future<void> _cargarPastores() async {
    try {
      final pastores = await _pastorService.getPastoresByOrganizacion(
          widget.token, widget.idOrganizacion);
      setState(() {
        _pastores = pastores;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar pastores: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pastor asignado',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ColorsUtils.blancoColor,
          ),
        ),
        const SizedBox(height: 8),
        _loading
            ? const CircularProgressIndicator()
            : Container(
                decoration: BoxDecoration(
                  color: ColorsUtils.terceroColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  // Oculta la línea inferior
                  child: DropdownButtonFormField<String>(
                    value: _selectedPastorId,
                    items: [
                      DropdownMenuItem(
                        value: "0",
                        child: Text('Sin pastor asignado',
                            style: TextStyle(color: ColorsUtils.blancoColor)),
                      ),
                      ..._pastores
                          .map(
                            (pastor) => DropdownMenuItem(
                              value: pastor.idPastor.toString(),
                              child: Text(
                                '${pastor.nombre} ${pastor.apellidos}',
                                style:
                                    TextStyle(color: ColorsUtils.blancoColor),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedPastorId = value);
                      widget.onPastorChanged(value);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      fillColor: ColorsUtils.terceroColor,
                      hintText: 'Seleccionar pastor',
                      hintStyle: TextStyle(color: ColorsUtils.blancoColor),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 14),
                    ),
                    dropdownColor: ColorsUtils.negroColor,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    style: const TextStyle(color: Colors.white),
                    isExpanded: true,
                  ),
                ),
              )
      ],
    );
  }
}
