import 'package:conexion_mas/controllers/eventosApiClient.dart';
import 'package:conexion_mas/models/eventos.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:conexion_mas/widgets/detalleEvento.dart';
import 'package:flutter/material.dart';

class CardMain extends StatelessWidget {
  String idUser;
  String idEvento;
  String titulo;
  String tipo;
  String descripcion;
  String fecha;
  String hora;
  String etiqueta;
  String imagen;
  List<Eventos> evento;
  PageController controller;

  CardMain(
      {required this.idUser,
      required this.idEvento,
      required this.titulo,
      required this.tipo,
      required this.descripcion,
      required this.fecha,
      required this.hora,
      required this.etiqueta,
      required this.imagen,
      required this.evento,
      required this.controller,
      super.key});

  late List<String> arrayFecha = fecha.split('-');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        EventosApiClient()
            .getEventoByIdByUser(int.parse(idEvento), idUser)
            .then((eventoItem) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetalleEvento(evento: eventoItem, controller: controller)),
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: 5.0, right: 5.0, top: 5.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  child: Container(
                    height: 10,
                    width: 2,
                    decoration: BoxDecoration(
                      color: ColorsUtils.principalColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                Text(
                  arrayFecha[2],
                  style: TextStyle(
                    color: ColorsUtils.principalColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  frcaWidget.frca_getMesIniciales(int.parse(arrayFecha[1])),
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Container(
                    height: 60,
                    width: 2,
                    decoration: BoxDecoration(
                      color: ColorsUtils.principalColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width - 110,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(imagen),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorsUtils.principalColor,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 22,
                    left: 0,
                    top: 55,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    left: 10,
                    right: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, bottom: 3.0, left: 10.0, right: 10.0),
                            child: Text(
                              tipo,
                              style: TextStyle(
                                fontSize: 11,
                                color: ColorsUtils.principalColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // TITULO
                        Text(
                          titulo,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // TIPO Y HORA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                color: ColorsUtils.blancoColor, size: 16.0),
                            SizedBox(width: 2.0),
                            Text(
                              etiqueta,
                              style: TextStyle(
                                color: ColorsUtils.blancoColor,
                                fontSize: 13.0,
                              ),
                            ),
                            SizedBox(width: 30.0),
                            Icon(Icons.access_time,
                                color: ColorsUtils.blancoColor, size: 16.0),
                            SizedBox(width: 2.0),
                            Text(
                              hora,
                              style: TextStyle(
                                color: ColorsUtils.blancoColor,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
