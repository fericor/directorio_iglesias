import 'dart:convert';

import 'package:conexion_mas/controllers/AuthService.dart';
import 'package:conexion_mas/controllers/reservasApiClient.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/pages/main.page.dart';
import 'package:conexion_mas/screens/RegisterScreen.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/validationForm.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class LoginScreen extends StatefulWidget {
  final PageController controller;
  const LoginScreen({super.key, required this.controller});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _handleLogin() async {
    await initLocalStorage();

    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.show(
        context,
        message: 'Por favor, completa todos los campos',
        type: SnackbarType.error,
      );
      return;
    }

    if (Validator.validateEmail(email) != null) {
      AppSnackbar.show(
        context,
        message: Validator.validateEmail(email)!,
        type: SnackbarType.error,
      );
      return;
    }

    try {
      var iTems = await AuthService().login(email, password);
      Map myMap = jsonDecode(iTems!);

      if (myMap['res']) {
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

        // Setear el token en el ApiService
        ReservasApiClient.setApiToken(myMap['token'].toString());

        updateTokenNotificaciones(
          myMap['idUser'].toString(),
          localStorage.getItem('miTokenNotificaciones')!.toString(),
          myMap['token'].toString(),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPageView()),
        );
      } else {
        AppSnackbar.show(
          context,
          message: myMap['message'],
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        context,
        message: "Error de inicio de sesion. Intenta nuevamente",
        type: SnackbarType.warning,
      );
    }
  }

  Future<void> updateTokenNotificaciones(
      String idUser, String idDevice, String token) async {
    await AuthService().updateTokenNotification(
      idUser,
      token,
      idDevice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.blancoColor,
      body: Stack(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 52,
                      color: ColorsUtils.principalColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Inicia sesión para continuar.',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorsUtils.negroColor,
                    ),
                  ),
                  SizedBox(height: 32),
                  TextFormField(
                    validator: Validator.validateEmail,
                    controller: _emailController,
                    style: TextStyle(color: ColorsUtils.negroColor),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: ColorsUtils.negroColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsUtils.principalColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsUtils.principalColor),
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
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: TextStyle(color: ColorsUtils.negroColor),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: ColorsUtils.negroColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsUtils.principalColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsUtils.principalColor),
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
                  SizedBox(height: 32),
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
                        _handleLogin();
                      },
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtils.blancoColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes una cuenta?',
                        style: TextStyle(color: ColorsUtils.negroColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            color: ColorsUtils.principalColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
