import 'dart:math';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conexion_mas/controllers/iglesiasApiClient.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/iglesias.dart';
import 'package:conexion_mas/screens/infoPastor.dart';
import 'package:conexion_mas/screens/perfilIglesia.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:localstorage/localstorage.dart';

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
  Timer? _searchTimer;
  bool _isSearching = false;
  double _previousZoom = 18.0;

  @override
  void initState() {
    super.initState();

    _mapController.mapEventStream.listen((MapEvent mapEvent) {
      _handleMapEvent(mapEvent);
    });

    listarIglesiasCerca();
  }

  void _zoomIn() {
    final newZoom = _mapController.camera.zoom + 1;
    _mapController.move(_mapController.camera.center, newZoom);
    _updateRadiusFromZoom(newZoom);
    _scheduleChurchSearch();
  }

  void _zoomOut() {
    final newZoom = _mapController.camera.zoom - 1;
    _mapController.move(_mapController.camera.center, newZoom);
    _updateRadiusFromZoom(newZoom);
    _scheduleChurchSearch();
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
      if (iglesias.isEmpty) {
        setState(() {
          _loading = false;
          _loadingIglesias = false;
        });
      } else {
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
      }
    });
  }

  void _showChurchDetails(Iglesias church) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorsUtils.terceroColor,
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
                                ColorsUtils.blancoColor, BlendMode.colorBurn)),
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
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// BOTON 0
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
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.church,
                                color: ColorsUtils.blancoColor,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Iglesia',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtils.blancoColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    /// BOTON 1
                    GestureDetector(
                      onTap: () {
                        if (church.idPastor != 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                idPastor: church.idPastor!,
                              ),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          AppSnackbar.show(
                            context,
                            message:
                                'Esta iglesia no tiene un pastor asignado.',
                            type: SnackbarType.error,
                          );
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
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
                                color: ColorsUtils.blancoColor,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Pastor',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtils.blancoColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
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
                          color: ColorsUtils.principalColor,
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
                                color: ColorsUtils.blancoColor,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Llamar',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtils.blancoColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
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
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Transform.rotate(
                                angle:
                                    90 * 3.1416 / 180, // de grados a radianes
                                child: Icon(
                                  Icons.navigation,
                                  color: ColorsUtils.blancoColor,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Llegar',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtils.blancoColor),
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
                      color: ColorsUtils.blancoColor),
                ),
                SizedBox(height: 0),
                Text(
                  church.direccion!,
                  style:
                      TextStyle(fontSize: 16, color: ColorsUtils.terceroColor),
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
                  style:
                      TextStyle(fontSize: 16, color: ColorsUtils.blancoColor),
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
      switch (currentZoom.round()) {
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
        default:
          currentRadius = 100;
          distancia = "0.0597";
          break;
      }
    });
  }

  void _handleMapEvent(MapEvent mapEvent) {
    // Verificar si el zoom ha cambiado
    final currentZoom = _mapController.camera.zoom;
    if ((currentZoom - _previousZoom).abs() > 0.1) {
      _previousZoom = currentZoom;
      _updateRadiusFromZoom(currentZoom);
      _scheduleChurchSearch();
    }
  }

  void _updateRadiusFromZoom(double zoom) {
    // Mapa de zoom a radio en metros
    final Map<int, double> zoomToRadius = {
      0: 26214400.0,
      1: 13107200.0,
      2: 6553600.0,
      3: 3276800.0,
      4: 1638400.0,
      5: 819200.0,
      6: 409600.0,
      7: 204800.0,
      8: 102400.0,
      9: 51200.0,
      10: 25600.0,
      11: 12800.0,
      12: 6400.0,
      13: 3200.0,
      14: 1600.0,
      15: 800.0,
      16: 400.0,
      17: 200.0,
      18: 100.0,
    };

    int roundedZoom = zoom.round();
    if (roundedZoom < 0) roundedZoom = 0;
    if (roundedZoom > 18) roundedZoom = 18;

    setState(() {
      currentZoom = zoom;
      sliderValue = zoom;
      currentRadius = zoomToRadius[roundedZoom] ?? 100.0;
      _radioMapa();
    });
  }

  void _scheduleChurchSearch() {
    if (_searchTimer != null) {
      _searchTimer!.cancel();
    }

    _searchTimer = Timer(Duration(milliseconds: 500), () {
      if (!_isSearching) {
        _isSearching = true;
        listarIglesiasCerca().then((_) {
          _isSearching = false;
        });
      }
    });
  }

  String _formatDistance(double meters) {
    double km = meters / 1000;
    return '${km.toStringAsFixed(1)}';
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
                    onMapEvent: _handleMapEvent,
                    initialCenter: currentCenter,
                    initialZoom: currentZoom,
                    onMapReady: () {
                      _updateRadiusFromZoom(currentZoom);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/fericor/cm5aqsckv00li01sa3ubd38gn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZmVyaWNvciIsImEiOiJja3J3ZHpzNnQwZm54Mm5xamo0OHN6bDBhIn0.2EtgIWzOEgy6AKorHcL44w',
                      userAgentPackageName: 'com.fericor.conexionmas',
                    ),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: currentCenter,
                          radius: currentRadius,
                          useRadiusInMeter: true,
                          borderStrokeWidth: 2,
                          borderColor: ColorsUtils.principalColor,
                          color: ColorsUtils.principalColor.withOpacity(0.3),
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
                                  color: ColorsUtils.principalColor,
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
                                      color: ColorsUtils.terceroColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: ColorsUtils.principalColor,
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
                                              color: ColorsUtils.blancoColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                      _searchChurch, "Buscar Iglesia", context, true, true),
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
                                                color: ColorsUtils.terceroColor,
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
                                                                colorFilter: ColorFilter.mode(
                                                                    ColorsUtils
                                                                        .blancoColor,
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
                                                          "${MainUtils.urlHostAssetsImagen}/logos/logo_0.png",
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
                                                              color: ColorsUtils
                                                                  .blancoColor),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          church.direccion!,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: ColorsUtils
                                                                .blancoColor,
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
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorsUtils.principalColor
                                                  .withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                _showChurchDetails(church);
                                              },
                                              icon: Icon(
                                                Icons.info_rounded,
                                                color: ColorsUtils.blancoColor,
                                                size: 30,
                                              ),
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
                      _zoomIn, _zoomOut, _getPosition),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  ////////////////////////////////////
  Widget popupMenuIglesias() {
    return PopupMenuButton(
      padding: EdgeInsets.all(0),
      icon: Icon(
        Icons.settings,
        color: ColorsUtils.blancoColor,
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
                      setState(() {
                        sliderValue = newValue;
                        currentZoom = newValue;
                      });

                      _radioMapa();
                      _scheduleChurchSearch();
                      _mapController.move(currentCenter, currentZoom);
                    },
                  ),
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
