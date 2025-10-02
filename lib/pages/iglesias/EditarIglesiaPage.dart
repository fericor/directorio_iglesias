import 'dart:io';

import 'package:conexion_mas/controllers/MisIglesiaImagenService.dart';
import 'package:conexion_mas/controllers/MisIglesiaService.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/MisIglesiaImagen.dart';
import 'package:conexion_mas/models/MisIglesias.dart';
import 'package:conexion_mas/models/iglesias.dart';
import 'package:conexion_mas/utils/ChurchTextFieldStyles.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:conexion_mas/widgets/GaleriaImagenesField.dart';
import 'package:conexion_mas/widgets/ImageUploadField.dart';
import 'package:conexion_mas/widgets/MapLocationSelector.dart';
import 'package:conexion_mas/widgets/PastorSelectorField.dart';
import 'package:conexion_mas/widgets/ServiciosInputField.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class EditarIglesiaPage extends StatefulWidget {
  final Iglesias iglesia;
  final String token;
  final VoidCallback onIglesiaActualizada;

  const EditarIglesiaPage({
    Key? key,
    required this.iglesia,
    required this.token,
    required this.onIglesiaActualizada,
  }) : super(key: key);

  @override
  _EditarIglesiaPageState createState() => _EditarIglesiaPageState();
}

class _EditarIglesiaPageState extends State<EditarIglesiaPage> {
  final _formKey = GlobalKey<FormState>();
  final MisIglesiaService _iglesiaService = MisIglesiaService(
    baseUrl: MainUtils.urlHostApi,
  );
  final MisIglesiaImagenService _imagenService = MisIglesiaImagenService(
    baseUrl: MainUtils.urlHostApi,
  );

  // Controllers para campos de texto
  late TextEditingController _tituloController;
  late TextEditingController _direccionController;
  late TextEditingController _comunidadController;
  late TextEditingController _provinciaController;
  late TextEditingController _ciudadController;
  late TextEditingController _distritoController;
  late TextEditingController _regionController;
  late TextEditingController _zonaController;
  late TextEditingController _descripcionController;
  late TextEditingController _telefonoController;
  late TextEditingController _emailController;
  late TextEditingController _webController;
  late TextEditingController _asistentesController;
  late TextEditingController _horarioController;

  // Estados para los nuevos widgets
  String _serviciosJson = '{}';
  File? _nuevaImagenPortada;
  List<File> _nuevasImagenesGaleria = [];
  String? _pastorId;
  double? _latitud;
  double? _longitud;
  List<IglesiaImagen> _imagenesExistentes = [];

  bool _activo = true;
  bool _loading = false;
  bool _cargandoGaleria = true;

  @override
  void initState() {
    super.initState();
    _inicializarControllers();
    _cargarGaleriaImagenes();
  }

  void _inicializarControllers() {
    // Inicializar controllers con los datos de la iglesia
    _tituloController =
        TextEditingController(text: widget.iglesia.titulo ?? '');
    _direccionController =
        TextEditingController(text: widget.iglesia.direccion ?? '');
    _comunidadController =
        TextEditingController(text: widget.iglesia.comunidad ?? '');
    _provinciaController =
        TextEditingController(text: widget.iglesia.provincia ?? '');
    _ciudadController =
        TextEditingController(text: widget.iglesia.ciudad ?? '');
    _distritoController =
        TextEditingController(text: widget.iglesia.distrito ?? '');
    _regionController =
        TextEditingController(text: widget.iglesia.region ?? '');
    _zonaController = TextEditingController(text: widget.iglesia.zona ?? '');
    _descripcionController =
        TextEditingController(text: widget.iglesia.descripcion ?? '');
    _telefonoController =
        TextEditingController(text: widget.iglesia.telefono ?? '');
    _emailController = TextEditingController(text: widget.iglesia.email ?? '');
    _webController = TextEditingController(text: widget.iglesia.web ?? '');
    _asistentesController =
        TextEditingController(text: widget.iglesia.asistentes ?? '');
    _horarioController =
        TextEditingController(text: widget.iglesia.horario ?? '');

    // Inicializar estados especiales
    _serviciosJson = widget.iglesia.servicios ?? '{}';
    _pastorId = widget.iglesia.idPastor.toString();

    _activo = widget.iglesia.activo! == 1;

    // Inicializar coordenadas
    if (widget.iglesia.latitud != null && widget.iglesia.longitud != null) {
      _latitud = double.tryParse(widget.iglesia.latitud!.toString());
      _longitud = double.tryParse(widget.iglesia.longitud!.toString());
    }
  }

  Future<void> _cargarGaleriaImagenes() async {
    try {
      final List<IglesiaImagen> imagenes =
          await _imagenService.getImagenesByIglesia(
        widget.iglesia.idIglesia!.toString(),
        widget.token,
      );

      setState(() {
        _imagenesExistentes = imagenes;
        _cargandoGaleria = false;
      });
    } catch (e) {
      print('Error al cargar galería: $e');
      setState(() => _cargandoGaleria = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar galería: $e')),
      );
    }
  }

  // Widget para servicios de culto
  Widget _buildServiciosField() {
    return ServiciosInputField(
      serviciosJson: _serviciosJson,
      onServiciosChanged: (nuevoJson) {
        setState(() => _serviciosJson = nuevoJson);
      },
      labelText: 'Horarios de Culto',
    );
  }

  // Widget para imagen de portada
  Widget _buildImageUploadField() {
    return ImageUploadField(
      imageUrl:
          "${MainUtils.urlHostAssetsImagen}/iglesias/iglesia_${widget.iglesia.idIglesia.toString()}.png",
      onImageChanged: (imageFile) {
        setState(() => _nuevaImagenPortada = imageFile);
      },
      labelText: 'Imagen de portada',
    );
  }

  // Widget para galería de imágenes
  Widget _buildGaleriaField() {
    return GaleriaImagenesField(
      imagenes: _imagenesExistentes,
      onImagenesChanged: (imagenes) {
        setState(() => _nuevasImagenesGaleria = imagenes);
      },
      iglesiaId: widget.iglesia.idIglesia!.toString(),
      token: widget.token,
    );
  }

  // Widget para selector de pastor
  Widget _buildPastorSelector() {
    return PastorSelectorField(
      pastorId: _pastorId,
      idOrganizacion: localStorage.getItem('miOrganizacion').toString(),
      onPastorChanged: (pastorId) {
        setState(() => _pastorId = pastorId);
      },
      token: widget.token,
    );
  }

  // Widget para selector de ubicación
  Widget _buildLocationSelector() {
    return MapLocationSelector(
      initialLatitud: _latitud,
      initialLongitud: _longitud,
      onLocationSelected: (location) {
        setState(() {
          _latitud = location.latitude;
          _longitud = location.longitude;
        });
      },
      labelText: 'Ubicación de la iglesia',
    );
  }

  Future<void> _actualizarIglesia() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // 1. Actualizar datos de la iglesia
      final iglesiaActualizada = MisIglesia(
        idIglesia: widget.iglesia.idIglesia.toString(),
        idPastor: _pastorId,
        // idOrganizacion: widget.iglesia.idOrganizacion.toString(),
        titulo: _tituloController.text,
        direccion: _direccionController.text,
        comunidad: _comunidadController.text.isEmpty
            ? null
            : _comunidadController.text,
        provincia: _provinciaController.text.isEmpty
            ? null
            : _provinciaController.text,
        ciudad: _ciudadController.text,
        distrito:
            _distritoController.text.isEmpty ? null : _distritoController.text,
        region: _regionController.text.isEmpty ? null : _regionController.text,
        zona: _zonaController.text.isEmpty ? null : _zonaController.text,
        descripcion: _descripcionController.text.isEmpty
            ? null
            : _descripcionController.text,
        // valoracion: widget.iglesia.valoracion,
        latitud: _latitud?.toString(),
        longitud: _longitud?.toString(),
        telefono:
            _telefonoController.text.isEmpty ? null : _telefonoController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        web: _webController.text.isEmpty ? null : _webController.text,
        // ranking: widget.iglesia.ranking,
        asistentes: _asistentesController.text.isEmpty
            ? null
            : _asistentesController.text,
        servicios: _serviciosJson,
        horario:
            _horarioController.text.isEmpty ? null : _horarioController.text,
        // imagen: widget.iglesia.imagen,
        // portada: widget.iglesia.portada,
        activo: widget.iglesia.activo.toString(),
        createdAt: widget.iglesia.createdAt,
        updatedAt: DateTime.now().toString(),
      );

      final resultado = await _iglesiaService.actualizarIglesia(
          iglesiaActualizada, widget.token);

      // 2. Subir nueva imagen de portada si existe
      if (_nuevaImagenPortada != null) {
        await _iglesiaService.subirImagenPortada(
          widget.iglesia.idIglesia!.toString(),
          _nuevaImagenPortada!,
          widget.token,
        );
      }

      // 3. Subir nuevas imágenes a la galería
      for (final imagen in _nuevasImagenesGaleria) {
        await _iglesiaService.subirImagenGaleria(
          widget.iglesia.idIglesia!.toString(),
          imagen,
          widget.token,
        );
      }

      AppSnackbar.show(
        context,
        message: 'Iglesia actualizada correctamente',
        type: SnackbarType.success,
      );

      widget.onIglesiaActualizada();
      Navigator.pop(context);
    } on ValidationException catch (e) {
      // Mostrar errores de validación al usuario
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Errores de validacióneee'),
          content: Text(e.formattedMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } on Exception catch (e) {
      // Mostrar otros errores
      print(e.toString());
      AppSnackbar.show(
        context,
        message: e.toString(),
        type: SnackbarType.error,
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.fondoColor,
        title: Text(
          'Editar Iglesia',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _loading ? null : _actualizarIglesia,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Campos básicos
                    Container(
                      decoration: BoxDecoration(
                        color: ColorsUtils.segundoColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: ColorsUtils.principalColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildTextField(_tituloController,
                                'Nombre de la iglesia*', true),
                            _buildTextField(
                                _direccionController, 'Dirección*', true),

                            // Selector de pastor
                            _buildPastorSelector(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Ubicación
                    Container(
                        decoration: BoxDecoration(
                          color: ColorsUtils.segundoColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: ColorsUtils.principalColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildLocationSelector(),
                        )),
                    const SizedBox(height: 20),

                    // Información de ubicación geográfica
                    Container(
                      decoration: BoxDecoration(
                        color: ColorsUtils.segundoColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: ColorsUtils.principalColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildTextField(
                                        _ciudadController, 'Ciudad*', true)),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: _buildTextField(
                                        _provinciaController, 'Provincia')),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildTextField(
                                        _comunidadController, 'Comunidad')),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: _buildTextField(
                                        _regionController, 'Región')),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildTextField(
                                        _distritoController, 'Distrito')),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: _buildTextField(
                                        _zonaController, 'Zona')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Contacto
                    Container(
                      decoration: BoxDecoration(
                        color: ColorsUtils.segundoColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: ColorsUtils.principalColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            _buildTextField(_telefonoController, 'Teléfono'),
                            _buildTextField(_emailController, 'Email', false,
                                TextInputType.emailAddress),
                            _buildTextField(_webController, 'Sitio web', false,
                                TextInputType.url),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Información adicional
                    Container(
                      decoration: BoxDecoration(
                        color: ColorsUtils.segundoColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: ColorsUtils.principalColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            _buildTextField(_descripcionController,
                                'Descripción', false, null, 3),
                            _buildTextField(
                                _asistentesController,
                                'Número de asistentes',
                                false,
                                TextInputType.number),
                            _buildTextField(_horarioController,
                                'Horario de atención', false, null, 2),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Servicios de culto
                    _buildServiciosField(),
                    const SizedBox(height: 20),

                    // Imagen de portada
                    _buildImageUploadField(),
                    const SizedBox(height: 20),

                    // Galería de imágenes
                    _buildGaleriaField(),
                    const SizedBox(height: 20),
                    // Switch de activo
                    SwitchListTile(
                      title: const Text('Iglesia activa'),
                      value: _activo,
                      onChanged: (value) => setState(() => _activo = value),
                    ),

                    const SizedBox(height: 40),

                    // Botón de guardar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity, // ✅ Ancho completo
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsUtils.principalColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: _actualizarIglesia,
                          child: Text(
                            'Guardar Cambios',
                            style: TextStyle(
                              color: ColorsUtils.blancoColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      [bool isRequired = false,
      TextInputType? keyboardType,
      int maxLines = 1]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: ColorsUtils.blancoColor,
        ),
        decoration: ChurchTextFieldStyles.churchTextField(
          hintText: '',
          labelText: labelText,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: isRequired
            ? (value) =>
                value?.isEmpty ?? true ? 'Este campo es requerido' : null
            : null,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose de todos los controllers
    _tituloController.dispose();
    _direccionController.dispose();
    _comunidadController.dispose();
    _provinciaController.dispose();
    _ciudadController.dispose();
    _distritoController.dispose();
    _regionController.dispose();
    _zonaController.dispose();
    _descripcionController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _webController.dispose();
    _asistentesController.dispose();
    _horarioController.dispose();
    super.dispose();
  }
}
