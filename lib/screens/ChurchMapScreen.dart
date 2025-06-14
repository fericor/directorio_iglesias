import 'package:cached_network_image/cached_network_image.dart';
import 'package:directorio_iglesias/controllers/iglesiasApiClient.dart';
import 'package:directorio_iglesias/models/iglesias.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:directorio_iglesias/utils/mainUtils.dart';
import 'package:directorio_iglesias/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class ChurchMapScreen extends StatefulWidget {
  const ChurchMapScreen({super.key});

  @override
  _ChurchMapScreenState createState() => _ChurchMapScreenState();
}

class _ChurchMapScreenState extends State<ChurchMapScreen> {
  final MapController _mapController = MapController();
  late List<Iglesias> churches = [];
  late List<Iglesias> churchesSearch = [];
  String distancia = '0.0597';
  double miLongitud = 0.0;
  double miLatitud = 0.0;
  double currentRadius = 100;
  double currentZoom = 18.0;
  double sliderValue = 18.0;
  LatLng currentCenter = LatLng(0.0, 0.0);
  LatLng startPoint = LatLng(0.0, 0.0);
  bool _loading = true;
  bool _loadingIglesias = true;

  @override
  void initState() {
    super.initState();

    listarIglesiasCerca();
  }

  Future<void> listarIglesiasTodos() async {
    await initLocalStorage();

    setState(() {
      miLatitud = double.parse(localStorage.getItem('mi_latitud')!);
      miLongitud = double.parse(localStorage.getItem('mi_longitud')!);

      currentCenter = LatLng(miLatitud, miLongitud);
    });

    IglesiasApiClient().getIglesiass().then((iglesias) {
      setState(() {
        churches = iglesias;
        churchesSearch = iglesias;

        churches.add(Iglesias(
          idIglesia: 0,
          titulo: 'MiUbicación',
          descripcion: 'Mi Ubicación',
          direccion: 'Mi Ubicación',
          telefono: '0',
          web: 'https://vallmarketing.es',
          latitud: miLatitud,
          longitud: miLongitud,
        ));
        _loading = false;
      });
    });
  }

  Future<void> listarIglesiasCerca() async {
    await initLocalStorage();

    setState(() {
      miLatitud = double.parse(localStorage.getItem('mi_latitud')!);
      miLongitud = double.parse(localStorage.getItem('mi_longitud')!);

      startPoint = LatLng(miLatitud, miLongitud);
      currentCenter = LatLng(miLatitud, miLongitud);
      _loadingIglesias = true;
    });

    IglesiasApiClient()
        .getIglesiasCerca(
      miLatitud.toString(),
      miLongitud.toString(),
      distancia,
    )
        .then((iglesias) {
      setState(() {
        churches = iglesias;
        churchesSearch = iglesias;

        churches.add(Iglesias(
          idIglesia: 0,
          titulo: 'MiUbicación',
          descripcion: 'Mi Ubicación',
          direccion: 'Mi Ubicación',
          telefono: '0',
          web: 'https://vallmarketing.es',
          latitud: miLatitud,
          longitud: miLongitud,
        ));

        _loading = false;
        _loadingIglesias = false;
      });
    });
  }

  void cambioDistancia(double distance) {
    setState(() {
      distancia = distance.toString();
    });
    listarIglesiasCerca();
  }

  void _showChurchDetails(Iglesias church) {
    // _mapController.move(LatLng(church.latitud!, church.latitud!), 15.0);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    height: 220,
                    imageUrl:
                        "${MainUtils.urlHostAssets}/images/iglesias/iglesia_${church.idIglesia.toString()}.png",
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
                      "${MainUtils.urlHostAssets}/images/iglesias/iglesia_0.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// BOTON 1
                    GestureDetector(
                      onTap: () {
                        MainUtils().launchInBrowser(Uri.parse(church.web!));
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Pastor',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),

                    /// BOTON 2
                    GestureDetector(
                      onTap: () {
                        MainUtils().calTel(church.telefono!);
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Llamar',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),

                    /// BOTON 3
                    GestureDetector(
                      onTap: () {
                        MainUtils().openMap(church.latitud, church.longitud);
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.navigation,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Llegar',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  church.titulo!,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 0),
                Text(
                  church.direccion!,
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
                SizedBox(
                  height: 16,
                  child: Divider(
                    height: 20,
                    color: ColorsUtils.blancoColor,
                  ),
                ),
                Text(
                  church.descripcion!,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _searchChurch(texto) {
    String query = texto.toLowerCase();

    setState(() {
      churches = churchesSearch
          .where((c) => c.titulo!.toLowerCase().contains(query))
          .toList();
    });

    // _showChurchDetails(church);
  }

  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    _mapController.move(LatLng(position.latitude, position.longitude), 15.0);

    return position;
  }

  void _radioMapa() {
    setState(() {
      switch (currentZoom.toInt()) {
        case 0:
          currentRadius = 26214400;
          distancia = "4100246732.8";
          break;
        case 1:
          currentRadius = 13107200;
          distancia = "1025061683.2";
          break;
        case 2:
          currentRadius = 6553600;
          distancia = "256265420.8";
          break;
        case 3:
          currentRadius = 3276800;
          distancia = "64066355.2";
          break;
        case 4:
          currentRadius = 1638400;
          distancia = "16016588.8";
          break;
        case 5:
          currentRadius = 819200;
          distancia = "4004147.2";
          break;
        case 6:
          currentRadius = 409600;
          distancia = "1001036.8";
          break;
        case 7:
          currentRadius = 204800;
          distancia = "250259.2";
          break;
        case 8:
          currentRadius = 102400;
          distancia = "62564.8";
          break;
        case 9:
          currentRadius = 51200;
          distancia = "15641.2";
          break;
        case 10:
          currentRadius = 25600;
          distancia = "3910.3";
          break;
        case 11:
          currentRadius = 12800;
          distancia = "977.575";
          break;
        case 12:
          currentRadius = 6400;
          distancia = "244.3938";
          break;
        case 13:
          currentRadius = 3200;
          distancia = "61.0984";
          break;
        case 14:
          currentRadius = 1600;
          distancia = "15.2746";
          break;
        case 15:
          currentRadius = 800;
          distancia = "3.8187";
          break;
        case 16:
          currentRadius = 400;
          distancia = "0.9547";
          break;
        case 17:
          currentRadius = 200;
          distancia = "0.2387";
          break;
        case 18:
          currentRadius = 100;
          distancia = "0.0597";
          break;
      }
    });
  }

  void _zoom_plus() {
    if (currentZoom < 18) {
      currentZoom = currentZoom + 1;
      _radioMapa();
      listarIglesiasCerca();
      _mapController.move(currentCenter, currentZoom);
    }
  }

  void _zoom_minus() {
    if (currentZoom > 0) {
      currentZoom = currentZoom - 1;
      _radioMapa();
      listarIglesiasCerca();
      _mapController.move(currentCenter, currentZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? frcaWidget.frca_loading_container()
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: currentCenter,
                    initialZoom: currentZoom,
                    onPositionChanged: (camera, hasGesture) {
                      currentCenter = camera.center;
                      currentZoom = camera.zoom;
                    },
                  ),
                  children: [
                    TileLayer(
                      // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/fericor/cm5aqsckv00li01sa3ubd38gn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZmVyaWNvciIsImEiOiJja3J3ZHpzNnQwZm54Mm5xamo0OHN6bDBhIn0.2EtgIWzOEgy6AKorHcL44w',
                      userAgentPackageName: 'com.fericor.eventos',
                      // Plenty of other options available!
                    ),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: currentCenter,
                          radius: currentRadius,
                          useRadiusInMeter: true,
                          borderStrokeWidth: 2,
                          borderColor: Colors.orangeAccent,
                          color: Colors.orangeAccent.withOpacity(0.3),
                        )
                      ],
                    ),
                    MarkerLayer(
                      markers: churches.map((church) {
                        return church.titulo == "MiUbicación"
                            ? Marker(
                                width: 45.0,
                                height: 45.0,
                                point:
                                    LatLng(church.latitud!, church.longitud!),
                                child: Icon(
                                  Icons.my_location,
                                  color: Colors.deepOrangeAccent,
                                  size: 40,
                                ),
                              )
                            : Marker(
                                width: 150.0,
                                height: 25.0,
                                point:
                                    LatLng(church.latitud!, church.longitud!),
                                child: GestureDetector(
                                  onTap: () => _showChurchDetails(church),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[850],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.orange,
                                          size: 16,
                                        ),
                                        Expanded(
                                          child: Text(
                                            church.titulo!,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 11,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ), /*Icon(
                                    Icons.location_on,
                                    color: Colors.orange,
                                    size: 40,
                                  ),*/
                                ),
                              );
                      }).toList(),
                    ),
                  ],
                ),
                Positioned(
                  top: Platform.isAndroid ? 30 : 60,
                  left: 15,
                  right: 15,
                  child: frcaWidget.frca_buscador(popupMenuIglesias(),
                      _searchChurch, "Buscar Iglesia", context, true),
                ),
                Positioned(
                  bottom: 55,
                  left: 0,
                  right: 0,
                  child: _loadingIglesias
                      ? frcaWidget.frca_loading_simple()
                      : SizedBox(
                          height: 190,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: churches.length,
                            itemBuilder: (context, index) {
                              final church = churches[index];
                              return church.titulo == "MiUbicación"
                                  ? SizedBox(
                                      width: 0,
                                    )
                                  : Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            onTap: () => _mapController.move(
                                                LatLng(church.latitud!,
                                                    church.longitud!),
                                                15.0),
                                            child: Container(
                                              width: 250,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[850],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      12)),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${MainUtils.urlHostAssets}/images/iglesias/iglesia_${church.idIglesia.toString()}.png",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                                colorFilter:
                                                                    ColorFilter.mode(
                                                                        Colors
                                                                            .white,
                                                                        BlendMode
                                                                            .colorBurn)),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.network(
                                                          "${MainUtils.urlHostAssets}/images/iglesias/iglesia_0.jpg",
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          church.titulo!,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          church.direccion!,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[500],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0.0,
                                          right: 0.0,
                                          child: IconButton(
                                            onPressed: () {
                                              _showChurchDetails(church);
                                            },
                                            icon: Icon(
                                              Icons.info_rounded,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ),
                ),
                Positioned(
                  top: 120,
                  right: 10,
                  child: frcaWidget.frca_botones_map(
                      _zoom_plus, _zoom_minus, _getPosition),
                ),
              ],
            ),
    );
  }

  ////////////////////////////////////
  Widget popupMenuIglesias() {
    return PopupMenuButton(
      padding: EdgeInsets.all(0),
      icon: Icon(
        Icons.settings,
        color: ColorsUtils.segundoColor,
        size: 30,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    activeColor: ColorsUtils.principalColor,
                    value: sliderValue,
                    min: 0,
                    max: 18,
                    divisions: 18,
                    label: sliderValue.round().toString(),
                    onChanged: (newValue) {
                      cambioDistancia(newValue);
                      setState(() {
                        sliderValue = newValue;
                        currentZoom = newValue;
                      });

                      _radioMapa();
                      listarIglesiasCerca();
                      _mapController.move(currentCenter, currentZoom);
                    },
                  ),
                  // Text('Distancia: ${distancia}km'),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
  ////////////////////////////////////
}
