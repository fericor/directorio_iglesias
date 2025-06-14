import 'dart:io';

import 'package:directorio_iglesias/controllers/notificacionesApiClient.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:directorio_iglesias/utils/widgets.dart';
import 'package:directorio_iglesias/models/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  late List<Notificaciones> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    listarNotificacionesTodos();
  }

  Future<void> listarNotificacionesTodos() async {
    await initLocalStorage();

    NotificacionesApiClient()
        .getNotificaciones(localStorage.getItem('miIdUser').toString(),
            localStorage.getItem('miToken').toString())
        .then((notificaciones) {
      setState(() {
        items = notificaciones;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 120,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f8fe),
              ),
            ),
          ),
          Positioned(
            top: Platform.isAndroid ? 30 : 60,
            left: 20,
            right: 20,
            child: frcaWidget.frca_texto_header(
                "Notificaciones", popupMenuIglesias()),
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
                            item.titulo!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          subtitle: Text(item.detalles!),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                          onTap: () {
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
                                          color: Colors.white,
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
                                      item.titulo!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                      ),
                                    ),
                                    Text(
                                      item.detalles!,
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
