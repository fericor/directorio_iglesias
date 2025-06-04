import 'dart:io';

import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrEventoDetalleScreen extends StatefulWidget {
  const QrEventoDetalleScreen({super.key});

  @override
  State<QrEventoDetalleScreen> createState() => _QrEventoDetalleScreenState();
}

class _QrEventoDetalleScreenState extends State<QrEventoDetalleScreen> {
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
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  "Apunta este código QR al lugar del escaner",
                  maxLines: 5,
                  style: TextStyle(
                    color: ColorsUtils.segundoColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: ColorsUtils.terceroColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: QrImageView(
                      data: '1234567890',
                      version: QrVersions.auto,
                      size: 250.0,
                    ),
                  ),
                ),
                Divider(
                  height: 60,
                  color: ColorsUtils.terceroColor,
                ),
                //////////////////////////
                Text(
                  'Nombre del evento',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ///////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nombre",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorsUtils.terceroColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Fecha",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorsUtils.terceroColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Palacio real",
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsUtils.segundoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "01/01/2025",
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsUtils.segundoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ///////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lugar",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorsUtils.terceroColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Hora",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorsUtils.terceroColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Aryo Romandhon",
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsUtils.segundoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "10:00 AM",
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsUtils.segundoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
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
