import 'package:conexion_mas/controllers/MisEventoItemService.dart';
import 'package:conexion_mas/pages/eventos/CrearEventoItemPage.dart';
import 'package:conexion_mas/pages/eventos/EditarEventoItemPage.dart';
import 'package:conexion_mas/models/MisEventosItems.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';

class EventoItemsListPage extends StatefulWidget {
  final String eventoId;
  final String token;
  final int userRole;

  const EventoItemsListPage({
    Key? key,
    required this.eventoId,
    required this.token,
    required this.userRole,
  }) : super(key: key);

  @override
  _EventoItemsListPageState createState() => _EventoItemsListPageState();
}

class _EventoItemsListPageState extends State<EventoItemsListPage> {
  final MisEventoItemService _itemService = MisEventoItemService(
    baseUrl: MainUtils.urlHostApi,
  );

  List<MisEventoItem> _items = [];
  String _eventoTitulo = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarItems();
  }

  Future<void> _cargarItems() async {
    try {
      setState(() => _loading = true);

      // Obtener la respuesta completa
      final response =
          await _itemService.getItemsByEvento(widget.eventoId, widget.token);

      // Extraer los datos correctamente
      setState(() {
        _items = response.itemsDisponibles;
        _eventoTitulo = response.evento;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _navegarACrearItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearEventoItemPage(
          eventoId: widget.eventoId,
          token: widget.token,
          onItemCreado: _cargarItems,
        ),
      ),
    );
  }

  void _navegarAEditarItem(MisEventoItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarEventoItemPage(
          item: item,
          token: widget.token,
          onItemActualizado: _cargarItems,
        ),
      ),
    );
  }

  Future<void> _eliminarItem(String id) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content:
            const Text('¿Estás seguro de que quieres eliminar esta entrada?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        await _itemService.eliminarItem(id, widget.token);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entrada eliminada correctamente')),
        );
        _cargarItems();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.fondoColor,
        title: Text(
          _eventoTitulo.isNotEmpty
              ? 'Entradas - $_eventoTitulo'
              : 'Entradas del Evento',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
        actions: [
          if (widget.userRole == 100)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _navegarACrearItem,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarItems,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _items.isEmpty
                  ? const Center(child: Text('No hay entradas disponibles'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return _ItemCard(
                          item: item,
                          userRole: widget.userRole,
                          onEdit: () => _navegarAEditarItem(item),
                          onDelete: () => _eliminarItem(item.id!),
                        );
                      },
                    ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final MisEventoItem item;
  final int userRole;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ItemCard({
    required this.item,
    required this.userRole,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.descripcion),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    'S/.${item.precio.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: ColorsUtils.negroColor,
                    ),
                  ),
                  backgroundColor: Colors.green[100],
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    '${item.disponible} disponibles',
                    style: TextStyle(
                      color: ColorsUtils.negroColor,
                    ),
                  ),
                  backgroundColor: Colors.blue[100],
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    '${item.reservadas} reservadas',
                    style: TextStyle(
                      color: ColorsUtils.negroColor,
                    ),
                  ),
                  backgroundColor: Colors.orange[100],
                ),
              ],
            ),
          ],
        ),
        trailing: userRole >= 100 ? _buildAdminActions() : null,
      ),
    );
  }

  Widget _buildAdminActions() {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('Editar')),
        const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
      ],
      onSelected: (value) {
        if (value == 'edit') onEdit?.call();
        if (value == 'delete') onDelete?.call();
      },
    );
  }
}
