import 'dart:convert';

import 'package:conexion_mas/controllers/iglesiasApiClient.dart';
import 'package:conexion_mas/models/insignias.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfilePage extends StatefulWidget {
  final int idPastor;
  const UserProfilePage({super.key, this.idPastor = 0});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String userName = "Felix Ricardo";
  String userPhone = "+34 633 535 178";
  String userMobile = "+34 633 535 178";
  String userEmail = "felix@example.com";
  String userDetails =
      "Desarrollador web full-stack con experiencia en PHP, Flutter, y bases de datos.";
  String userImage =
      "https://via.placeholder.com/150"; // Imagen de perfil de ejemplo
  double rating = 4.5;
  List<Insignia> badges = [
    Insignia(nombre: "Experto", icono: "⭐"),
    Insignia(nombre: "Top Seller", icono: "🏆"),
    Insignia(nombre: "Flutter Dev", icono: "💻"),
    Insignia(nombre: "Internacional", icono: "🌍"),
  ];

  @override
  void initState() {
    super.initState();

    _cargarDatosPastor();
  }

  // Función para convertir string a IconData
  IconData? _getIconFromString(String iconName) {
    Map<String, IconData> iconMap = {
      'mic': Icons.mic,
      'group': Icons.group,
      'church': Icons.church,
      'forum': Icons.forum,
      'music_note': Icons.music_note,
      'megaphone': Icons.campaign,
      'menu_book': Icons.menu_book,
      'handshake': Icons.handshake,
      'school': Icons.school,
      'crown': Icons.emoji_events,
    };
    return iconMap[iconName];
  }

  List<Insignia> parseInsigniasFromJson(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> insigniasList = jsonData['insignias'];

      return insigniasList.map((insignia) {
        return Insignia(nombre: insignia['nombre'], icono: insignia['icono']);
      }).toList();
    } catch (e) {
      print('Error parsing JSON: $e');
      return [];
    }
  }

  Future<void> _cargarDatosPastor() async {
    // Aquí puedes llamar a tu API para obtener los datos del pastor
    final pastor = await IglesiasApiClient()
        .infoPastor(widget.idPastor.toString(), 'token');
    if (pastor != null) {
      setState(() {
        userName = "${pastor.nombre!} ${pastor.apellidos!}";
        userPhone = "${pastor.telefonoFijo!} - ${pastor.telefonoMovil!}";
        userMobile = pastor.telefonoMovil!;
        userEmail = pastor.email!;
        userDetails = pastor.detalles!;
        userImage = "${MainUtils.urlHostAssetsImagen}/${pastor.imagen!}" ?? "";
        rating = double.parse(pastor.valoraciones.toString());
        badges = parseInsigniasFromJson(pastor.insignias!);
      });
    }
  }

  void _enviarMensajeWhatsAppOld(String mensaje, String numeroPastor) async {
    final url = 'https://wa.me/$numeroPastor?text=${Uri.encodeFull(mensaje)}';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _enviarMensajeWhatsAppOld2(String mensaje, String numeroPastor) async {
    final url =
        'https://api.whatsapp.com/send?phone=$numeroPastor&text=${Uri.encodeFull(mensaje)}';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // Fallback: abrir en navegador
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo enviar el mensaje')),
      );
    }
  }

  void _enviarMensajePredefinido(String tipoMensaje) {
    Map<String, String> mensajes = {
      'consulta':
          'Hola pastor, tengo una consulta espiritual que me gustaría conversar.',
      'cita': 'Buenos días, me gustaría agendar una cita para conversar.',
      'oracion': 'Hermanos, por favor oren por mi situación. Gracias.',
      'agradecimiento': 'Quiero agradecer por su ministerio y enseñanzas.',
    };

    String mensaje = mensajes[tipoMensaje] ?? '';
    _enviarMensajeWhatsApp(mensaje, userMobile);
  }

  void _enviarMensajeWhatsApp(String mensaje, String numeroPastor) async {
    // Limpiar y validar el número
    String numeroLimpio = numeroPastor.replaceAll(RegExp(r'[+\s\-()]'), '');

    // Verificar que sea un número válido (al menos 10 dígitos)
    if (numeroLimpio.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Número de WhatsApp inválido')),
      );
      return;
    }

    // Construir la URL CORRECTA
    final url = 'https://wa.me/$numeroLimpio?text=${Uri.encodeFull(mensaje)}';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // Si la app no está instalada, abrir en navegador
        await launchUrl(
          Uri.parse(
              'https://web.whatsapp.com/send?phone=$numeroLimpio&text=${Uri.encodeFull(mensaje)}'),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir WhatsApp: $e')),
      );
    }
  }

  void _mostrarDialogoMensaje(BuildContext context) {
    TextEditingController _mensajeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enviar mensaje al pastor'),
          content: TextField(
            controller: _mensajeController,
            decoration: InputDecoration(
              hintText: 'Escribe tu mensaje aquí...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_mensajeController.text.isNotEmpty) {
                  _enviarMensajeWhatsApp(_mensajeController.text, userMobile);
                  Navigator.pop(context);
                }
              },
              child: Text('Enviar por WhatsApp'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil del Pastor"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FOTO + NOMBRE + TELEFONO
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    // Imagen de perfil
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userImage),
                    ),
                    const SizedBox(width: 10),
                    // Nombre y teléfono
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 18),
                              const SizedBox(width: 5),
                              Text(userPhone),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.email, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                userEmail,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // BOTONES DE ACCIÓN (Opcional)
            Wrap(
              spacing: 4,
              children: [
                ElevatedButton(
                  onPressed: () => _enviarMensajePredefinido('consulta'),
                  child: Text('Consulta'),
                ),
                ElevatedButton(
                  onPressed: () => _enviarMensajePredefinido('cita'),
                  child: Text('Pedir Cita'),
                ),
                ElevatedButton(
                  onPressed: () => _enviarMensajePredefinido('oracion'),
                  child: Text('Pedir Oración'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _mostrarDialogoMensaje(context),
                  icon: const Icon(Icons.message),
                  label: const Text("Mensaje por WhatsApp"),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                  label: const Text("Llamar"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // DETALLES DEL USUARIO
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detalles",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userDetails,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // VALORACIONES
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Valoraciones",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        if (index < rating.floor()) {
                          return const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 35,
                          );
                        } else if (index < rating) {
                          return const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                            size: 35,
                          );
                        } else {
                          return const Icon(Icons.star_border,
                              color: Colors.amber);
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // INSIGNIAS
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Insignias",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 1,
                      runSpacing: 0,
                      children: badges
                          .map((badge) => Chip(
                                label: Text(
                                  badge.nombre, // Acceso directo al nombre
                                  style: TextStyle(
                                    color: ColorsUtils.blancoColor,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: ColorsUtils.principalColor,
                                avatar: Icon(
                                  _getIconFromString(
                                      badge.icono), // Icono correspondiente
                                  size: 18,
                                  color: ColorsUtils.blancoColor,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
