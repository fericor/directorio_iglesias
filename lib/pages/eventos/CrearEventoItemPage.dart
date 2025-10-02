import 'package:conexion_mas/controllers/MisEventoItemService.dart';
import 'package:conexion_mas/models/MisEventosItems.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';

class CrearEventoItemPage extends StatefulWidget {
  final String eventoId;
  final String token;
  final VoidCallback onItemCreado;

  const CrearEventoItemPage({
    Key? key,
    required this.eventoId,
    required this.token,
    required this.onItemCreado,
  }) : super(key: key);

  @override
  _CrearEventoItemPageState createState() => _CrearEventoItemPageState();
}

class _CrearEventoItemPageState extends State<CrearEventoItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController(text: '0.00');
  final _cantidadController = TextEditingController(text: '0');

  final MisEventoItemService _itemService = MisEventoItemService(
    baseUrl: MainUtils.urlHostApi,
  );

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.fondoColor,
      appBar: AppBar(
          title: Text(
        'Crear Entrada',
        style: TextStyle(
          color: ColorsUtils.blancoColor,
        ),
      )),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _tituloController,
                      decoration: const InputDecoration(labelText: 'Título*'),
                      validator: (value) => value!.isEmpty ? 'Requerido' : null,
                    ),
                    TextFormField(
                      controller: _descripcionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción*'),
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? 'Requerido' : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _precioController,
                            decoration:
                                const InputDecoration(labelText: 'Precio*'),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cantidadController,
                            decoration:
                                const InputDecoration(labelText: 'Cantidad*'),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _crearItem,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 26,
                        ),
                        child: Text(
                          'Crear Evento',
                          style: TextStyle(
                            color: ColorsUtils.blancoColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _crearItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final nuevoItem = MisEventoItem(
        idEvento: widget.eventoId,
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        precio: double.parse(_precioController.text),
        cantidad: int.parse(_cantidadController.text),
        disponible: int.parse(_cantidadController.text),
        reservadas: 0,
      );

      await _itemService.crearItem(nuevoItem, widget.token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrada creada correctamente')),
      );

      widget.onItemCreado();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }
}
