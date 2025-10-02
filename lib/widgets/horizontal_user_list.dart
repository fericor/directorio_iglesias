// widgets/horizontal_user_list.dart
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import './user_follow_button.dart';
import '../screens/profile_screen.dart';

class HorizontalUserList extends StatelessWidget {
  final List<dynamic> users;
  final String title;
  final bool showTitle;
  final VoidCallback? onSeeAll;
  final Axis scrollDirection;

  const HorizontalUserList({
    Key? key,
    required this.users,
    this.title = 'Usuarios',
    this.showTitle = true,
    this.onSeeAll,
    this.scrollDirection = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    child: Text(
                      'Ver todos',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Container(
          height: scrollDirection == Axis.horizontal ? 140 : null,
          child: ListView.builder(
            scrollDirection: scrollDirection,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _UserCard(
                user: user,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(userId: user['id']),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _UserCard extends StatelessWidget {
  final dynamic user;
  final VoidCallback onTap;

  const _UserCard({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar con tap al perfil
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: user['foto_perfil'] != null
                  ? NetworkImage(user['foto_perfil']!)
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
              child: user['foto_perfil'] == null
                  ? Icon(Icons.person, size: 30, color: Colors.white)
                  : null,
            ),
          ),
          SizedBox(height: 8),

          // Nombre (truncado si es muy largo)
          GestureDetector(
            onTap: onTap,
            child: Text(
              '${user['nombre']} ${user['apellidos']}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 4),

          // Botón de seguir compacto
          UserFollowButton(
            userId: user['id'],
            userName: '${user['nombre']} ${user['apellidos']}',
            showLabel: false,
            smallVersion: true,
            userToken: localStorage.getItem('miToken').toString(),
          ),
        ],
      ),
    );
  }
}

// Versión alternativa con tarjetas más elaboradas
class UserGridCard extends StatelessWidget {
  final dynamic user;
  final VoidCallback onProfileTap;
  final bool showFollowButton;

  const UserGridCard({
    Key? key,
    required this.user,
    required this.onProfileTap,
    this.showFollowButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(4),
      child: InkWell(
        onTap: onProfileTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              CircleAvatar(
                radius: 25,
                backgroundImage: user['foto_perfil'] != null
                    ? NetworkImage(user['foto_perfil']!)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                child: user['foto_perfil'] == null
                    ? Icon(Icons.person, size: 25, color: Colors.white)
                    : null,
              ),
              SizedBox(height: 8),

              // Nombre
              Text(
                '${user['nombre']}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),

              Text(
                '${user['apellidos']}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),

              // Botón de seguir
              if (showFollowButton)
                UserFollowButton(
                  userId: user['id'],
                  userName: '${user['nombre']} ${user['apellidos']}',
                  showLabel: false,
                  smallVersion: true,
                  userToken: localStorage.getItem('miToken').toString(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para lista horizontal de usuarios sugeridos
class SuggestedUsersHorizontal extends StatelessWidget {
  final List<dynamic> suggestedUsers;
  final VoidCallback onSeeAll;

  const SuggestedUsersHorizontal({
    Key? key,
    required this.suggestedUsers,
    required this.onSeeAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (suggestedUsers.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personas que tal vez conozcas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text('Ver todos'),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: suggestedUsers.length,
            itemBuilder: (context, index) {
              final user = suggestedUsers[index];
              return Container(
                width: 90,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    // Avatar
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userId: user['id']),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: user['foto_perfil'] != null
                            ? NetworkImage(user['foto_perfil']!)
                            : AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 6),

                    // Nombre
                    Text(
                      '${user['nombre']}',
                      style: TextStyle(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Botón de seguir
                    UserFollowButton(
                      userId: user['id'],
                      userName: '${user['nombre']}',
                      showLabel: false,
                      smallVersion: true,
                      userToken: localStorage.getItem('miToken').toString(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
