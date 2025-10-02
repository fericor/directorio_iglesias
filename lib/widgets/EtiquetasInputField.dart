import 'dart:convert';

import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';

class EtiquetasInputField extends StatefulWidget {
  final String? etiquetaJson; // Recibir el string JSON
  final ValueChanged<String> onEtiquetasChanged; // Devolver string JSON
  final String? labelText;

  const EtiquetasInputField({
    Key? key,
    this.etiquetaJson,
    required this.onEtiquetasChanged,
    this.labelText = 'Etiquetas',
  }) : super(key: key);

  @override
  _EtiquetasInputFieldState createState() => _EtiquetasInputFieldState();
}

class _EtiquetasInputFieldState extends State<EtiquetasInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _etiquetas = [];

  @override
  void initState() {
    super.initState();
    _cargarEtiquetasIniciales();
    _focusNode.addListener(_onFocusChange);
  }

  void _cargarEtiquetasIniciales() {
    if (widget.etiquetaJson != null && widget.etiquetaJson!.isNotEmpty) {
      try {
        final List<dynamic> parsed = jsonDecode(widget.etiquetaJson!);
        _etiquetas = List<String>.from(parsed);
      } catch (e) {
        _etiquetas = [];
      }
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _agregarEtiqueta(_controller.text);
    }
  }

  void _agregarEtiqueta(String etiqueta) {
    final etiquetaLimpia = etiqueta.trim();
    if (etiquetaLimpia.isNotEmpty && !_etiquetas.contains(etiquetaLimpia)) {
      setState(() {
        _etiquetas.add(etiquetaLimpia);
        _controller.clear();
      });
      _actualizarJson();
    }
  }

  void _eliminarEtiqueta(String etiqueta) {
    setState(() {
      _etiquetas.remove(etiqueta);
    });
    _actualizarJson();
  }

  void _editarEtiqueta(int index, String nuevaEtiqueta) {
    final etiquetaLimpia = nuevaEtiqueta.trim();
    if (etiquetaLimpia.isNotEmpty) {
      setState(() {
        _etiquetas[index] = etiquetaLimpia;
      });
      _actualizarJson();
    }
  }

  void _actualizarJson() {
    final jsonString = jsonEncode(_etiquetas);
    widget.onEtiquetasChanged(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorsUtils.terceroColor,
          border: Border.all(
            color: ColorsUtils.principalColor,
          ),
          borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
            const SizedBox(height: 8),

            // Input para añadir etiquetas
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Escribe una etiqueta y presiona Enter',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _agregarEtiqueta(_controller.text),
                ),
              ),
              onSubmitted: _agregarEtiqueta,
            ),
            const SizedBox(height: 8),

            // Vista previa del JSON
            if (_etiquetas.isNotEmpty) ...[
              /*Card(
                color: ColorsUtils.segundoColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Se guardará como: ${jsonEncode(_etiquetas)}',
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                ),
              ),
              const SizedBox(height: 8),*/
            ],

            // Lista de etiquetas existentes
            if (_etiquetas.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _etiquetas.asMap().entries.map((entry) {
                  final index = entry.key;
                  final etiqueta = entry.value;

                  return _ChipEtiqueta(
                    etiqueta: etiqueta,
                    onEliminar: () => _eliminarEtiqueta(etiqueta),
                    onEditar: (nuevaEtiqueta) =>
                        _editarEtiqueta(index, nuevaEtiqueta),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class _ChipEtiqueta extends StatefulWidget {
  final String etiqueta;
  final VoidCallback onEliminar;
  final ValueChanged<String> onEditar;

  const _ChipEtiqueta({
    required this.etiqueta,
    required this.onEliminar,
    required this.onEditar,
  });

  @override
  __ChipEtiquetaState createState() => __ChipEtiquetaState();
}

class __ChipEtiquetaState extends State<_ChipEtiqueta> {
  final TextEditingController _editController = TextEditingController();
  bool _editando = false;

  @override
  void initState() {
    super.initState();
    _editController.text = widget.etiqueta;
  }

  void _toggleEditar() {
    setState(() {
      _editando = !_editando;
      if (!_editando) {
        _editController.text = widget.etiqueta;
      }
    });
  }

  void _guardarEdicion() {
    final nuevaEtiqueta = _editController.text.trim();
    if (nuevaEtiqueta.isNotEmpty && nuevaEtiqueta != widget.etiqueta) {
      widget.onEditar(nuevaEtiqueta);
    }
    setState(() => _editando = false);
  }

  void _cancelarEdicion() {
    _editController.text = widget.etiqueta;
    setState(() => _editando = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_editando) {
      return Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: ColorsUtils.segundoColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorsUtils.negroColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: _editController,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _guardarEdicion(),
                autofocus: true,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _guardarEdicion,
              child: Icon(Icons.check, size: 16, color: Colors.green[700]),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _cancelarEdicion,
              child: Icon(Icons.close, size: 16, color: Colors.red[700]),
            ),
          ],
        ),
      );
    }

    return Chip(
      label: Text(
        widget.etiqueta,
        style: TextStyle(
          fontSize: 13,
          color: ColorsUtils.blancoColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      deleteIcon: Icon(Icons.close, size: 16, color: Colors.red[700]),
      onDeleted: widget.onEliminar,
      backgroundColor: ColorsUtils.segundoColor,
      side: BorderSide(color: Colors.blue[100]!),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      avatar: GestureDetector(
        onTap: _toggleEditar,
        child: Icon(Icons.edit, size: 16, color: ColorsUtils.blancoColor),
      ),
    );
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }
}
