import 'dart:convert';
import 'dart:io';

import 'package:directorio_iglesias/controllers/AuthService.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:directorio_iglesias/utils/validatorInputs.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class CambioContrasenaScreen extends StatefulWidget {
  const CambioContrasenaScreen({super.key});

  @override
  State<CambioContrasenaScreen> createState() => _CambioContrasenaScreenState();
}

class _CambioContrasenaScreenState extends State<CambioContrasenaScreen> {
  final TextEditingController _passwordOldController = TextEditingController();
  final TextEditingController _passwordNewController = TextEditingController();
  final TextEditingController _passwordNewRepiteController =
      TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleCambioContrasena() async {
    await initLocalStorage();

    if (_formKey.currentState!.validate()) {
      final passOld = _passwordOldController.text;
      final passNew = _passwordNewController.text;
      final passNewRepite = _passwordNewRepiteController.text;

      try {
        if (passNew != passNewRepite) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.yellowAccent,
              showCloseIcon: true,
              duration: Duration(seconds: 15),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 70,
                    color: Colors.red,
                  ),
                  Expanded(
                    child: Text(
                      "Las contraseñas no coinciden.",
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
          return;
        } else {
          var iTems = await AuthService().changePass(
              localStorage.getItem('miIdUser').toString(),
              passOld,
              passNew,
              localStorage.getItem('miToken').toString());
          Map myMap = jsonDecode(iTems);

          if (myMap["res"] == true) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFFC6C6C6),
                showCloseIcon: true,
                duration: Duration(seconds: 15),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 70,
                      color: Colors.greenAccent,
                    ),
                    Expanded(
                      child: Text(
                        myMap["message"],
                        maxLines: 5,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.yellowAccent,
                showCloseIcon: true,
                duration: Duration(seconds: 15),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error,
                      size: 70,
                      color: Colors.red,
                    ),
                    Expanded(
                      child: Text(
                        myMap["message"],
                        maxLines: 5,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
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
                    "La contraseña no se ha podido cambiar. Contacta con el administrador.",
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
                      'Contraseña',
                      style: TextStyle(
                        fontSize: 52,
                        color: ColorsUtils.principalColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cambia la contraseña de acceso a la APP.',
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
                      controller: _passwordOldController,
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
                        labelText: 'Contraseña antigua',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: ColorsUtils.principalColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    TextFormField(
                      validator: ValidatorInputs().validatePassword,
                      controller: _passwordNewController,
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
                        labelText: 'Nueva contraseña',
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
                    SizedBox(height: 10),
                    TextFormField(
                      validator: ValidatorInputs().validatePassword,
                      controller: _passwordNewRepiteController,
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
                        labelText: 'Repite contraseña',
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
                          _handleCambioContrasena();
                        },
                        child: Text(
                          'Cambiar contraseña',
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
                  icon: Container(
                    decoration: BoxDecoration(
                      color: ColorsUtils.principalColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
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
