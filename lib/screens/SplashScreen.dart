import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:directorio_iglesias/controllers/AuthService.dart';
import 'package:directorio_iglesias/controllers/eventosApiClient.dart';
import 'package:directorio_iglesias/models/eventosItems.dart';
import 'package:directorio_iglesias/pages/main.page.dart';
import 'package:directorio_iglesias/utils/widgets.dart';
import 'package:directorio_iglesias/widgets/detalleEvento.dart';
import 'package:flutter/material.dart';
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

  late Timer _timer;

  String diasTxt = "0";
  String horasTxt = "0";
  String minutosTxt = "0";
  String segundosTxt = "0";

  @override
  void initState() {
    super.initState();

    isLogin();
    _determinePosition();
    listarEventoPortada();
  }

  Future<void> isLogin() async {
    await initLocalStorage();

    try {
      if (localStorage.getItem('isLogin') == 'true') {
        final email = localStorage.getItem('miUser')!.toString();
        final password = localStorage.getItem('miPass')!.toString();

        var iTems = await AuthService().login(email, password);
        Map myMap = jsonDecode(iTems);

        localStorage.setItem('miToken', myMap['token'].toString());
        localStorage.setItem('miIdUser', myMap['idUser'].toString());
        localStorage.setItem('miEmail', myMap['email'].toString());

        localStorage.setItem('isLogin', 'true');
        localStorage.setItem('miUser', email);
        localStorage.setItem('miPass', password);
      }
    } catch (e) {
      localStorage.setItem('isLogin', 'false');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void listarEventoPortada() {
    EventosApiClient().getEventoPortada().then((eventos) {
      if (eventos.items!.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPageView()),
        );
      } else {
        setState(() {
          eventosList = eventos;
        });

        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          calcularCuantoFalta(
              "${eventosList.evento![0].fecha} ${eventosList.evento![0].hora}");
        });
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
      _timer.cancel();
      setState(() {
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

    localStorage.setItem('mi_latitud', position.latitude.toString());
    localStorage.setItem('mi_longitud', position.longitude.toString());
    // localStorage.setItem('isLogin', 'false');

    return position;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? frcaWidget.frca_loading_container()
          : Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CachedNetworkImage(
                    imageUrl: eventosList.evento![0].imagen ??
                        "https://vallmarketing.es/app_assets/images/eventos/event-1.jpg",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            Colors.red,
                            BlendMode.colorBurn,
                          ),
                        ),
                      ),
                    ),
                    placeholder: (context, url) => SizedBox(
                        width: 50,
                        height: 50,
                        child: const LinearProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                // CAPA TRANPARENTE
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
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
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Text(
                          'ENTRAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                          eventosList.evento![0].titulo ?? "Titulo del evento",
                          style: TextStyle(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          eventosList.evento![0].descripcionCorta ??
                              "Descripcion corta del evento",
                          style: TextStyle(
                            color: Colors.white,
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
                                  evento: eventosList,
                                  controller: PageController(),
                                )),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            "Mas información",
                            style: TextStyle(
                                color: Colors.white,
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
            ),
    );
  }
}
