import 'package:cached_network_image/cached_network_image.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:directorio_iglesias/utils/mainUtils.dart';
import 'package:flutter/material.dart';

class CardSimpleIglesia extends StatelessWidget {
  String idIglesia;
  String iglesia;
  double miLatitud;
  double miLongitud;
  double latitud;
  double longitud;
  String telefono;

  CardSimpleIglesia(
      {required this.idIglesia,
      required this.miLatitud,
      required this.miLongitud,
      required this.latitud,
      required this.longitud,
      required this.iglesia,
      required this.telefono,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              child: CachedNetworkImage(
                imageUrl:
                    "https://vallmarketing.es/app_assets/images/iglesias/iglesia_$idIglesia.png",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.white, BlendMode.colorBurn)),
                  ),
                ),
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.network(
                  "https://vallmarketing.es/app_assets/images/iglesias/iglesia_0.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 210,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<double>(
                    future: MainUtils().calculateDistanceUsingGeolocator(
                        miLatitud, miLongitud, latitud, longitud),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "Calculando distancia...",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          "Error calculando distancia",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        );
                      } else {
                        return Text(
                          "Distancia: ${snapshot.data!.toStringAsFixed(2)}km",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        );
                      }
                    },
                  ),
                  Text(
                    iglesia,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      MainUtils().openMap(latitud, longitud);
                    },
                    icon: Icon(
                      Icons.near_me,
                      size: 20,
                      color: ColorsUtils.principalColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                // LLAMAR
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      MainUtils().calTel(telefono);
                    },
                    icon: Icon(
                      Icons.phone,
                      size: 20,
                      color: ColorsUtils.principalColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
