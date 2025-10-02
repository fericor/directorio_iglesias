import 'package:conexion_mas/controllers/MisEventoItemService.dart';
import 'package:conexion_mas/models/MisEventosItems.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';

class EditarEventoItemPage extends StatefulWidget {
  final MisEventoItem item;
  final String token;
  final VoidCallback onItemActualizado;

  const EditarEventoItemPage({
    Key? key,
    required this.item,
    required this.token,
    required this.onItemActualizado,
  }) : super(key: key);

  @override
  _EditarEventoItemPageState createState() => _EditarEventoItemPageState();
}

class _EditarEventoItemPageState extends State<EditarEventoItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _cantidadController;

  final MisEventoItemService _itemService = MisEventoItemService(
    baseUrl: MainUtils.urlHostApi,
  );

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _inicializarControllers();
  }

  void _inicializarControllers() {
    _tituloController = TextEditingController(text: widget.item.titulo);
    _descripcionController =
        TextEditingController(text: widget.item.descripcion);
    _precioController =
        TextEditingController(text: widget.item.precio.toStringAsFixed(2));
    _cantidadController =
        TextEditingController(text: widget.item.cantidad.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.fondoColor,
        title: Text(
          'Editar Entrada',
          style: TextStyle(color: ColorsUtils.blancoColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _loading ? null : _actualizarItem,
          ),
        ],
      ),
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descripcionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción*'),
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _precioController,
                            decoration:
                                const InputDecoration(labelText: 'Precio*'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value!.isEmpty) return 'Requerido';
                              if (double.tryParse(value) == null)
                                return 'Precio inválido';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cantidadController,
                            decoration:
                                const InputDecoration(labelText: 'Cantidad*'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) return 'Requerido';
                              if (int.tryParse(value) == null)
                                return 'Cantidad inválida';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _actualizarItem,
                            child: const Text('Guardar Cambios'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoReservas(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoReservas() {
    return Card(
      color: ColorsUtils.segundoColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información de Reservas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Disponibles: ${widget.item.disponible}'),
            Text('Reservadas: ${widget.item.reservadas}'),
            Text('Total: ${widget.item.cantidad}'),
            const SizedBox(height: 8),
            if (widget.item.reservadas > 0)
              const Text(
                '⚠️ Hay reservas activas. Los cambios afectarán la disponibilidad.',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _actualizarItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final nuevoDisponible =
          int.parse(_cantidadController.text) - widget.item.reservadas;

      if (nuevoDisponible < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('La cantidad no puede ser menor a las reservas activas'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final itemActualizado = MisEventoItem(
        id: widget.item.id,
        idEvento: widget.item.idEvento,
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        precio: double.parse(_precioController.text),
        cantidad: int.parse(_cantidadController.text),
        disponible: nuevoDisponible,
        reservadas: widget.item.reservadas,
      );

      await _itemService.actualizarItem(itemActualizado, widget.token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrada actualizada correctamente')),
      );

      widget.onItemActualizado();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
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
