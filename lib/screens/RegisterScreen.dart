import 'dart:convert';
import 'dart:io';

import 'package:directorio_iglesias/controllers/AuthService.dart';
import 'package:directorio_iglesias/pages/main.page.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:directorio_iglesias/utils/validatorInputs.dart';
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
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final telefono = _telefonoController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        var iTems =
            await AuthService().register(nombre, telefono, email, password);
        Map myMap = jsonDecode(iTems);

        _handleLogin();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            duration: Duration(seconds: 10),
            content: Text(
              "Tu cuenta ha sido creada con exito.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              showCloseIcon: true,
              backgroundColor: Colors.red,
              duration: Duration(seconds: 20),
              content: Text(
                "Ya existe un usuario con esos datos.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              )),
        );
      }
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
                        color: Colors.black,
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
                    SizedBox(height: 10),
                    TextFormField(
                      validator: ValidatorInputs().validatePassword,
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
                          _handleRegister();
                        },
                        child: Text(
                          'Crear cuenta',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                    color: Colors.black,
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
