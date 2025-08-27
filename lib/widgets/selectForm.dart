import 'package:conexion_mas/controllers/iglesiasApiClient.dart';
import 'package:conexion_mas/models/iglesia.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';

class IglesiaDropdown extends StatefulWidget {
  final ValueChanged<Iglesia?> onIglesiaSeleccionada;
  final String? hintText;

  const IglesiaDropdown({
    Key? key,
    required this.onIglesiaSeleccionada,
    this.hintText = 'Selecciona una iglesia',
  }) : super(key: key);

  @override
  _IglesiaDropdownState createState() => _IglesiaDropdownState();
}

class _IglesiaDropdownState extends State<IglesiaDropdown> {
  Iglesia? _iglesiaSeleccionada;
  List<Iglesia> _iglesias = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _cargarIglesias();
  }

  Future<void> _cargarIglesias() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final iglesias = await IglesiasApiClient().obtenerIglesias();
      setState(() {
        _iglesias = iglesias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorsUtils.principalColor),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _isLoading
              ? _buildLoadingIndicator()
              : _errorMessage != null
                  ? _buildErrorWidget()
                  : _buildDropdown(),
        ),
        if (_errorMessage != null) _buildErrorMessage(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Error al cargar',
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: _cargarIglesias,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButton<Iglesia>(
      dropdownColor: ColorsUtils.blancoColor,
      focusColor: ColorsUtils.negroColor,
      value: _iglesiaSeleccionada,
      isExpanded: true,
      underline: const SizedBox(),
      hint: Text(
        widget.hintText!,
        style: TextStyle(
          color: ColorsUtils.negroColor,
        ),
      ),
      items: _iglesias.map((Iglesia iglesia) {
        return DropdownMenuItem<Iglesia>(
          value: iglesia,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            iglesia.titulo,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorsUtils.negroColor,
            ),
          ),
        );
      }).toList(),
      onChanged: (Iglesia? nuevaIglesia) {
        setState(() {
          _iglesiaSeleccionada = nuevaIglesia;
        });
        widget.onIglesiaSeleccionada(nuevaIglesia);
      },
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        _errorMessage!,
        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
      ),
    );
  }
}
