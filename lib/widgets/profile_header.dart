import 'package:conexion_mas/screens/user_follow_list.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:conexion_mas/models/UserProfile.dart';
import 'package:conexion_mas/widgets/user_follow_button.dart';
import 'package:localstorage/localstorage.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onEditPressed;
  final bool? isFollowing; // ← NUEVO: Recibir estado de seguimiento
  final int? currentUserId; // ← NUEVO: ID del usuario actual

  const ProfileHeader({
    Key? key,
    required this.profile,
    this.onEditPressed,
    this.isFollowing, // ← NUEVO
    this.currentUserId, // ← NUEVO
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsUtils.terceroColor,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: profile.fotoPerfil != null
                ? NetworkImage(
                    "${MainUtils.urlHostAssets}/${profile.fotoPerfil!}")
                : AssetImage('assets/images/default_avatar.png')
                    as ImageProvider,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.nombre} ${profile.apellidos}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(profile.email),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ← NUEVO: Hacer clickables los contadores
                    GestureDetector(
                      onTap: () {
                        if (profile.seguidores > 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFollowListScreen(
                                userId: profile.id,
                                type: 'seguidores',
                              ),
                            ),
                          );
                        }
                      },
                      child:
                          _buildStatsColumn(profile.seguidores, 'Seguidores'),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (profile.siguiendo > 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFollowListScreen(
                                userId: profile.id,
                                type: 'siguiendo',
                              ),
                            ),
                          );
                        }
                      },
                      child: _buildStatsColumn(profile.siguiendo, 'Siguiendo'),
                    ),
                    _buildStatsColumn(
                        profile.iglesiasFavoritas.length +
                            profile.eventosFavoritos.length,
                        'Favoritos'),
                  ],
                ),
                // ← NUEVO: Mostrar botón de seguir si es perfil de otro usuario
                if (currentUserId != null && currentUserId != profile.id)
                  Align(
                    alignment: Alignment.centerRight,
                    child: UserFollowButton(
                      userId: profile.id,
                      userName: '${profile.nombre} ${profile.apellidos}',
                      isFollowing: isFollowing ?? false,
                      userToken: localStorage.getItem('miToken').toString(), 
                      smallVersion: false,
                    ),
                  ),
                if (onEditPressed != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onEditPressed,
                      child: Text('Editar Perfil'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsColumn(int count, String label) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
