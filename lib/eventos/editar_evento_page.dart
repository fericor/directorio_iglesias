import 'package:conexion_mas/controllers/EventoService.dart';
import 'package:conexion_mas/models/MisEventos.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditarEventoPage extends StatefulWidget {
  final MisEventos evento;
  final int userRole;
  final String token;
  final EventoService eventoService;
  final VoidCallback onEventoActualizado;

  const EditarEventoPage({
    Key? key,
    required this.evento,
    required this.userRole,
    required this.token,
    required this.eventoService,
    required this.onEventoActualizado,
  }) : super(key: key);

  @override
  _EditarEventoPageState createState() => _EditarEventoPageState();
}

class _EditarEventoPageState extends State<EditarEventoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _lugarController;
  late TextEditingController _direccionController;
  late TextEditingController _descCortaController;
  late TextEditingController _descripcionController;
  late TextEditingController _seatsController;
  late TextEditingController _tipoController;
  late TextEditingController _etiquetaController;
  late TextEditingController _distritoController;
  late TextEditingController _regionController;
  late TextEditingController _horaController;
  late TextEditingController _horaFinController;

  late DateTime _fecha;
  late DateTime? _fechaFin;
  XFile? _nuevaImagen;
  bool _portada = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _inicializarControllers();
  }

  void _inicializarControllers() {
    _tituloController = TextEditingController(text: widget.evento.titulo ?? "");
    _lugarController = TextEditingController(text: widget.evento.lugar ?? "");
    _direccionController = TextEditingController(text: widget.evento.direccion);
    _descCortaController =
        TextEditingController(text: widget.evento.descripcionCorta);
    _descripcionController =
        TextEditingController(text: widget.evento.descripcion);
    _seatsController =
        TextEditingController(text: widget.evento.seats.toString());
    _tipoController = TextEditingController(text: widget.evento.tipo);
    _etiquetaController = TextEditingController(text: widget.evento.etiqueta);
    _distritoController =
        TextEditingController(text: widget.evento.distrito ?? '');
    _regionController = TextEditingController(text: widget.evento.region ?? '');
    _horaController = TextEditingController(text: widget.evento.hora);
    _horaFinController =
        TextEditingController(text: widget.evento.horaFin ?? '');

    _fecha = DateTime.parse(widget.evento.fecha!);
    _fechaFin = widget.evento.fechaFin != null
        ? DateTime.parse(widget.evento.fechaFin!)
        : DateTime.now();
    _portada = widget.evento.portada! == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Evento',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _loading ? null : _actualizarEvento,
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
                    _buildAdditionalFields(),
                    const SizedBox(height: 20),
                    _buildPortadaSwitch(),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _actualizarEvento,
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
                          'Actualizar Evento',
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
              color: ColorsUtils.terceroColor,
            ),
            child: _nuevaImagen != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(_nuevaImagen!.path),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : widget.evento.imagen != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "${MainUtils.urlHostAssetsImagen}/${widget.evento.imagen}",
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: ColorsUtils.principalColor,
                          ),
                          const SizedBox(height: 8),
                          Text('Cambiar imagen',
                              style: TextStyle(
                                color: ColorsUtils.principalColor,
                              )),
                        ],
                      ),
          ),
        ),
        if (_nuevaImagen != null || widget.evento.imagen != null)
          Wrap(
            children: [
              if (_nuevaImagen != null)
                TextButton(
                  onPressed: () => setState(() => _nuevaImagen = null),
                  child: const Text('Quitar nueva imagen'),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildBasicFields() {
    return Column(
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
      ],
    );
  }

  Widget _buildDateFields() {
    return Card(
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
    );
  }

  Widget _buildAdditionalFields() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: 10,
          child: TextFormField(
            controller: _seatsController,
            decoration: const InputDecoration(
              labelText: 'Capacidad',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: _tipoController,
            decoration: const InputDecoration(
              labelText: 'Tipo',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: _etiquetaController,
            decoration: const InputDecoration(
              labelText: 'Etiqueta',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: _distritoController,
            decoration: const InputDecoration(
              labelText: 'Distrito',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: _regionController,
            decoration: const InputDecoration(
              labelText: 'Región',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
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
          setState(() => _nuevaImagen = imagen);
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

  Future<void> _actualizarEvento() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Crear un nuevo objeto Evento manualmente con los valores actualizados
      final eventoActualizado = MisEventos(
        idEvento: widget.evento.idEvento,
        idOrganizacion: widget.evento.idOrganizacion,
        idIglesia: widget.evento.idIglesia,
        fecha: _formatDate(_fecha),
        hora: _horaController.text,
        fechaFin: _fechaFin != null
            ? _formatDate(_fechaFin!)
            : widget.evento.fechaFin,
        horaFin: _horaFinController.text.isEmpty
            ? widget.evento.horaFin
            : _horaFinController.text,
        titulo: _tituloController.text,
        lugar: _lugarController.text,
        direccion: _direccionController.text,
        descripcionCorta: _descCortaController.text,
        descripcion: _descripcionController.text,
        infoExtra: widget.evento.infoExtra, // Mantener valor original
        seats: _seatsController.text,
        tipo: _tipoController.text,
        etiqueta: _etiquetaController.text,
        imagen: widget.evento.imagen, // Mantener imagen original
        portada: _portada ? 1 : 0,
        distrito: _distritoController.text.isEmpty
            ? widget.evento.distrito
            : _distritoController.text,
        region: _regionController.text.isEmpty
            ? widget.evento.region
            : _regionController.text,
        esGratis: widget.evento.esGratis, // Mantener valor original
        activo: widget.evento.activo, // Mantener estado activo original
        createdAt: widget.evento.createdAt, // Mantener fecha creación original
        updatedAt: DateTime.now().toString(), // Solo actualizar updatedAt
      );

      await widget.eventoService.editarEvento(eventoActualizado, widget.token);

      // Subir nueva imagen si se seleccionó
      if (_nuevaImagen != null) {
        final imageBytes = await _nuevaImagen!.readAsBytes();
        final imageUrl = await widget.eventoService.subirImagenEvento(
          widget.evento.idEvento!,
          imageBytes,
          _nuevaImagen!.name,
          widget.token,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento actualizado correctamente')),
      );

      widget.onEventoActualizado();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
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
  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      // Manejar diferentes formatos de fecha
      if (dateString.contains('-')) {
        return DateTime.parse(dateString);
      } else if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          return DateTime(
              int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

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
