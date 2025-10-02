import 'dart:convert';
import 'dart:io';

import 'package:conexion_mas/controllers/AuthService.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/iglesia.dart';
import 'package:conexion_mas/pages/main.page.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:conexion_mas/utils/validationForm.dart';
import 'package:conexion_mas/utils/validatorInputs.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:conexion_mas/widgets/checkPoliticaForm.dart';
import 'package:conexion_mas/widgets/selectForm.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  Iglesia? _iglesiaSeleccionada;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleLogin() async {
    await initLocalStorage();

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      var iTems = await AuthService().login(email, password);
      Map myMap = jsonDecode(iTems!);

      localStorage.setItem('miToken', myMap['token'].toString());
      localStorage.setItem('miIdUser', myMap['idUser'].toString());
      localStorage.setItem('miEmail', myMap['email'].toString());
      localStorage.setItem('miIglesia', myMap['idIglesia'].toString());
      localStorage.setItem(
          'miOrganizacion', myMap['idOrganizacion'].toString());

      localStorage.setItem('miDistrito', myMap['distrito'].toString());
      localStorage.setItem('miRegion', myMap['region'].toString());
      localStorage.setItem('miRole', myMap['role'].toString());

      localStorage.setItem('isLogin', 'true');
      localStorage.setItem('miUser', email);
      localStorage.setItem('miPass', password);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPageView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _handleRegister() async {
    setState(() => _isLoading = false);

    if (Validator.validateName(_nombreController.text) != null) {
      AppSnackbar.show(
        context,
        message: Validator.validateName(_nombreController.text)!,
        type: SnackbarType.error,
      );
      return;
    }

    if (Validator.validatePhone(_telefonoController.text) != null) {
      AppSnackbar.show(
        context,
        message: Validator.validatePhone(_telefonoController.text)!,
        type: SnackbarType.error,
      );
      return;
    }

    if (Validator.validateEmail(_emailController.text) != null) {
      AppSnackbar.show(
        context,
        message: Validator.validateEmail(_emailController.text)!,
        type: SnackbarType.error,
      );
      return;
    }

    if (Validator.validatePassword(_passwordController.text) != null) {
      AppSnackbar.show(
        context,
        message: Validator.validatePassword(_passwordController.text)!,
        type: SnackbarType.error,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final telefono = _telefonoController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final iglesiaId = _iglesiaSeleccionada?.idIglesia;

      try {
        if (iglesiaId == null) {
          AppSnackbar.show(
            context,
            message: 'Tiene que seleccionar una iglesia',
            type: SnackbarType.error,
          );
        } else {
          var iTems = await AuthService()
              .register(nombre, telefono, email, password, iglesiaId);
          Map<String, dynamic> myMap = jsonDecode(iTems!);

          if (myMap["res"] != "false") {
            AppSnackbar.show(
              context,
              message: "Tu cuenta ha sido creada con exito.",
              type: SnackbarType.success,
            );

            Navigator.pop(context);
          } else {
            AppSnackbar.show(
              context,
              message: myMap["message"],
              type: SnackbarType.error,
            );
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              showCloseIcon: true,
              backgroundColor: ColorsUtils.principalColor,
              duration: Duration(seconds: 20),
              content: Text(
                "Ya existe un usuario con esos datos.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorsUtils.blancoColor,
                  fontSize: 18,
                ),
              )),
        );*/
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.blancoColor,
      body: _isLoading
          ? frcaWidget.frca_loading_container()
          : Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 120,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff6f8fe),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registrate',
                            style: TextStyle(
                              fontSize: 52,
                              color: ColorsUtils.principalColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Crea tu cuenta en nuestra APP.',
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorsUtils.negroColor,
                            ),
                          ),
                          SizedBox(height: 32),
                          ////////////////////////////////////////////////////////////////
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Ingresa tu nombre';
                              } else if (value.length < 3) {
                                return 'El nombre debe tener al menos 3 caracteres';
                              }
                              return null;
                            },
                            controller: _nombreController,
                            style: TextStyle(color: ColorsUtils.negroColor),
                            decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: ColorsUtils.negroColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorsUtils.principalColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorsUtils.principalColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: 'Nombre',
                              prefixIcon: Icon(
                                Icons.person,
                                color: ColorsUtils.principalColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            validator: ValidatorInputs().validateMobile,
                            controller: _telefonoController,
                            style: TextStyle(color: ColorsUtils.negroColor),
                            decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: ColorsUtils.negroColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorsUtils.principalColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorsUtils.principalColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: 'Teléfono',
                              prefixIcon: Icon(
                                Icons.phone,
                                color: ColorsUtils.principalColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: ValidatorInputs().validateEmail,
                            controller: _emailController,
                            style: TextStyle(color: ColorsUtils.negroColor),
                            decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: ColorsUtils.negroColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorsUtils.principalColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorsUtils.principalColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: ColorsUtils.principalColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: ValidatorInputs().validatePassword,
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            style: TextStyle(color: ColorsUtils.negroColor),
                            decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: ColorsUtils.negroColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorsUtils.principalColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorsUtils.principalColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: 'Contraseña',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: ColorsUtils.principalColor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: ColorsUtils.principalColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              suffixStyle: TextStyle(
                                color: ColorsUtils.principalColor,
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          //////////////////////////////
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                IglesiaDropdown(
                                  onIglesiaSeleccionada: (iglesia) {
                                    setState(() {
                                      _iglesiaSeleccionada = iglesia;
                                    });
                                  },
                                  hintText: 'Elige tu iglesia',
                                ),
                                const SizedBox(height: 10),
                                if (_iglesiaSeleccionada != null)
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${_iglesiaSeleccionada!.idIglesia}::${_iglesiaSeleccionada!.titulo}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: ColorsUtils.blancoColor,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                              'Dirección: ${_iglesiaSeleccionada!.direccion}'),
                                          Text(
                                              'Ciudad: ${_iglesiaSeleccionada!.ciudad}'),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Usando el FormField version
                          PoliticasFormField(
                            politicaPrivacidadUrl:
                                '${MainUtils.urlHostApi}/privacy-policy',
                            terminosCondicionesUrl:
                                '${MainUtils.urlHostApi}/terms-of-service',
                            mensajeError:
                                'Debes aceptar las políticas para registrarte',
                          ),
                          ///////////////////////////////
                          SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsUtils.principalColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                _handleRegister();
                              },
                              child: Text(
                                'Crear cuenta',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUtils.blancoColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: Platform.isAndroid ? 30 : 60,
                  left: 15,
                  right: 15,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: ColorsUtils.negroColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
