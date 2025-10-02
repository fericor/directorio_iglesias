import 'package:cached_network_image/cached_network_image.dart';
import 'package:conexion_mas/controllers/ProfileServide.dart';
import 'package:conexion_mas/controllers/eventosApiClient.dart';
import 'package:conexion_mas/controllers/reservasApiClient.dart';
import 'package:conexion_mas/models/reservas.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:conexion_mas/widgets/detalleEvento.dart';
import 'package:conexion_mas/widgets/horizontal_user_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class MisreservasScreen extends StatefulWidget {
  const MisreservasScreen({super.key});

  @override
  State<MisreservasScreen> createState() => _MisreservasScreenState();
}

class _MisreservasScreenState extends State<MisreservasScreen> {
  late List<Reserva> items = [];
  List<dynamic> _suggestedUsers = [];
  bool loading = true;
  bool _loading = true;
  String idUser = localStorage.getItem('miIdUser').toString() ?? '0';

  @override
  void initState() {
    super.initState();

    obtenerReservasUsuario();
    _loadSuggestedUsers();
  }

  // Cancelar reserva
  Future<void> cancelarReserva(String codigoReserva) async {
    final result = await ReservasApiClient.cancelarReserva(codigoReserva);

    if (result['success'] == true) {
      print("Reserva cancelada: ${result['message']}");
    } else {
      print("Error al cancelar reserva: ${result['error']}");
    }
  }

  // Obtener reservas de usuario
  Future<void> obtenerReservasUsuario() async {
    final result = await ReservasApiClient.obtenerReservasUsuario(idUser);

    if (result['success'] == true) {
      setState(() {
        items = result['reservas'];
        loading = false;
      });
    } else {
      print(result['error'] ?? 'Error desconocido');
    }
  }

  Future<void> _loadSuggestedUsers() async {
    try {
      final result = await ProfileService.getSuggestedUsers();
      setState(() {
        _suggestedUsers = result['users'] ?? [];
        _loading = false;
      });
    } catch (error) {
      setState(() => _loading = false);
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsUtils.fondoColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              frcaWidget.frca_texto_header("Amigos", popupMenuIglesias()),
              HorizontalUserList(
                users: _suggestedUsers,
                title: 'Usuarios Sugeridos',
                onSeeAll: () {
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSearchScreen(),
                      ));*/
                },
              )
            ],
          ),
        ) /*Stack(
        children: [
          Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: frcaWidget.frca_texto_header(
                "Mis Reservas", popupMenuIglesias()),
          ),
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            bottom: 0,
            child: loading
                ? frcaWidget.frca_loading_simple()
                : ListView.builder(
                    itemCount: items.length,
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsUtils.blancoColor),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${MainUtils.urlHostAssetsImagen}/${item.evento!.imagen}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            ColorsUtils.blancoColor,
                                            BlendMode.colorBurn)),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Image.network(
                                  "${MainUtils.urlHostAssetsImagen}/logos/logo_0.png",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            item.evento!.titulo ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          subtitle: Text(item.evento!.descripcionCorta ?? ''),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                          onTap: () {
                            EventosApiClient()
                                .getEventoByIdByUser(
                                    int.parse(item.evento!.idEvento), idUser)
                                .then((eventoItem) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetalleEvento(
                                        index: 0,
                                        evento: eventoItem,
                                        controller: PageController())),
                              );
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),*/
        );
  }

  ////////////////////////////////////
  Widget popupMenuIglesias() {
    return SizedBox();
  }
  ////////////////////////////////////
}
