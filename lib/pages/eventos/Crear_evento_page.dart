import 'package:conexion_mas/controllers/EventoService.dart';
import 'package:conexion_mas/models/MisEventos.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/widgets/EtiquetasInputField.dart';
import 'package:conexion_mas/widgets/KeyValueInputField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:localstorage/localstorage.dart';

class CrearEventoPage extends StatefulWidget {
  final int userRole;
  final int userId;
  final int idIglesia;
  final int idOrganizacion;
  final String token;
  final EventoService eventoService;
  final VoidCallback onEventoCreado;

  const CrearEventoPage({
    Key? key,
    required this.userRole,
    required this.userId,
    required this.idIglesia,
    required this.idOrganizacion,
    required this.token,
    required this.eventoService,
    required this.onEventoCreado,
  }) : super(key: key);

  @override
  _CrearEventoPageState createState() => _CrearEventoPageState();
}

class _CrearEventoPageState extends State<CrearEventoPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _lugarController = TextEditingController();
  final _direccionController = TextEditingController();
  final _descCortaController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _seatsController = TextEditingController(text: '0');
  final _tipoController = TextEditingController();
  final _etiquetaController = TextEditingController();
  final _distritoController = TextEditingController();
  final _regionController = TextEditingController();
  final _horaController = TextEditingController();
  final _horaFinController = TextEditingController();

  DateTime _fecha = DateTime.now();
  DateTime? _fechaFin;
  XFile? _imagenSeleccionada;
  bool _portada = false;
  bool _loading = false;

  String _etiquetasJson = '[]';
  String _infoExtraJson = '{}';

  Widget _buildInfoExtraField() {
    return KeyValueInputField(
      jsonData: _infoExtraJson,
      onJsonChanged: (nuevoJson) {
        setState(() => _infoExtraJson = nuevoJson);
      },
      labelText: 'Información adicional',
    );
  }

  Widget _buildEtiquetasField() {
    return EtiquetasInputField(
      etiquetaJson: _etiquetasJson,
      onEtiquetasChanged: (nuevoJson) {
        setState(() => _etiquetasJson = nuevoJson);
      },
      labelText: 'Etiquetas del evento',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.fondoColor,
        title: Text(
          'Crear Evento',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _loading ? null : _crearEvento,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 20),
                    _buildBasicFields(),
                    const SizedBox(height: 20),
                    _buildDateFields(),
                    const SizedBox(height: 20),
                    _buildEtiquetasField(),
                    const SizedBox(height: 20),
                    _buildInfoExtraField(),
                    const SizedBox(height: 20),
                    _buildPortadaSwitch(),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _crearEvento,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 26,
                        ),
                        child: Text(
                          'Crear Evento',
                          style: TextStyle(
                            color: ColorsUtils.blancoColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: _seleccionarImagen,
          child: Container(
            width: 300,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: ColorsUtils.principalColor),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
            ),
            child: _imagenSeleccionada != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(_imagenSeleccionada!.path),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt,
                          size: 40, color: ColorsUtils.principalColor),
                      const SizedBox(height: 8),
                      Text('Subir imagen',
                          style: TextStyle(color: ColorsUtils.principalColor)),
                    ],
                  ),
          ),
        ),
        if (_imagenSeleccionada != null)
          TextButton(
            onPressed: () => setState(() => _imagenSeleccionada = null),
            child: const Text('Quitar imagen'),
          ),
      ],
    );
  }

  Widget _buildBasicFields() {
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
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título*',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lugarController,
              decoration: const InputDecoration(
                labelText: 'Lugar*',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _direccionController,
              decoration: const InputDecoration(
                labelText: 'Dirección*',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCortaController,
              decoration: const InputDecoration(
                labelText: 'Descripción Corta*',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción Completa*',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tipoController,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFields() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorsUtils.principalColor),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Fechas y Horas',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha Inicio*'),
                        TextButton(
                          onPressed: () => _seleccionarFecha(inicio: true),
                          child: Text(
                              '${_fecha.day}/${_fecha.month}/${_fecha.year}'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _horaController,
                      decoration: const InputDecoration(
                        labelText: 'Hora Inicio*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha Fin (opcional)'),
                        TextButton(
                          onPressed: () => _seleccionarFecha(inicio: false),
                          child: Text(_fechaFin != null
                              ? '${_fechaFin!.day}/${_fechaFin!.month}/${_fechaFin!.year}'
                              : 'Seleccionar'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _horaFinController,
                      decoration: const InputDecoration(
                        labelText: 'Hora Fin',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortadaSwitch() {
    return SwitchListTile(
      title: const Text('Mostrar en portada'),
      subtitle: const Text('¿Quieres que este evento aparezca destacado?'),
      value: _portada,
      onChanged: (value) => setState(() => _portada = value),
    );
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();

    final option = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (option != null) {
      try {
        final XFile? imagen = await picker.pickImage(
          source: option,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 85,
        );

        if (imagen != null) {
          setState(() => _imagenSeleccionada = imagen);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  Future<void> _seleccionarFecha({required bool inicio}) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: inicio ? _fecha : _fechaFin ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        if (inicio) {
          _fecha = fecha;
        } else {
          _fechaFin = fecha;
        }
      });
    }
  }

  Future<void> _crearEvento() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final nuevoEvento = MisEventos(
        idEvento: null, // El servidor asignará el ID
        idOrganizacion: widget.idOrganizacion ?? 0,
        idIglesia: widget
            .idIglesia, // Esto debería venir de la organización del usuario
        fecha: _formatDate(_fecha),
        hora: _horaController.text,
        fechaFin: _fechaFin != null ? _formatDate(_fechaFin!) : null,
        horaFin:
            _horaFinController.text.isEmpty ? null : _horaFinController.text,
        titulo: _tituloController.text,
        lugar: _lugarController.text,
        direccion: _direccionController.text,
        descripcionCorta: _descCortaController.text,
        descripcion: _descripcionController.text,
        infoExtra: _infoExtraJson, // Valor por defecto
        seats: _seatsController.text,
        tipo: _tipoController.text,
        etiqueta: _etiquetasJson,
        imagen: "",
        portada: _portada ? 1 : 0,
        distrito: localStorage.getItem('miDistrito'),
        region: localStorage.getItem('miRegion'),
        esGratis: 0, // Valor por defecto
        activo:
            widget.userRole >= 200 ? 1 : 0, // Solo admins crean eventos activos
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      );

      final eventoCreado =
          await widget.eventoService.crearEvento(nuevoEvento, widget.token);

      // Subir imagen si se seleccionó
      if (_imagenSeleccionada != null) {
        final imageBytes = await _imagenSeleccionada!.readAsBytes();
        await widget.eventoService.subirImagenEvento(
          eventoCreado.idEvento!,
          imageBytes,
          _imagenSeleccionada!.name,
          widget.token,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento creado correctamente')),
      );

      widget.onEventoCreado();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear evento: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  // Para formatear DateTime a string (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Para parsear fechas desde string a DateTime

  @override
  void dispose() {
    _tituloController.dispose();
    _lugarController.dispose();
    _direccionController.dispose();
    _descCortaController.dispose();
    _descripcionController.dispose();
    _seatsController.dispose();
    _tipoController.dispose();
    _etiquetaController.dispose();
    _distritoController.dispose();
    _regionController.dispose();
    _horaController.dispose();
    _horaFinController.dispose();
    super.dispose();
  }
}
