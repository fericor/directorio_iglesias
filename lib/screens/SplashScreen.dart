import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conexion_mas/controllers/AuthService.dart';
import 'package:conexion_mas/controllers/ProfileServide.dart';
import 'package:conexion_mas/controllers/eventosApiClient.dart';
import 'package:conexion_mas/controllers/notifications_service.dart';
import 'package:conexion_mas/controllers/reservasApiClient.dart';
import 'package:conexion_mas/models/eventosItems.dart';
import 'package:conexion_mas/pages/main.page.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:conexion_mas/widgets/detalleEvento.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localstorage/localstorage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late EventosItems eventosList;
  bool _loading = true;
  Timer? _timer;

  String diasTxt = "0";
  String horasTxt = "0";
  String minutosTxt = "0";
  String segundosTxt = "0";

  int _currentPage = 0;
  PageController _pageController = PageController();

  String? _token;

  @override
  void initState() {
    super.initState();

    _getToken();

    isLogin();
    _initializeNotifications();
    _determinePosition();
    listarEventoPortada();
  }

  void _initializeNotifications() {
    // Configurar el contexto después de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.setContext(context);
    });

    // Inicializar notificaciones
    setupPushNotifications();
  }

  Future<void> _getToken() async {
    await initLocalStorage();

    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = token;
    });
    localStorage.setItem('miTokenNotificaciones', _token!);
  }

  Future<void> updateTokenNotificaciones(
      String idUser, String idDevice, String token) async {
    await AuthService().updateTokenNotification(
      idUser,
      token,
      idDevice,
    );
  }

  Future<void> isLogin() async {
    await initLocalStorage();

    try {
      if (localStorage.getItem('isLogin') == 'true') {
        final email = localStorage.getItem('miUser')!.toString();
        final password = localStorage.getItem('miPass')!.toString();

        var iTems = await AuthService().login(email, password);
        Map myMap = jsonDecode(iTems!);

        if (myMap['res']) {
          localStorage.setItem('miToken', myMap['token'].toString());
          localStorage.setItem('miIdUser', myMap['idUser'].toString());
          localStorage.setItem('miEmail', myMap['email'].toString());
          localStorage.setItem('miIglesia', myMap['idIglesia'].toString());
          localStorage.setItem(
              'miOrganizacion', myMap['idOrganizacion'].toString());

          localStorage.setItem('miDistrito', myMap['distrito'].toString());
          localStorage.setItem('miRegion', myMap['region'].toString());
          localStorage.setItem('miRole', myMap['role'].toString());

          localStorage.setItem('isLogin', 'true');
          localStorage.setItem('miUser', email);
          localStorage.setItem('miPass', password);

          // Setear el token en el ApiService
          ReservasApiClient.setApiToken(myMap['token'].toString());
          ProfileService.setAuthToken(myMap['token'].toString());

          updateTokenNotificaciones(
            myMap['idUser'].toString(),
            localStorage.getItem('miTokenNotificaciones')!.toString(),
            myMap['token'].toString(),
          );
        } else {
          localStorage.removeItem('isLogin');
          localStorage.removeItem('miIdUser');
          localStorage.removeItem('miToken');
          localStorage.removeItem('miIglesia');
        }
      }
    } catch (e) {
      localStorage.removeItem('isLogin');
      localStorage.removeItem('miIdUser');
      localStorage.removeItem('miToken');
      localStorage.removeItem('miIglesia');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void listarEventoPortada() {
    EventosApiClient().getEventoPortada().then((eventos) {
      if (eventos.evento!.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPageView()),
        );
      } else {
        setState(() {
          eventosList = eventos;
        });

        // Inicializar el timer para la primera página
        _iniciarTimerParaPagina(_currentPage);
      }
    });
  }

  void _iniciarTimerParaPagina(int pagina) {
    // Cancelar timer existente si hay uno
    _timer?.cancel();

    // Crear nuevo timer para la página actual
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (eventosList != null && eventosList!.evento!.isNotEmpty) {
        calcularCuantoFalta(
            "${eventosList!.evento![pagina].fecha} ${eventosList!.evento![pagina].hora}");
      }
    });
  }

  List<int> calcularCuantoFalta(String fechaEvento) {
    DateTime fecha1 = DateTime.now();
    DateTime fecha2 = DateTime.parse(fechaEvento);

    // Calcular la diferencia
    Duration diferencia = fecha2.difference(fecha1);

    // Extraer días, horas, minutos y segundos
    int dias = diferencia.inDays;
    int horas = diferencia.inHours % 24;
    int minutos = diferencia.inMinutes % 60;
    int segundos = diferencia.inSeconds % 60;

    if (dias < 0) {
      _timer!.cancel();
      setState(() {
        diasTxt = "0";
        horasTxt = "0";
        minutosTxt = "0";
        segundosTxt = "0";

        _loading = false;
      });
    } else {
      setState(() {
        diasTxt = dias.toString();
        horasTxt = horas.toString();
        minutosTxt = minutos.toString();
        segundosTxt = segundos.toString();
        _loading = false;
      });
    }

    return [dias, horas, minutos, segundos];
  }

  Future<Position> _determinePosition() async {
    await initLocalStorage();
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
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    localStorage.setItem('mi_latitud', position.latitude.toString());
    localStorage.setItem('mi_longitud', position.longitude.toString());
    // localStorage.setItem('isLogin', 'false');

    print("País: ${placemarks.first.country}");

    return position;
  }

  @override
  void dispose() {
    _timer?.cancel(); // Usamos ?. porque _timer puede ser null
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildEventoPage(int index) {
    final evento = eventosList.evento![index];
    _iniciarTimerParaPagina(index);

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: CachedNetworkImage(
            imageUrl:
                "${MainUtils.urlHostAssetsImagen}/${eventosList.evento![index].imagen}",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    ColorsUtils.principalColor,
                    BlendMode.colorBurn,
                  ),
                ),
              ),
            ),
            placeholder: (context, url) => SizedBox(
                width: 50, height: 50, child: const LinearProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        // CAPA TRANPARENTE
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              color: ColorsUtils.negroColor.withOpacity(0.5),
            ),
          ),
        ),
        // BOTON SALTAR
        Positioned(
          top: 60,
          right: 10,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPageView()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: ColorsUtils.principalColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Text(
                  'ENTRAR',
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
        // TITULO DEL EVENTO
        Positioned(
          top: 300,
          left: 20,
          right: 40,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventosList.evento![index].titulo ?? "Titulo del evento",
                  style: TextStyle(
                    height: 1.1,
                    color: ColorsUtils.blancoColor,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  eventosList.evento![index].descripcionCorta ??
                      "Descripcion corta del evento",
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    height: 1.1,
                    fontSize: 16,
                  ),
                ),
                frcaWidget.frca_separacion(),
              ],
            ),
          ),
        ),
        // FECHA Y HORA CUENTA ATRAS
        Positioned(
          bottom: 110,
          left: 20,
          right: 20,
          child: frcaWidget.frca_cuenta_atras(
              diasTxt, horasTxt, minutosTxt, segundosTxt),
        ),
        Positioned(
          bottom: 30,
          left: 40,
          right: 40,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetalleEvento(
                          index: index,
                          evento: eventosList,
                          controller: PageController(),
                        )),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: ColorsUtils.principalColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    "Mas información",
                    style: TextStyle(
                        color: ColorsUtils.blancoColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPageIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < eventosList.evento!.length; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? ColorsUtils.principalColor
                : ColorsUtils.blancoColor.withOpacity(0.5),
          ),
        ),
      );
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? frcaWidget.frca_loading_container()
          : Stack(
              children: [
                // CARRUSEL DE EVENTOS
                PageView.builder(
                  controller: _pageController,
                  itemCount: eventosList.evento!.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                    // Actualizar el contador para el nuevo evento
                  },
                  itemBuilder: (context, index) {
                    return _buildEventoPage(index);
                  },
                ),

                // INDICADORES DE PAGINACIÓN
                if (eventosList.evento!.length > 1)
                  Positioned(
                    bottom: 200,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicators(),
                    ),
                  ),
              ],
            ),
    );
  }
}
