// screens/user_follow_list.dart
import 'package:conexion_mas/controllers/user_follow_service.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/widgets/user_follow_button.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import './profile_screen.dart';

class UserFollowListScreen extends StatefulWidget {
  final int userId;
  final String type; // 'seguidores' o 'siguiendo'

  const UserFollowListScreen({
    Key? key,
    required this.userId,
    required this.type,
  }) : super(key: key);

  @override
  _UserFollowListScreenState createState() => _UserFollowListScreenState();
}

class _UserFollowListScreenState extends State<UserFollowListScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      List<dynamic> users;
      if (widget.type == 'seguidores') {
        users = await UserFollowService.getUserFollowers(
            widget.userId, localStorage.getItem('miToken').toString());
      } else {
        users = await UserFollowService.getUserFollowing(
            widget.userId, localStorage.getItem('miToken').toString());
      }

      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ${widget.type}: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.fondoColor,
      appBar: AppBar(
        title: Text(
          widget.type == 'seguidores' ? 'Seguidores' : 'Siguiendo',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text('No hay ${widget.type}'))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user['foto_perfil'] != null
                            ? NetworkImage(user['foto_perfil'])
                            : AssetImage('assets/default_avatar.png')
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
                      trailing: user['id'] != widget.userId
                          ? UserFollowButton(
                              userId: user['id'],
                              userName:
                                  '${user['nombre']} ${user['apellidos']}',
                              isFollowing: false,
                              userToken:
                                  localStorage.getItem('miToken').toString(),
                              smallVersion: false,
                            )
                          : null,
                    );
                  },
                ),
    );
  }
}
