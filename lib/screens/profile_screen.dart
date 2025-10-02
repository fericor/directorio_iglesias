import 'package:conexion_mas/controllers/ProfileServide.dart';
import 'package:conexion_mas/controllers/user_follow_service.dart';
import 'package:conexion_mas/models/UserProfile.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/widgets/user_follow_button.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../widgets/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  final int? userId;

  const ProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _checkIfFollowing();
  }

  Future<void> _loadUserProfile() async {
    try {
      final response = await ProfileService.getUserProfile(widget.userId);
      setState(() {
        _userProfile = UserProfile.fromJson(response['data']);
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el perfil: $error')),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (_userProfile == null) return;

    try {
      final response =
          await ProfileService.updateUserProfile(_userProfile!.toJson());
      setState(() {
        _userProfile = UserProfile.fromJson(response['data']);
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado correctamente')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el perfil: $error')),
      );
    }
  }

  // ← NUEVO: Verificar si sigues a este usuario
  Future<void> _checkIfFollowing() async {
    if (widget.userId == null) return; // No verificar si es tu propio perfil

    try {
      final isFollowing = await UserFollowService.checkIfFollowingUser(
          widget.userId!, localStorage.getItem('miToken').toString());

      setState(() {
        _isFollowing = isFollowing;
      });
    } catch (error) {
      print('Error checking follow status: $error');
    }
  }

  // ← NUEVO: Actualizar estado de seguimiento
  void _onFollowStateChanged(bool isFollowing) {
    setState(() {
      _isFollowing = isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.fondoColor,
      appBar: AppBar(
        title: Text(
          'Perfil de Usuario',
          style: TextStyle(color: ColorsUtils.blancoColor),
        ),
        actions: [
          // ← NUEVO: Mostrar botón de seguir si es perfil de otro usuario
          if (widget.userId != null && _userProfile != null)
            UserFollowButton(
              userId: widget.userId!,
              userName: '${_userProfile!.nombre} ${_userProfile!.apellidos}',
              onStateChanged: _onFollowStateChanged,
              isFollowing: false,
              userToken: localStorage.getItem('miToken').toString(),
              smallVersion: false,
            ),

          if (widget.userId == null && !_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _updateProfile,
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => setState(() => _isEditing = false),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userProfile == null
              ? Center(child: Text('No se pudo cargar el perfil'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      ProfileHeader(
                        profile: _userProfile!,
                        onEditPressed: widget.userId != null
                            ? () => setState(() => _isEditing = true)
                            : null,
                      ),
                      SizedBox(height: 16),
                      _isEditing ? _buildEditForm() : _buildProfileInfo(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_userProfile!.biografia != null &&
              _userProfile!.biografia!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biografía',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(_userProfile!.biografia!),
                SizedBox(height: 16),
              ],
            ),
          Text(
            'Información de Contacto',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Teléfono: ${_userProfile!.telefono}'),
          Text('Género: ${_userProfile!.genero}'),
          Text(
              'Fecha de Nacimiento: ${_userProfile!.nacimiento.toString().split(' ')[0]}'),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            initialValue: _userProfile!.biografia,
            decoration: InputDecoration(
              labelText: 'Biografía',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (value) {
              setState(() {
                _userProfile = UserProfile(
                  id: _userProfile!.id,
                  nombre: _userProfile!.nombre,
                  apellidos: _userProfile!.apellidos,
                  email: _userProfile!.email,
                  fotoPerfil: _userProfile!.fotoPerfil,
                  biografia: value,
                  nacimiento: _userProfile!.nacimiento,
                  genero: _userProfile!.genero,
                  telefono: _userProfile!.telefono,
                  iglesiasFavoritas: _userProfile!.iglesiasFavoritas,
                  eventosFavoritos: _userProfile!.eventosFavoritos,
                  seguidores: _userProfile!.seguidores,
                  siguiendo: _userProfile!.siguiendo,
                );
              });
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            initialValue: _userProfile!.telefono,
            decoration: InputDecoration(
              labelText: 'Teléfono',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _userProfile = UserProfile(
                  id: _userProfile!.id,
                  nombre: _userProfile!.nombre,
                  apellidos: _userProfile!.apellidos,
                  email: _userProfile!.email,
                  fotoPerfil: _userProfile!.fotoPerfil,
                  biografia: _userProfile!.biografia,
                  nacimiento: _userProfile!.nacimiento,
                  genero: _userProfile!.genero,
                  telefono: value,
                  iglesiasFavoritas: _userProfile!.iglesiasFavoritas,
                  eventosFavoritos: _userProfile!.eventosFavoritos,
                  seguidores: _userProfile!.seguidores,
                  siguiendo: _userProfile!.siguiendo,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
