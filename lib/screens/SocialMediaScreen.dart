import 'package:directorio_iglesias/controllers/AuthService.dart';
import 'package:flutter/material.dart';

class SocialMediaRegisterScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  SocialMediaRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro con Redes Sociales')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                /* final user = await _authService.signInWithGoogle();
                if (user != null) {
                  print('Usuario registrado con Google: ${user.displayName}');
                }*/
              },
              icon: Icon(Icons.login),
              label: Text('Iniciar sesión con Google'),
            ),
            /*ElevatedButton.icon(
              onPressed: () async {
                final user = await _authService.signInWithFacebook();
                if (user != null) {
                  print('Usuario registrado con Facebook: ${user.displayName}');
                }
              },
              icon: Icon(Icons.facebook),
              label: Text('Iniciar sesión con Facebook'),
            ),*/
          ],
        ),
      ),
    );
  }
}
