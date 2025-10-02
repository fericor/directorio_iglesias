import 'dart:convert';

import 'package:conexion_mas/controllers/AuthService.dart';
import 'package:conexion_mas/controllers/EventoService.dart';
import 'package:conexion_mas/controllers/MisUsuarioService.dart';
import 'package:conexion_mas/pages/eventos/EventosListPage.dart';
import 'package:conexion_mas/pages/iglesias/IglesiasListPage.dart';
import 'package:conexion_mas/pages/notificaciones/NotificacionesListPage.dart';
import 'package:conexion_mas/pages/usuarios/UsuariosListPage.dart';
import 'package:conexion_mas/pages/usuarios/usuario_manager.dart';
import 'package:conexion_mas/screens/profile_screen.dart';
import 'package:conexion_mas/screens/recommendations_screen.dart';
import 'package:conexion_mas/screens/user_follow_list.dart';
import 'package:conexion_mas/screens/user_list_screen.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String idUser = "0";
  String idIglesia = "0";
  String idOrganizacion = "0";
  String nombre = "";
  String email = "";
  String apiToken = localStorage.getItem('miToken').toString() ?? '0';

  final UsuarioManager usuarioManager = UsuarioManager(
    usuarioService: MisUsuarioService(
      MainUtils.urlHostApi,
      token: localStorage.getItem('miToken').toString(),
    ),
  );

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
    Map myMap = jsonDecode(iTems!);

    setState(() {
      nombre = "${myMap['nombre']} ${myMap['apellidos']}";
      email = myMap['email'];
      idUser = myMap['id'].toString();
      idIglesia = myMap['idIglesia'].toString();
      idOrganizacion = myMap['idOrganizacion'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.fondoColor,
      appBar: AppBar(
        title: Text(
          'Mi Panel de Control',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
        backgroundColor: ColorsUtils.fondoColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            //_buildQuickStats(),
            _buildMainLinks(context),
            SizedBox(height: 30),
            // _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 1,
      mainAxisSpacing: 0,
      childAspectRatio: 1,
      children: [
        _StatCard(
          icon: Icons.church,
          value: '3',
          label: 'Iglesias',
          color: ColorsUtils.principalColor,
        ),
        _StatCard(
          icon: Icons.event,
          value: '12',
          label: 'Eventos',
          color: ColorsUtils.principalColor,
        ),
        _StatCard(
          icon: Icons.notifications,
          value: '45',
          label: 'Notificaciones',
          color: ColorsUtils.principalColor,
        ),
      ],
    );
  }

  Widget _buildMainLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Text(
          'Accesos Rápidos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorsUtils.blancoColor,
          ),
        ),
        SizedBox(height: 16),*/
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 1.1,
          children: [
            _LinkCard(
              icon: Icons.church,
              title: 'Mis Iglesias',
              subtitle: 'Gestionar iglesias',
              color: ColorsUtils.principalColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IglesiasListPage(
                      token: localStorage.getItem('miToken').toString(),
                      userRole:
                          int.parse(localStorage.getItem('miRole').toString()),
                    ),
                  ),
                );
              },
            ),
            _LinkCard(
              icon: Icons.calendar_month,
              title: 'Mis Eventos',
              subtitle: 'Gestionar eventos',
              color: ColorsUtils.principalColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventosListPage(
                            idIglesia: idIglesia,
                            idOrganizacion: idOrganizacion,
                            token: localStorage.getItem('miToken').toString(),
                            userId: int.parse(idUser),
                            userRole: int.parse(
                                localStorage.getItem('miRole').toString()),
                            eventoService: EventoService(),
                          )),
                );
              },
            ),
            _LinkCard(
              icon: Icons.bed,
              title: 'Mis Notificaciones',
              subtitle: 'Gestionar notificaciones',
              color: ColorsUtils.principalColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notificacioneslistpage(
                      token: localStorage.getItem('miToken').toString(),
                      userRole:
                          int.parse(localStorage.getItem('miRole').toString()),
                    ),
                  ),
                );
              },
            ),
            _LinkCard(
              icon: Icons.account_balance,
              title: 'Miembros',
              subtitle: 'Gestionar miembros',
              color: ColorsUtils.principalColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaUsuariosScreen(
                      idIglesia: int.parse(idIglesia),
                      usuarioManager: usuarioManager,
                    ),
                  ),
                );
              },
            ),
            _LinkCard(
              icon: Icons.format_align_justify,
              title: 'Eventos Recomendados',
              subtitle: 'Ajustes del sistema',
              color: ColorsUtils.principalColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecommendationsScreen()),
                );
              },
            ),
            _LinkCard(
              icon: Icons.format_align_justify,
              title: 'Eventos Recomendados',
              subtitle: 'Ajustes del sistema',
              color: ColorsUtils.principalColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserFollowListScreen(
                            userId: int.parse(idUser),
                            type: 'seguidores',
                          )),
                );
              },
            ),
            _LinkCard(
              icon: Icons.format_align_justify,
              title: 'User list',
              subtitle: 'Ajustes del sistema',
              color: ColorsUtils.principalColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserListScreen(
                            title: 'Lista de Usuarios',
                          )),
                );
              },
            ),
            /*_LinkCard(
              icon: Icons.charging_station,
              title: 'Estadísticas',
              subtitle: 'Ver reportes',
              color: ColorsUtils.principalColor,
              onTap: () => _navigateTo(context, 'estadisticas'),
            ),
            _LinkCard(
              icon: Icons.format_align_justify,
              title: 'Configuración',
              subtitle: 'Ajustes del sistema',
              color: ColorsUtils.principalColor,
              onTap: () => _navigateTo(context, 'configuracion'),
            ),*/
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad Reciente',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorsUtils.blancoColor,
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _ActivityItem(
                  icon: Icons.notification_add,
                  title: 'Nueva notificación enviada',
                  subtitle: 'Culto especial - Domingo 10:00 AM',
                  time: 'Hace 2 horas',
                  color: Colors.green,
                ),
                Divider(),
                _ActivityItem(
                  icon: Icons.event_available,
                  title: 'Evento creado',
                  subtitle: 'Estudio bíblico de jóvenes',
                  time: 'Hace 5 horas',
                  color: Colors.blue,
                ),
                Divider(),
                _ActivityItem(
                  icon: Icons.person_add,
                  title: 'Nuevo miembro registrado',
                  subtitle: 'María González',
                  time: 'Ayer',
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, String route) {
    // Aquí iría la navegación a las diferentes pantallas
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando a: $route'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: ColorsUtils.blancoColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _LinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorsUtils.terceroColor,
                ColorsUtils.terceroColor
              ], // [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: ColorsUtils.blancoColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey,
        ),
      ),
    );
  }
}
