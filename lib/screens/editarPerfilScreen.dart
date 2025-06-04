import 'dart:convert';
import 'dart:io';

import 'package:directorio_iglesias/controllers/AuthService.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:directorio_iglesias/utils/validatorInputs.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _nacimientoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    infoUser();
  }

  Future<void> infoUser() async {
    await initLocalStorage();

    var iTems = await AuthService().infoUser(
        localStorage.getItem('miIdUser').toString(),
        localStorage.getItem('miToken').toString());
    Map myMap = jsonDecode(iTems);

    _nombreController.text = myMap['nombre'];
    _apellidosController.text = myMap['apellidos'];
    _nacimientoController.text = myMap['nacimiento'];
    _telefonoController.text = myMap['telefono'];
    _emailController.text = myMap['email'];
  }

  Future<void> _handleActualizarPerfil() async {
    await initLocalStorage();

    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final apellidos = _apellidosController.text;
      final nacimiento = _nacimientoController.text;
      final telefono = _telefonoController.text;
      final email = _emailController.text;

      try {
        var iTems = await AuthService().updateProfiler(
            localStorage.getItem('miIdUser').toString(),
            nombre,
            apellidos,
            nacimiento,
            telefono,
            email,
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      'Mi perfil',
                      style: TextStyle(
                        fontSize: 52,
                        color: ColorsUtils.principalColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cambia la información de tu perfil de la APP.',
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa tus apellidos';
                        } else if (value.length < 3) {
                          return 'Los apellidos debe tener al menos 3 caracteres';
                        }
                        return null;
                      },
                      controller: _apellidosController,
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
                        labelText: 'Apellidos',
                        prefixIcon: Icon(
                          Icons.person_outline_sharp,
                          color: ColorsUtils.principalColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      onTap: () => showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          _nacimientoController.text =
                              value.toString().substring(0, 10);
                        }
                      }),
                      validator: (value) {
                        return null;
                      },
                      controller: _nacimientoController,
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
                        labelText: 'Fecha de nacimiento',
                        prefixIcon: Icon(
                          Icons.calendar_month,
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
                      readOnly: true,
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
                          _handleActualizarPerfil();
                        },
                        child: Text(
                          'Actualizar perfil',
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
