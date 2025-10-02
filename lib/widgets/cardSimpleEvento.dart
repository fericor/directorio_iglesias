import 'package:cached_network_image/cached_network_image.dart';
import 'package:conexion_mas/controllers/eventosApiClient.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:conexion_mas/widgets/detalleEvento.dart';
import 'package:flutter/material.dart';

class CardSimpleEvento extends StatelessWidget {
  String idUser;
  String idEvento;
  String titulo;
  String tipo;
  String descripcion;
  String fecha;
  String hora;
  String etiqueta;
  String imagen;
  PageController controller;

  CardSimpleEvento(
      {required this.idUser,
      required this.idEvento,
      required this.titulo,
      required this.tipo,
      required this.descripcion,
      required this.fecha,
      required this.hora,
      required this.etiqueta,
      required this.imagen,
      required this.controller,
      super.key});

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
                builder: (context) => DetalleEvento(
                    index: 0, evento: eventoItem, controller: controller)),
          );
        });
      },
      child: Row(
        children: [
          Container(
            width: 80.0,
            height: 100.0,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: ColorsUtils.terceroColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorsUtils.principalColor.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorsUtils.blancoColor),
                    child: CachedNetworkImage(
                      imageUrl: imagen,
                      imageBuilder: (context, imageProvider) => Container(
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
                      errorWidget: (context, url, error) => Image.network(
                        "${MainUtils.urlHostAssetsImagen}/logos/logo_0.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Text(
                      titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorsUtils.blancoColor,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.0),
        ],
      ),
    );
  }
}
