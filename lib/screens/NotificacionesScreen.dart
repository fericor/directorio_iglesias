import 'package:conexion_mas/controllers/notificacionesApiClient.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:conexion_mas/models/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final agrupado = agruparPorFecha(items);

    return Scaffold(
      backgroundColor: ColorsUtils.fondoColor,
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 15,
            right: 15,
            child: Row(
              children: [
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color: ColorsUtils.principalColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 75,
            left: 80,
            right: 20,
            child: frcaWidget.frca_texto_header(
                "Notificaciones", popupMenuIglesias()),
          ),
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            bottom: 0,
            child: loading
                ? frcaWidget.frca_loading_simple()
                : ListView(
                    children: agrupado.entries.map((entry) {
                      final fecha = entry.key;
                      final notificaciones = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Encabezado de fecha
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: frcaWidget.frca_texto_header(
                                fecha, popupMenuIglesias()),
                          ),

                          // Lista de notificaciones de ese día
                          ...notificaciones.map((item) {
                            return Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      showCloseIcon: true,
                                      duration: Duration(seconds: 60),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.notifications,
                                                  size: 60,
                                                  color: ColorsUtils
                                                      .principalColor,
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
                                            style:
                                                TextStyle(fontFamily: "Roboto"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                leading: Icon(
                                  Icons.notifications,
                                  size: 40.0,
                                  color: ColorsUtils.principalColor,
                                ),
                                title: Text(
                                  item.titulo ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                subtitle: Text(item.detalles ?? ""),
                                trailing:
                                    Icon(Icons.arrow_forward_ios, size: 16.0),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ),
            /*ListView.builder(
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
                  ),*/
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////
  Map<String, List<Notificaciones>> agruparPorFecha(
      List<Notificaciones> items) {
    final Map<String, List<Notificaciones>> agrupado = {};

    final now = DateTime.now();
    final hoy = DateTime(now.year, now.month, now.day);
    final ayer = hoy.subtract(Duration(days: 1));

    for (var item in items) {
      DateTime fecha = DateTime.parse(item.fecha!); // <- usa item.fecha
      DateTime soloFecha = DateTime(fecha.year, fecha.month, fecha.day);

      String clave;
      if (soloFecha == hoy) {
        clave = "Hoy";
      } else if (soloFecha == ayer) {
        clave = "Ayer";
      } else {
        clave = DateFormat('dd/MM/yyyy').format(soloFecha);
      }

      if (!agrupado.containsKey(clave)) {
        agrupado[clave] = [];
      }
      agrupado[clave]!.add(item);
    }

    return agrupado;
  }

  Widget popupMenuIglesias() {
    return SizedBox();
  }
  ////////////////////////////////////
}
