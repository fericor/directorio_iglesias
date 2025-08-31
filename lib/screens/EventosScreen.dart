import 'package:conexion_mas/controllers/eventosApiClient.dart';
import 'package:conexion_mas/controllers/iglesiasApiClient.dart';
import 'package:conexion_mas/models/categorias.dart';
import 'package:conexion_mas/models/eventos.dart';
import 'package:conexion_mas/models/iglesias.dart';
import 'package:conexion_mas/models/misreservas.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:conexion_mas/widgets/cardMain.dart';
import 'package:conexion_mas/widgets/cardSimpleEvento.dart';
import 'package:conexion_mas/widgets/cardSimpleIglesia.dart';
import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  int _selectedIndex = 0;
  List<Categorias> _categocategoriasListrias = [];
  late List<Eventos> eventosList = [];
  late List<Eventos> eventosListSearch = [];
  late List<Iglesias> churches = [];
  late List<MisReservas> misReservas = [];

  String idUser = localStorage.getItem('miIdUser').toString() ?? '0';
  String apiToken = localStorage.getItem('miToken').toString() ?? '0';
  double miLongitud = 0.0;
  double miLatitud = 0.0;
  double distancia = 5.0;
  double sliderValue = 5;
  bool _loadingEventos = true;
  bool _loadingIglesias = true;
  int _num = 0;
  bool is_Login = false;
  int idIglesia = 0;
  double altoContenido = 280.0;
  double altoEventos = 40.0;
  bool hayEventos = false;

  @override
  void initState() {
    super.initState();

    is_Login = localStorage.getItem('isLogin') == 'true';

    initEventosIsLogin();
    listarIglesiasCerca();
  }

  void initEventosIsLogin() {
    if (is_Login) {
      idIglesia = int.parse(localStorage.getItem('miIglesia').toString());
      listarEventosIglesia(idIglesia);
      listarEventosByIdUser(idUser);
      listarEventosCategoriasTodosIglesia(idIglesia);
    } else {
      listarEventosTodos();
      listarEventosCategoriasTodos();
    }
  }

  void listarEventosCategoriasTodos() {
    EventosApiClient().getEventosCategorias().then((categorias) {
      setState(() {
        _categocategoriasListrias = categorias;
      });
    });
  }

  void listarEventosCategoriasTodosIglesia(int idIglesia) {
    EventosApiClient()
        .getEventosCategoriasIglesia(idIglesia)
        .then((categorias) {
      setState(() {
        _categocategoriasListrias = categorias;
      });
    });
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

  void listarEventosIglesia(int idIglesia) {
    EventosApiClient().getEventosIglesia(idIglesia).then((eventos) {
      setState(() {
        eventosList = eventos;
        eventosListSearch = eventos;
        _loadingEventos = false;
      });
    });
  }

  void listarEventosByIdUser(String idUser) {
    EventosApiClient().getEventoByUser(idUser, apiToken).then((reservas) {
      setState(() {
        misReservas = reservas;
      });
    });
  }

  void listarEventosDistrito(int num) {
    setState(() {
      _loadingEventos = true;
    });

    if (num == 0) {
      if (is_Login) {
        idIglesia = int.parse(localStorage.getItem('miIglesia').toString());
        listarEventosIglesia(idIglesia);
      } else {
        listarEventosTodos();
      }
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
        altoContenido = iglesias.first.eventosIglesia!.length > 0 ? 345 : 280;
        altoEventos = iglesias.first.eventosIglesia!.length > 0 ? 100 : 40;
        hayEventos = iglesias.first.eventosIglesia!.length > 0 ? true : false;
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
      backgroundColor: ColorsUtils.fondoColor,
      body: Stack(
        children: [
          // BUSCADOR
          Positioned(
            top: 55,
            left: 15,
            right: 15,
            child: frcaWidget.frca_buscador(_MiPopover(), _searchEvento,
                "Buscar Evento", context, false, false),
          ),
          // LISTA DE CATEGORIAS
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: frcaWidget.frca_categori_list(
                listarEventosDistrito, _num, _categocategoriasListrias),
          ),
          //CONTENIDO
          Positioned(
            top: 160,
            left: 10,
            right: 10,
            bottom: altoContenido,
            child: _loadingEventos
                ? frcaWidget.frca_loading_simple()
                : eventosList.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            /*ElevatedButton(
                              onPressed: () {
                                // Navegación manual de prueba
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationDetailScreen(
                                      notificationTitle: 'Prueba',
                                      notificationContent:
                                          'Esta es una prueba de navegación',
                                      data: {'id': 'test123', 'type': 'test'},
                                    ),
                                  ),
                                );
                              },
                              child: Text('Probar Navegación'),
                            ),*/
                            //////////
                            for (var evento in eventosList)
                              CardMain(
                                idUser: idUser,
                                idEvento: evento.idEvento!.toString(),
                                titulo: evento.titulo!,
                                descripcion: evento.descripcionCorta!,
                                fecha: evento.fecha!,
                                hora: evento.hora!,
                                etiqueta: evento.etiqueta!,
                                tipo: evento.tipo!,
                                imagen:
                                    "${MainUtils.urlHostAssetsImagen}/${evento.imagen!}",
                                evento: [evento],
                                controller: PageController(),
                              ),
                            //////////
                          ],
                        ),
                      )
                    : frcaWidget.frca_not_lista(),
          ),
          // MIS EVENTOS & IGLESIAS CERCA
          Positioned(
            left: 15,
            right: 15,
            bottom: 85,
            child: Column(
              children: [
                frcaWidget.frca_texto_header(
                  is_Login
                      ? "Mis eventos apuntados"
                      : "Eventos destacados cerca de ti",
                  SizedBox(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                is_Login
                    ? misReservas.isNotEmpty
                        ? Column(
                            children: [
                              for (var reserva in misReservas)
                                if (reserva.miseventos != null &&
                                    reserva.miseventos!.isNotEmpty) ...[
                                  for (var evento in reserva.miseventos!)
                                    CardSimpleEvento(
                                      idUser: idUser,
                                      idEvento: evento.idEvento!.toString(),
                                      titulo: evento.titulo!,
                                      descripcion: evento.descripcionCorta!,
                                      fecha: evento.fecha!,
                                      hora: evento.hora!,
                                      etiqueta: evento.etiqueta!,
                                      tipo: evento.tipo!,
                                      imagen:
                                          "${MainUtils.urlHostAssetsImagen}/${evento.imagen!}",
                                      controller: PageController(),
                                    ),
                                ] else
                                  frcaWidget.frca_not_lista_txt(
                                      "No hay eventos cerca"),
                            ],
                          )
                        : frcaWidget.frca_not_lista_txt("No hay eventos cerca")
                    : _loadingIglesias // AQUI ES CUANDO NO ESTO LOGUEADO
                        ? frcaWidget.frca_loading_simple()
                        : hayEventos
                            ? SizedBox(
                                height: altoEventos,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (var church in churches)
                                      if (church
                                          .eventosIglesia!.isNotEmpty) ...[
                                        for (var evento
                                            in church.eventosIglesia ?? [])
                                          CardSimpleEvento(
                                            idUser: idUser,
                                            idEvento:
                                                evento.idEvento!.toString(),
                                            titulo: evento.titulo!,
                                            descripcion:
                                                evento.descripcionCorta!,
                                            fecha: evento.fecha!,
                                            hora: evento.hora!,
                                            etiqueta: evento.etiqueta!,
                                            tipo: evento.tipo!,
                                            imagen:
                                                "${MainUtils.urlHostAssetsImagen}/${evento.imagen!}",
                                            controller: PageController(),
                                          ),
                                      ]
                                  ],
                                ),
                              )
                            : frcaWidget
                                .frca_not_lista_txt("No hay eventos cerca"),

                ///////////////
                frcaWidget.frca_texto_header(
                    "${churches.length} iglesias cerca a ${distancia}km",
                    popupMenuIglesias()),
                _loadingIglesias
                    ? frcaWidget.frca_loading_simple()
                    : churches.isNotEmpty
                        ? SizedBox(
                            height: 70,
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
                                    church: church,
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
