// screens/user_list_screen.dart (NUEVO ARCHIVO)
import 'dart:convert';

import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import '../widgets/user_follow_button.dart';
import './profile_screen.dart';

class UserListScreen extends StatefulWidget {
  final String title;
  final String? searchQuery;

  const UserListScreen({Key? key, required this.title, this.searchQuery})
      : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      String endpoint =
          '${MainUtils.urlHostApi}/usuarios?api_token=${localStorage.getItem('miToken').toString()}';
      if (widget.searchQuery != null) {
        endpoint += '&busqueda=${Uri.encodeComponent(widget.searchQuery!)}';
      }

      final response = await http.get(Uri.parse(endpoint));
      var data = json.decode(response.body);

      setState(() {
        _users = data ?? [];
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);

      AppSnackbar.show(
        context,
        message: 'Error al cargar usuarios: $error',
        type: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.fondoColor,
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(color: ColorsUtils.blancoColor)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text('No se encontraron usuarios'))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user['foto_perfil'] != null
                            ? NetworkImage(
                                "${MainUtils.urlHostAssets}/${user['foto_perfil']}")
                            : AssetImage('assets/images/default_avatar.png')
                                as ImageProvider,
                      ),
                      title: Text('${user['nombre']} ${user['apellidos']}'),
                      subtitle: Text(user['email'] ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userId: user['id']),
                          ),
                        );
                      },
                      trailing: UserFollowButton(
                        userId: user['id'],
                        userName: '${user['nombre']} ${user['apellidos']}',
                        userToken: localStorage.getItem('miToken').toString(),
                        isFollowing: false, 
                        smallVersion: false,
                      ),
                    );
                  },
                ),
    );
  }
}
