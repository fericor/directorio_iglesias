import 'package:cached_network_image/cached_network_image.dart';
import 'package:conexion_mas/models/iglesias.dart';
import 'package:conexion_mas/screens/perfilIglesia.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';

class CardSimpleIglesia extends StatelessWidget {
  String idIglesia;
  String iglesia;
  double miLatitud;
  double miLongitud;
  double latitud;
  double longitud;
  String telefono;
  Iglesias church;

  CardSimpleIglesia(
      {required this.idIglesia,
      required this.miLatitud,
      required this.miLongitud,
      required this.latitud,
      required this.longitud,
      required this.iglesia,
      required this.telefono,
      required this.church,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 60,
          margin: EdgeInsets.all(4),
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
            padding: const EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChurchProfileScreen(church: church),
                        ));
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorsUtils.blancoColor),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${MainUtils.urlHostAssetsImagen}/iglesias/iglesia_$idIglesia.png",
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
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChurchProfileScreen(church: church),
                        ));
                  },
                  child: SizedBox(
                    width: 5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChurchProfileScreen(church: church),
                        ));
                  },
                  child: SizedBox(
                    width: 190,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<double>(
                          future: MainUtils().calculateDistanceUsingGeolocator(
                              miLatitud, miLongitud, latitud, longitud),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "Calculando distancia...",
                                style: TextStyle(
                                  color: ColorsUtils.blancoColor,
                                  fontSize: 14.0,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                "Error calculando distancia",
                                style: TextStyle(
                                  color: ColorsUtils.blancoColor,
                                  fontSize: 16.0,
                                ),
                              );
                            } else {
                              return Text(
                                "Distancia: ${snapshot.data!.toStringAsFixed(2)}km",
                                style: TextStyle(
                                  color: ColorsUtils.blancoColor,
                                  fontSize: 16.0,
                                ),
                              );
                            }
                          },
                        ),
                        Text(
                          iglesia,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorsUtils.blancoColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ColorsUtils.blancoColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          MainUtils().openMap(latitud, longitud);
                        },
                        icon: Icon(
                          Icons.near_me,
                          size: 25,
                          color: ColorsUtils.principalColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 5.0),
      ],
    );
  }
}
