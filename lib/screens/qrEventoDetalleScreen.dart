import 'dart:io';

import 'package:conexion_mas/models/eventosItems.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrEventoDetalleScreen extends StatefulWidget {
  EventosItems evento;
  QrEventoDetalleScreen({super.key, required this.evento});

  @override
  State<QrEventoDetalleScreen> createState() => _QrEventoDetalleScreenState();
}

class _QrEventoDetalleScreenState extends State<QrEventoDetalleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.fondoColor,
      body: Stack(
        children: [
          Positioned(
            top: Platform.isAndroid ? 30 : 60,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Escanear este código QR",
                    style: TextStyle(
                      color: ColorsUtils.principalColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Text(
                  "Apunta este código QR al lugar del escaner",
                  maxLines: 2,
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorsUtils.blancoColor,
                    border: Border.all(
                      color: ColorsUtils.terceroColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: QrImageView(
                      data: widget.evento.reservas!.first.codigoReserva
                          .toString(),
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
                Divider(
                  height: 40,
                  color: ColorsUtils.principalColor,
                ),
                //////////////////////////
                Text(
                  widget.evento.evento!.first.titulo ?? '',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ColorsUtils.blancoColor,
                  ),
                ),
                ///////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lugar",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorsUtils.principalColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Fecha",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorsUtils.principalColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.evento.evento!.first.lugar ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsUtils.blancoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        MainUtils().formatFecha(
                            widget.evento.evento!.first.fecha ?? ''),
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsUtils.blancoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                ///////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dirección",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorsUtils.principalColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Hora",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorsUtils.principalColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.evento.evento!.first.direccion ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsUtils.blancoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        MainUtils()
                            .formatHora(widget.evento.evento!.first.hora ?? ''),
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsUtils.blancoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 40,
                  color: ColorsUtils.principalColor,
                ),
                Column(
                  children: [
                    for (var item
                        in widget.evento.reservas!.first.entradas ?? []) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: ColorsUtils.terceroColor,
                          border: Border.all(
                            color: ColorsUtils.principalColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Entrada",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorsUtils.blancoColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.tituloEventoItem ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: ColorsUtils.principalColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ////////////////////
                              Column(
                                children: [
                                  Text(
                                    "Cantidad",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorsUtils.blancoColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item.cantidad ?? '',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: ColorsUtils.principalColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ////////////////////
                              Column(
                                children: [
                                  Text(
                                    "Precio",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorsUtils.blancoColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item.subtotal ?? '',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: ColorsUtils.principalColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      ////////////////
                      SizedBox(height: 10),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
