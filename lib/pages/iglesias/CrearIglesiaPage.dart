import 'dart:io';

import 'package:conexion_mas/controllers/MisIglesiaService.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/MisIglesiaImagen.dart';
import 'package:conexion_mas/models/MisIglesias.dart';
import 'package:conexion_mas/utils/ChurchTextFieldStyles.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/widgets/GaleriaImagenesField.dart';
import 'package:conexion_mas/widgets/ImageUploadField.dart';
import 'package:conexion_mas/widgets/MapLocationSelector.dart';
import 'package:conexion_mas/widgets/PastorSelectorField.dart';
import 'package:conexion_mas/widgets/ServiciosInputField.dart';
import 'package:flutter/material.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:localstorage/localstorage.dart';

class CrearIglesiaPage extends StatefulWidget {
  final String token;
  final VoidCallback onIglesiaCreada;

  const CrearIglesiaPage({
    Key? key,
    required this.token,
    required this.onIglesiaCreada,
  }) : super(key: key);

  @override
  _CrearIglesiaPageState createState() => _CrearIglesiaPageState();
}

class _CrearIglesiaPageState extends State<CrearIglesiaPage> {
  final _formKey = GlobalKey<FormState>();
  final MisIglesiaService _iglesiaService = MisIglesiaService(
    baseUrl: MainUtils.urlHostApi,
  );

  // Controllers para todos los campos
  final _tituloController = TextEditingController();
  final _direccionController = TextEditingController();
  final _comunidadController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _distritoController = TextEditingController();
  final _regionController = TextEditingController();
  final _zonaController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _webController = TextEditingController();
  final _asistentesController = TextEditingController();
  final _serviciosController = TextEditingController();
  final _horarioController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  // Estados para los nuevos widgets
  String _serviciosJson = '{}';
  File? _nuevaImagenPortada;
  List<File> _nuevasImagenesGaleria = [];
  String? _pastorId;
  double? _latitud;
  double? _longitud;
  List<IglesiaImagen> _imagenesExistentes = [];

  bool _activo = false;
  bool _loading = false;
  bool _cargandoGaleria = true;

  File? _imagenPortada;
  List<File> _galeriaImagenes = [];

  Widget _buildServiciosField() {
    return ServiciosInputField(
      serviciosJson: _serviciosJson,
      onServiciosChanged: (nuevoJson) {
        setState(() => _serviciosJson = nuevoJson);
      },
    );
  }

  Widget _buildImageUploadField() {
    return ImageUploadField(
      onImageChanged: (imageFile) {
        setState(() => _imagenPortada = imageFile);
      },
    );
  }

  Widget _buildGaleriaField() {
    return GaleriaImagenesField(
      imagenes: null, // Para crear, no hay imágenes existentes
      onImagenesChanged: (imagenes) {
        setState(() => _galeriaImagenes = imagenes);
      },
      iglesiaId: '', // Se asignará después de crear
      token: widget.token,
    );
  }

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
          _latitud = location.latitude ?? 0.0;
          _longitud = location.longitude ?? 0.0;
        });
      },
      labelText: 'Ubicación de la iglesia',
    );
  }

  Future<void> _crearIglesia() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // 1. Crear la iglesia
      final nuevaIglesia = MisIglesia(
        idUsuario: localStorage.getItem('miIdUser').toString(),
        idIglesia: localStorage.getItem('miIglesia').toString(),
        idOrganizacion: localStorage.getItem('miOrganizacion').toString(),
        idPastor: _pastorId,
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
        latitud: _latitud?.toString(),
        longitud: _longitud?.toString(),
        telefono:
            _telefonoController.text.isEmpty ? null : _telefonoController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        web: _webController.text.isEmpty ? null : _webController.text,
        asistentes: _asistentesController.text.isEmpty
            ? null
            : _asistentesController.text,
        servicios: _serviciosJson,
        horario:
            _horarioController.text.isEmpty ? null : _horarioController.text,
        activo: _activo ? "1" : "0",
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      );

      final iglesiaCreada =
          await _iglesiaService.crearIglesia(nuevaIglesia, widget.token);

      bool success = iglesiaCreada["success"];
      String message = iglesiaCreada["message"];
      Map<String, dynamic> data = iglesiaCreada["data"];

      // 2. Subir imagen de portada si existe
      if (_imagenPortada != null) {
        await _iglesiaService.subirImagenPortada(
          iglesiaCreada["data"]["idIglesia"].toString(),
          _imagenPortada!,
          widget.token,
        );
      }

      // 3. Subir imágenes de la galería
      for (final imagen in _galeriaImagenes) {
        await _iglesiaService.subirImagenGaleria(
          iglesiaCreada["data"]["idIglesia"].toString(),
          imagen,
          widget.token,
        );
      }

      AppSnackbar.show(
        context,
        message: 'Iglesia creada correctamente',
        type: SnackbarType.success,
      );

      widget.onIglesiaCreada();
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
          'Crear Iglesia',
          style: TextStyle(color: ColorsUtils.blancoColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _loading ? null : _crearIglesia,
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
                    // Campos principales
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
                          child: _buildLocationSelector(),
                        )),
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
                        child: Column(
                          children: [
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
                            _buildTextField(_telefonoController, 'Teléfono*',
                                true, TextInputType.phone),
                            _buildTextField(_emailController, 'Email', false,
                                TextInputType.emailAddress),
                            _buildTextField(_webController, 'Sitio web', false,
                                TextInputType.url),

                            // Información adicional
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

                    _buildServiciosField(),
                    const SizedBox(height: 20),

                    _buildImageUploadField(),
                    const SizedBox(height: 30),

                    _buildGaleriaField(),
                    const SizedBox(height: 20),

                    // Switch de activo
                    SwitchListTile(
                      title: const Text('Iglesia activa'),
                      value: _activo,
                      onChanged: (value) => setState(() => _activo = value),
                    ),

                    const SizedBox(height: 40),

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
                          onPressed: _crearIglesia,
                          child: Text(
                            'Crear Cambios',
                            style: TextStyle(
                              color: ColorsUtils.blancoColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
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
    _serviciosController.dispose();
    _horarioController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    super.dispose();
  }
}
