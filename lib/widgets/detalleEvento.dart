import 'package:directorio_iglesias/controllers/stripeApiClient.dart';
import 'package:directorio_iglesias/models/eventosItems.dart';
import 'package:directorio_iglesias/screens/LoginScreen.dart';
import 'package:directorio_iglesias/screens/qrEventoDetalleScreen.dart';
import 'package:directorio_iglesias/utils/colorsUtils.dart';
import 'package:directorio_iglesias/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class DetalleEvento extends StatefulWidget {
  PageController controller;
  EventosItems evento;
  DetalleEvento({super.key, required this.controller, required this.evento});

  @override
  State<DetalleEvento> createState() => _DetalleEventoState();
}

class _DetalleEventoState extends State<DetalleEvento> {
  final List<Map<String, dynamic>> _items = [];
  String totalPagar = "0";
  String idUser = "0";
  bool is_Login = false;

  @override
  void initState() {
    super.initState();
    _crearListProductos();
    isLogin();
  }

  Future<void> isLogin() async {
    await initLocalStorage();

    setState(() {
      is_Login = localStorage.getItem('isLogin') == 'true';
      idUser = localStorage.getItem('miIdUser').toString();
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

  void iniciarPago() {
    StripePaymentHandle().stripeMakePayment(totalPagar);
  }

  /*Future<void> infoAjustes() async {
    await initLocalStorage();

    var iTems = await AuthService().infoUser(
        localStorage.getItem('miIdUser').toString(),
        localStorage.getItem('miToken').toString());
    Map myMap = jsonDecode(iTems);

    if (myMap.isNotEmpty != null) {
      _nombreController.text = myMap['nombre'];
      _apellidosController.text = myMap['apellidos'];
      _nacimientoController.text = myMap['nacimiento'];
      _telefonoController.text = myMap['telefono'];
      _emailController.text = myMap['email'];
    }
  }*/

  void _updateItem(double cantidad, int index) {
    double total = 0.0;
    double subTotal =
        double.parse(_items[index]["precio"]).toDouble() * cantidad;

    _items[index].update('subTotal', (value) => subTotal);
    _items[index].update('cantidad', (value) => cantidad);

    for (int i = 0; i < _items.length; i++) {
      total += _items[i]["subTotal"];
    }

    setState(() {
      // totalPagar = ((total).round()).toString();
      totalPagar = (total).toStringAsFixed(2).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ColorsUtils.principalColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
              ),
            ),
            actions: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ColorsUtils.principalColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QrEventoDetalleScreen()),
                    );
                  },
                  icon: Icon(Icons.favorite_border),
                  color: Colors.white,
                ),
              ),
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
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              background: Image.network(
                widget.evento.evento![0].imagen!, // URL de la imagen
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
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${widget.evento.evento![0].etiqueta!} | ${widget.evento.evento![0].fecha!} - ${widget.evento.evento![0].hora!}",
                          style: TextStyle(
                            color: Colors.white70,
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
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 32),
                    for (int i = 0; i < widget.evento.items!.length; i++)
                      frcaWidget.frca_number_evento(
                          widget.evento.items![i].titulo!,
                          widget.evento.items![i].descripcion!,
                          widget.evento.items![i].precio!,
                          widget.evento.items![i].cantidad!,
                          context,
                          _updateItem,
                          i),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (widget.evento.items!.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          is_Login
                              ? iniciarPago()
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                          controller: widget.controller)),
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
                                "(${totalPagar.toString()}€) COMPRAR",
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
