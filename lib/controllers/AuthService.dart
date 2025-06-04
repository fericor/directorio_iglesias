import 'package:directorio_iglesias/utils/mainUtils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  final String baseUrl = MainUtils.urlHostApi;

  login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  infoUser(String idUser, String token) async {
    final url = Uri.parse('$baseUrl/usuarios/$idUser?api_token=$token');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  infoAjustes(String idEmpresa, String token) async {
    final url = Uri.parse('$baseUrl/sistema/getAjustes/$idEmpresa?api_token=$token');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  register(String nombre, telefono, email, password) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nombre': nombre, 'apellidos': '', 'nacimiento': '2025/01/01', 'telefono': telefono, 'email': email, 'password': password, 'role': '10', 'activo': '1',}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  changePass(String idUser, passOld, passNew, token) async {
    final url = Uri.parse('$baseUrl/usuarios/changePassword/$idUser?api_token=$token');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'passwordOld': passOld, 'passwordNew': passNew}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  updateProfiler(String idUser, nombre, apellidos, nacimiento, telefono, email, token) async {
    final url = Uri.parse('$baseUrl/usuarios/$idUser?api_token=$token');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nombre': nombre, 'apellidos': apellidos, 'nacimiento': nacimiento, 'telefono': telefono, 'email': email,}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  /*Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      return null;
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
      return null;
    } catch (e) {
      print('Error al iniciar sesión con Facebook: $e');
      return null;
    }
  }*/

}
