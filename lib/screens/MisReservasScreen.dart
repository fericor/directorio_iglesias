import 'dart:io';

import 'package:conexion_mas/controllers/notificacionesApiClient.dart';
import 'package:conexion_mas/controllers/reservasApiClient.dart';
import 'package:conexion_mas/models/reservas.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class MisreservasScreen extends StatefulWidget {
  const MisreservasScreen({super.key});

  @override
  State<MisreservasScreen> createState() => _MisreservasScreenState();
}

class _MisreservasScreenState extends State<MisreservasScreen> {
  late List<Reserva> items = [];
  bool loading = true;
  String idUser = localStorage.getItem('miIdUser').toString() ?? '0';

  @override
  void initState() {
    super.initState();

    obtenerReservasUsuario();
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
    print(result);

    if (result['success'] == true) {
      setState(() {
        items = result['reservas'];
        loading = false;
      });
    } else {
      print(result['error'] ?? 'Error desconocido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.fondoColor,
      body: Stack(
        children: [
          Positioned(
            top: Platform.isAndroid ? 30 : 60,
            left: 20,
            right: 20,
            child: frcaWidget.frca_texto_header(
                "Mis Reservas", popupMenuIglesias()),
          ),
          Positioned(
            top: Platform.isAndroid ? 80 : 110,
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
                            child: Icon(
                              Icons.notifications,
                              size: 40.0,
                              color: ColorsUtils.principalColor,
                            ),
                          ),
                          title: Text(
                            item.evento!.titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          subtitle: Text(item.evento!.tieneAsientos
                              ? "Con asientos"
                              : "Sin asientos"),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                          onTap: () {
                            cancelarReserva(item.codigoReserva);
                            // Acción al tocar la tarjeta
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                showCloseIcon: true,
                                duration: Duration(seconds: 60),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorsUtils.blancoColor,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.notifications,
                                            size: 60,
                                            color: ColorsUtils.principalColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item.evento!.titulo,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                      ),
                                    ),
                                    Text(
                                      item.evento!.activo
                                          ? "Activo"
                                          : "Inactivo",
                                      style: TextStyle(fontFamily: "Roboto"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////
  Widget popupMenuIglesias() {
    return SizedBox();
  }
  ////////////////////////////////////
}
