import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/MisUsuarios.dart';
import 'package:conexion_mas/pages/usuarios/usuario_manager.dart';
import 'package:conexion_mas/utils/ChurchTextFieldStyles.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class FormularioUsuarioScreen extends StatefulWidget {
  final int idIglesia;
  final MisUsuario? usuario;
  final UsuarioManager usuarioManager;

  const FormularioUsuarioScreen({
    super.key,
    required this.idIglesia,
    this.usuario,
    required this.usuarioManager,
  });

  @override
  _FormularioUsuarioScreenState createState() =>
      _FormularioUsuarioScreenState();
}

class _FormularioUsuarioScreenState extends State<FormularioUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'miembro';
  String? _selectedGenero;
  DateTime? _selectedDate;
  int _aceptadaPolitica = 0;
  int _aceptadaComunicados = 0;
  int _activo = 1;
  bool _isEditing = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _cargando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.usuario != null;

    if (_isEditing) {
      _cargarDatosUsuario();
    }
  }

  void _cargarDatosUsuario() {
    final usuario = widget.usuario!;
    _nombreController.text = usuario.nombre!;
    _apellidosController.text = usuario.apellidos!;
    _emailController.text = usuario.email!;
    _telefonoController.text = usuario.telefono ?? '';
    _selectedRole = usuario.role!;
    _selectedGenero = usuario.genero;

    if (usuario.nacimiento != null) {
      _selectedDate = DateTime.parse(usuario.nacimiento!);
    }

    _aceptadaPolitica = usuario.aceptadaPoliticaPrivacidad!;
    _aceptadaComunicados = usuario.aceptadaComunicados!;
    _activo = usuario.activo!;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _setCargando(bool cargando) {
    setState(() {
      _cargando = cargando;
    });
  }

  void _setError(String? error) {
    setState(() {
      _error = error;
    });

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  bool _validarFormulario() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (!_isEditing) {
      if (_passwordController.text != _confirmPasswordController.text) {
        _setError('Las contraseñas no coinciden');
        return false;
      }

      if (_passwordController.text.length < 6) {
        _setError('La contraseña debe tener al menos 6 caracteres');
        return false;
      }
    }

    if (_aceptadaPolitica == 0) {
      _setError('Debe aceptar la política de privacidad');
      return false;
    }

    return true;
  }

  Future<void> _guardarUsuario() async {
    if (!_validarFormulario()) return;

    _setCargando(true);
    _setError(null);

    try {
      final usuario = MisUsuario(
        id: _isEditing ? widget.usuario!.id : null,
        idIglesia: widget.idIglesia,
        nombre: _nombreController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        email: _emailController.text.trim(),
        password:
            _isEditing ? widget.usuario!.password : _passwordController.text,
        role: "10",
        genero: _selectedGenero,
        telefono: _telefonoController.text.trim().isEmpty
            ? null
            : _telefonoController.text.trim(),
        nacimiento: _selectedDate?.toIso8601String().split('T')[0],
        aceptadaPoliticaPrivacidad: _aceptadaPolitica,
        aceptadaComunicados: _aceptadaComunicados,
        activo: _activo,
        idOrganizacion:
            int.parse(localStorage.getItem('miOrganizacion').toString()),
      );

      if (_isEditing) {
        await widget.usuarioManager.actualizarUsuario(usuario);

        AppSnackbar.show(
          context,
          message: 'Usuario actualizado correctamente',
          type: SnackbarType.success,
        );
      } else {
        await widget.usuarioManager.agregarUsuario(usuario);
        AppSnackbar.show(
          context,
          message: 'Usuario creado correctamente',
          type: SnackbarType.success,
        );
      }

      Navigator.pop(context);
    } catch (e) {
      _setError('Error al guardar usuario: $e');
    } finally {
      _setCargando(false);
    }
  }

  Future<bool> _onWillPop() async {
    if (_cargando) return false;

    final bool? shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Salir sin guardar?'),
        content: const Text('Los cambios no guardados se perderán.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    bool obligatorio = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: ColorsUtils.blancoColor,
      ),
      decoration: ChurchTextFieldStyles.churchTextField(
        hintText: '',
        labelText: '$label${obligatorio ? ' *' : ''}',
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: obscureText,
      validator: validator ??
          (obligatorio
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese $label';
                  }
                  return null;
                }
              : null),
    );
  }

  Widget _buildDropdownGenero() {
    return DropdownButtonFormField<String>(
      value: _selectedGenero,
      items: [
        const DropdownMenuItem(
            value: null, child: Text('Seleccionar sociedad')),
        const DropdownMenuItem(value: 'Damas', child: Text('Damas')),
        const DropdownMenuItem(value: 'Caballeros', child: Text('Caballeros')),
        const DropdownMenuItem(value: 'Jovenes', child: Text('Jovenes')),
        const DropdownMenuItem(
            value: 'Escuela Dominical', child: Text('Escuela Dominical')),
        const DropdownMenuItem(value: 'Otros', child: Text('Otros')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedGenero = value;
        });
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: ColorsUtils.terceroColor,
        hintText: 'Género',
        hintStyle: TextStyle(color: ColorsUtils.blancoColor),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      ),
    );
  }

  Widget _buildDropdownRol() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      items: ['admin', 'pastor', 'lider', 'miembro', 'visitante']
          .map((rol) => DropdownMenuItem(
                value: rol,
                child: Text(rol[0].toUpperCase() + rol.substring(1)),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedRole = value!;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Rol *',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor seleccione un rol';
        }
        return null;
      },
    );
  }

  Widget _buildCampoPassword({
    required TextEditingController controller,
    required String label,
    bool obligatorio = false,
    bool showPassword = false,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: '$label${obligatorio ? ' *' : ''}',
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleVisibility,
        ),
      ),
      obscureText: !showPassword,
      validator: obligatorio
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese $label';
              }
              if (value.length < 6) {
                return 'La $label debe tener al menos 6 caracteres';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildFechaNacimiento() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsUtils.terceroColor,
        //border: Border.all(color: ColorsUtils.terceroColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ListTile(
        title: Text(
          _selectedDate == null
              ? 'Seleccionar fecha de nacimiento'
              : 'Fecha de nacimiento: ${_selectedDate!.toString().split(' ')[0]}',
          style: TextStyle(
            color: _selectedDate == null
                ? ColorsUtils.blancoColor
                : ColorsUtils.blancoColor,
          ),
        ),
        trailing: Icon(Icons.calendar_today, color: ColorsUtils.principalColor),
        onTap: () => _selectDate(context),
      ),
    );
  }

  Widget _buildSwitch(String title, int value, ValueChanged<int> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value == 1,
      onChanged: (newValue) => onChanged(newValue ? 1 : 0),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        titulo,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ColorsUtils.principalColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: ColorsUtils.fondoColor,
        appBar: AppBar(
          title: Text(
            _isEditing ? 'Editar Usuario' : 'Nuevo Usuario',
            style: TextStyle(
              color: ColorsUtils.blancoColor,
            ),
          ),
          actions: [
            if (_cargando)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _guardarUsuario,
                tooltip: 'Guardar',
              ),
          ],
        ),
        body: _cargando
            ? const Center(child: CircularProgressIndicator())
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        _buildSeccionTitulo('Información Personal'),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsUtils.principalColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                // Campo Nombre
                                _buildCampoTexto(
                                  controller: _nombreController,
                                  label: 'Nombre',
                                  obligatorio: true,
                                ),
                                const SizedBox(height: 16),

                                // Campo Apellidos
                                _buildCampoTexto(
                                  controller: _apellidosController,
                                  label: 'Apellidos',
                                  obligatorio: true,
                                ),
                                const SizedBox(height: 16),

                                // Campo Teléfono
                                _buildCampoTexto(
                                  controller: _telefonoController,
                                  label: 'Teléfono',
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),

                                // Dropdown Género
                                _buildDropdownGenero(),
                                const SizedBox(height: 16),

                                // Fecha de Nacimiento
                                _buildFechaNacimiento(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildSeccionTitulo('Credenciales'),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsUtils.principalColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                // Campo Email
                                _buildCampoTexto(
                                  controller: _emailController,
                                  label: 'Email',
                                  obligatorio: true,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Por favor ingrese el email';
                                    }
                                    if (!value.contains('@') ||
                                        !value.contains('.')) {
                                      return 'Ingrese un email válido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Campos de contraseña (solo para nuevo usuario)
                                if (!_isEditing) ...[
                                  _buildCampoPassword(
                                    controller: _passwordController,
                                    label: 'Contraseña',
                                    obligatorio: true,
                                    showPassword: _showPassword,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCampoPassword(
                                    controller: _confirmPasswordController,
                                    label: 'Confirmar Contraseña',
                                    obligatorio: true,
                                    showPassword: _showConfirmPassword,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _showConfirmPassword =
                                            !_showConfirmPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Dropdown Rol
                                // _buildDropdownRol(),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        _buildSeccionTitulo('Preferencias'),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsUtils.principalColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                // Switches
                                _buildSwitch(
                                  'Aceptada política de privacidad *',
                                  _aceptadaPolitica,
                                  (value) =>
                                      setState(() => _aceptadaPolitica = value),
                                ),

                                _buildSwitch(
                                  'Aceptada comunicados',
                                  _aceptadaComunicados,
                                  (value) => setState(
                                      () => _aceptadaComunicados = value),
                                ),

                                _buildSwitch(
                                  'Usuario activo',
                                  _activo,
                                  (value) => setState(() => _activo = value),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Botón Guardar
                        ElevatedButton(
                          onPressed: _guardarUsuario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsUtils.principalColor,
                            foregroundColor: ColorsUtils.blancoColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            _isEditing ? 'ACTUALIZAR USUARIO' : 'CREAR USUARIO',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Botón Cancelar
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            side: BorderSide(color: ColorsUtils.principalColor),
                          ),
                          child: Text(
                            'CANCELAR',
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorsUtils.principalColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 16),
                                  onPressed: () =>
                                      setState(() => _error = null),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
