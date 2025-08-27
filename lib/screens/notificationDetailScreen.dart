import 'package:conexion_mas/controllers/reservasApiClient.dart';
import 'package:conexion_mas/controllers/stripeApiClient.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/eventosItems.dart';
import 'package:conexion_mas/models/reservas.dart';
import 'package:conexion_mas/screens/MisReservasScreen.dart';
import 'package:conexion_mas/screens/qrEventoDetalleScreen.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';

class DetalleEventoPush extends StatefulWidget {
  EventosItems evento;
  DetalleEventoPush({super.key, required this.evento});

  @override
  State<DetalleEventoPush> createState() => _DetalleEventoState();
}

class _DetalleEventoState extends State<DetalleEventoPush> {
  final List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _selectedItems = [];
  String totalPagar = "0";
  String idUser = "0";
  bool is_Login = false;
  bool is_Reservado = false;

  @override
  void initState() {
    super.initState();

    _crearListProductos();
    isLogin();
  }

  Future<void> _crearReservas() async {
    if (_selectedItems.isEmpty) {
      AppSnackbar.show(
        context,
        message: 'Selecciona al menos un tipo de entrada',
        type: SnackbarType.warning,
      );
      return;
    }

    try {
      final result = await ReservasApiClient.crearReserva(
        idEvento: int.parse(widget.evento.evento![0].idEvento!),
        idUsuario: int.parse(idUser),
        items: _selectedItems,
      );

      if (result['success'] == true) {
        final reserva = result['reserva'] as Reserva;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MisreservasScreen(),
          ),
        );
      } else {
        AppSnackbar.show(
          context,
          message: "${result['error']} ❌",
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        context,
        message: "$e ❌",
        type: SnackbarType.error,
      );
    }
  }

  Future<void> isLogin() async {
    await initLocalStorage();

    setState(() {
      is_Login = localStorage.getItem('isLogin') == 'true';
      idUser = localStorage.getItem('miIdUser').toString();
      is_Reservado = widget.evento.reservas!.length > 0;
    });
  }

  void _crearListProductos() {
    for (int i = 0; i < widget.evento.items!.length; i++) {
      Map<String, dynamic> item = {
        'id': widget.evento.items![i].id,
        'nombre': widget.evento.items![i].titulo,
        'precio': widget.evento.items![i].precio,
        'cantidad': 0,
        'subTotal': 0,
      };
      _items.add(item);
    }
  }

  void iniciarPago() async {
    if (_selectedItems.isEmpty) {
      AppSnackbar.show(
        context,
        message: 'Selecciona al menos un tipo de entrada',
        type: SnackbarType.warning,
      );
      return;
    }

    bool pagoExitoso =
        await StripePaymentHandle().stripeMakePayment(totalPagar);

    if (pagoExitoso) {
      Fluttertoast.showToast(msg: "Pago confirmado ✅");
      AppSnackbar.show(
        context,
        message: "Pago completado con éxito ✅",
        type: SnackbarType.success,
      );
      // await reservarProducto();
    } else {
      AppSnackbar.show(
        context,
        message: "Hubo un error en la transacción ❌",
        type: SnackbarType.error,
      );
    }
  }

  void _updateItem(double cantidad, int id, int index) {
    double total = 0.0;
    double subTotal =
        double.parse(_items[index]["precio"]).toDouble() * cantidad;

    _items[index].update('subTotal', (value) => subTotal);
    _items[index].update('cantidad', (value) => cantidad);

    for (int i = 0; i < _items.length; i++) {
      total += _items[i]["subTotal"];
    }

    _actualizarCantidad(id, cantidad);

    setState(() {
      // totalPagar = ((total).round()).toString();
      totalPagar = (total).toStringAsFixed(2).toString();
    });
  }

  void _actualizarCantidad(int itemId, double cantidad) {
    setState(() {
      final index =
          _selectedItems.indexWhere((item) => item['idEventoItem'] == itemId);

      if (index >= 0) {
        if (cantidad > 0) {
          _selectedItems[index]['cantidad'] = cantidad;
        } else {
          _selectedItems.removeAt(index);
        }
      } else if (cantidad > 0) {
        _selectedItems.add({
          'idEventoItem': itemId,
          'cantidad': cantidad,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: ColorsUtils.principalColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: ColorsUtils.blancoColor,
              ),
            ),

            actions: [
              is_Reservado
                  ? Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: ColorsUtils.principalColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QrEventoDetalleScreen(
                                    evento: widget.evento)),
                          );
                        },
                        icon: Icon(Icons.qr_code),
                        color: ColorsUtils.blancoColor,
                        iconSize: 30.0,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
            expandedHeight: 300.0, // Altura inicial de la imagen
            floating: false,
            pinned: false, // Mantiene la barra visible al hacer scroll
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: ColorsUtils.principalColor.withOpacity(0.7)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.evento.evento![0].titulo!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtils.blancoColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              background: Image.network(
                "${MainUtils.urlHostAssetsImagen}/${widget.evento.evento![0].imagen!}", // URL de la imagen
                fit: BoxFit.fitWidth, // Ajusta la imagen al espacio disponible
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    // Ratings and Duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.evento.evento![0].tipo!,
                          style: TextStyle(color: ColorsUtils.blancoColor),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${widget.evento.evento![0].etiqueta!} | ${widget.evento.evento![0].fecha!} - ${widget.evento.evento![0].hora!}",
                          style: TextStyle(
                            color: ColorsUtils.blancoColor,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.evento.evento![0].descripcion!,
                        style: TextStyle(color: ColorsUtils.blancoColor),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if ((widget.evento.items!.isNotEmpty) && (!is_Reservado))
                      for (int i = 0; i < widget.evento.items!.length; i++)
                        frcaWidget.frca_number_evento(
                          widget.evento.items![i].titulo!,
                          widget.evento.items![i].descripcion!,
                          widget.evento.items![i].precio!,
                          widget.evento.items![i].cantidad!,
                          context,
                          _updateItem,
                          int.parse(widget.evento.items![i].id!),
                          i,
                        ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if ((widget.evento.items!.isNotEmpty) && (!is_Reservado))
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsUtils.principalColor,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Text(
                                "(${totalPagar.toString()}€) COMPRAR",
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
                    SizedBox(
                      height: 10.0,
                    ),
                    if ((widget.evento.items!.isNotEmpty) && (!is_Reservado))
                      GestureDetector(
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: ColorsUtils.principalColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Comprar V1",
                              style: TextStyle(
                                color: ColorsUtils.blancoColor,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          // Acción al tocar el separador
                          _crearReservas();
                        },
                      ),
                    SizedBox(
                      height: 90.0,
                    ),
                  ],
                );
              },
              childCount: 1, // Número de elementos de la lista
            ),
          ),
        ],
      ),
    );
  }
}
