import 'dart:convert';

import 'package:directorio_iglesias/controllers/AuthService.dart';
import 'package:directorio_iglesias/pages/main.page.dart';
import 'package:directorio_iglesias/screens/RegisterScreen.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
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

    try {
      var iTems = await AuthService().login(email, password);
      Map myMap = jsonDecode(iTems);

      localStorage.setItem('miToken', myMap['token'].toString());
      localStorage.setItem('miIdUser', myMap['idUser'].toString());
      localStorage.setItem('miEmail', myMap['email'].toString());

      localStorage.setItem('isLogin', 'true');
      localStorage.setItem('miUser', email);
      localStorage.setItem('miPass', password);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPageView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error,
                size: 70,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  "Error de inicio de sesion. Intenta nuevamente",
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
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
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
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
                          color: Colors.white,
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
                        style: TextStyle(color: Colors.black),
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
