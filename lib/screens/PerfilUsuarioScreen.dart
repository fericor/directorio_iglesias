import 'dart:convert';
import 'dart:io';

import 'package:directorio_iglesias/controllers/AuthService.dart';
import 'package:directorio_iglesias/pages/main.page.dart';
import 'package:directorio_iglesias/screens/cambioPassScreen.dart';
import 'package:directorio_iglesias/screens/editarPerfilScreen.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:directorio_iglesias/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen>
    with SingleTickerProviderStateMixin {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  String idUser = "0";
  String nombre = "";
  String email = "";

  @override
  void initState() {
    super.initState();

    infoUser();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> infoUser() async {
    await initLocalStorage();

    var iTems = await AuthService().infoUser(
        localStorage.getItem('miIdUser').toString(),
        localStorage.getItem('miToken').toString());
    Map myMap = jsonDecode(iTems);

    setState(() {
      nombre = "${myMap['nombre']} ${myMap['apellidos']}";
      email = myMap['email'];
      idUser = myMap['id'].toString();
    });
  }

  Future<void> logout() async {
    await initLocalStorage();

    localStorage.setItem('isLogin', 'false');
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
            top: Platform.isAndroid ? 30 : 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            "${MainUtils.urlHostAssets}/images/users/user_$idUser.png",
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          nombre,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 18,
                            color: ColorsUtils.principalColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                buildOption(
                  icon: Icons.person,
                  title: 'Editar Perfil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditarPerfilScreen()),
                    );
                    // Acción al tocar
                    /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Editar Perfil seleccionado')),
                    );*/
                  },
                ),
                buildOption(
                  icon: Icons.meeting_room,
                  title: 'Llamadas',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Editar Perfil seleccionado')),
                    );
                  },
                ),
                buildOption(
                  icon: Icons.lock,
                  title: 'Cambiar Contraseña',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CambioContrasenaScreen()),
                    );
                    // Acción al tocar
                    /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Cambiar Contraseña seleccionado')),
                    );*/
                  },
                ),
                buildOption(
                  icon: Icons.settings,
                  title: 'Configuración',
                  onTap: () {
                    // Acción al tocar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Configuración seleccionada')),
                    );
                  },
                ),
                SizedBox(
                  height: 60.0,
                ),
                buildOptionSimple(
                  icon: Icons.logout,
                  title: 'Cerrar Sesión',
                  onTap: () {
                    logout();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPageView()),
                    );
                    // Acción al tocar
                    /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cerrar Sesión seleccionado')),
                    );*/
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 90,
            left: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Version",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: "Roboto",
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  _packageInfo.version,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////
  Widget buildOption(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: ColorsUtils.principalColor, size: 28),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget buildOptionSimple(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: ColorsUtils.principalColor, size: 28),
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
      ),
      // trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
  //////////////////////////////////////////
}
