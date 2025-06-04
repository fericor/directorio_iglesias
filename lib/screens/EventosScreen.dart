import 'package:directorio_iglesias/controllers/eventosApiClient.dart';
import 'package:directorio_iglesias/controllers/iglesiasApiClient.dart';
import 'package:directorio_iglesias/models/eventos.dart';
import 'package:directorio_iglesias/models/iglesias.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:directorio_iglesias/utils/widgets.dart';
import 'package:directorio_iglesias/widgets/cardMain.dart';
import 'package:directorio_iglesias/widgets/cardSimpleIglesia.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:localstorage/localstorage.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  late List<Eventos> eventosList = [];
  late List<Eventos> eventosListSearch = [];
  late List<Iglesias> churches = [];
  double miLongitud = 0.0;
  double miLatitud = 0.0;
  double distancia = 5.0;
  double sliderValue = 5;
  bool _loadingEventos = true;
  bool _loadingIglesias = true;
  int _num = 0;

  @override
  void initState() {
    super.initState();

    listarIglesiasCerca();
    listarEventosTodos();
  }

  void listarEventosTodos() {
    EventosApiClient().getEventoss().then((eventos) {
      setState(() {
        eventosList = eventos;
        eventosListSearch = eventos;
        _loadingEventos = false;
      });
    });
  }

  void listarEventosDistrito(int num) {
    setState(() {
      _loadingEventos = true;
    });

    if (num == 0) {
      listarEventosTodos();
      setState(() {
        _num = num;
      });
    } else {
      EventosApiClient().getEventosRegion(num.toString()).then((eventos) {
        setState(() {
          eventosList = eventos;
          eventosListSearch = eventos;
          _num = num;
          _loadingEventos = false;
        });
      });
    }
  }

  void _searchEvento(texto) {
    setState(() {
      _loadingEventos = true;
    });

    String query = texto.toLowerCase();

    setState(() {
      eventosList = eventosListSearch
          .where((c) => c.titulo!.toLowerCase().contains(query))
          .toList();

      _loadingEventos = false;
    });
  }

  Future<void> listarIglesiasCerca() async {
    await initLocalStorage();

    setState(() {
      _loadingIglesias = true;
      miLatitud = double.parse(localStorage.getItem('mi_latitud')!);
      miLongitud = double.parse(localStorage.getItem('mi_longitud')!);
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
        _loadingIglesias = false;
      });
    });
  }

  void cambioDistancia(double distance) {
    setState(() {
      distancia = distance;
    });
    listarIglesiasCerca();
  }

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
          // BUSCADOR
          Positioned(
            top: Platform.isAndroid ? 30 : 60,
            left: 15,
            right: 15,
            child: frcaWidget.frca_buscador(
                _MiPopover(), _searchEvento, "Buscar Evento", context, false),
          ),
          // LISTA DE CATEGORIAS
          Positioned(
            top: Platform.isAndroid ? 100 : 130,
            left: 20,
            right: 20,
            child: frcaWidget.frca_categori_list(listarEventosDistrito, _num),
          ),
          //CONTENIDO
          Positioned(
            top: Platform.isAndroid ? 140 : 170,
            left: 10,
            right: 10,
            bottom: 220,
            child: _loadingEventos
                ? frcaWidget.frca_loading_simple()
                : eventosList.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            //////////
                            for (var evento in eventosList)
                              CardMain(
                                idEvento: evento.idEvento!.toString(),
                                titulo: evento.titulo!,
                                descripcion: evento.descripcionCorta!,
                                fecha: evento.fecha!,
                                hora: evento.hora!,
                                etiqueta: evento.etiqueta!,
                                tipo: evento.tipo!,
                                imagen: evento.imagen!,
                                evento: [evento],
                                controller: PageController(),
                              ),
                            //////////
                          ],
                        ),
                      )
                    : frcaWidget.frca_not_lista(),
          ),
          // IGLESIAS CERCA
          Positioned(
            left: 15,
            right: 15,
            bottom: 75,
            child: Column(
              children: [
                frcaWidget.frca_texto_header(
                    "${churches.length} iglesias cerca a ${distancia}km",
                    popupMenuIglesias()),
                _loadingIglesias
                    ? frcaWidget.frca_loading_simple()
                    : churches.isNotEmpty
                        ? SizedBox(
                            height: 95,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (var church in churches)
                                  CardSimpleIglesia(
                                    idIglesia: church.idIglesia!.toString(),
                                    iglesia: church.titulo!,
                                    miLatitud: miLatitud,
                                    miLongitud: miLongitud,
                                    latitud: church.latitud!,
                                    longitud: church.longitud!,
                                    telefono: church.telefono!,
                                  ),
                              ],
                            ),
                          )
                        : frcaWidget
                            .frca_not_lista_txt("No hay iglesias cerca"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////
  Widget _MiPopover() {
    return SizedBox();
  }

  Widget popupMenuIglesias() {
    return PopupMenuButton(
      icon: Icon(Icons.filter_alt, color: ColorsUtils.principalColor),
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
                    min: 5,
                    max: 100,
                    divisions: 10,
                    label: sliderValue.round().toString(),
                    onChanged: (newValue) {
                      cambioDistancia(newValue);
                      setState(() {
                        sliderValue = newValue;
                      });
                    },
                  ),
                  Text('Distancia: ${sliderValue.round()}km'),
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
