import 'package:cached_network_image/cached_network_image.dart';
import 'package:conexion_mas/controllers/EventoService.dart';
import 'package:conexion_mas/controllers/eventosApiClient.dart';
import 'package:conexion_mas/pages/eventos/EventoItemsListPage.dart';
import 'package:conexion_mas/pages/eventos/Crear_evento_page.dart';
import 'package:conexion_mas/pages/eventos/Editar_evento_page.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/MisEventos.dart';
import 'package:conexion_mas/screens/notificationDetailScreen.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';

class EventosListPage extends StatefulWidget {
  final String token;
  final String idIglesia;
  final String idOrganizacion;
  final int userRole;
  final int userId;
  final EventoService eventoService;

  const EventosListPage({
    Key? key,
    required this.token,
    required this.idIglesia,
    required this.idOrganizacion,
    required this.userRole,
    required this.userId,
    required this.eventoService,
  }) : super(key: key);

  @override
  _EventosListPageState createState() => _EventosListPageState();
}

class _EventosListPageState extends State<EventosListPage> {
  List<MisEventos> _eventos = [];
  bool _loading = true;
  bool _showOnlyActive = true;

  @override
  void initState() {
    super.initState();
    _cargarEventos();
  }

  Future<void> _cargarEventos() async {
    try {
      setState(() => _loading = true);

      if (widget.userRole == 1000) {
        _eventos = await widget.eventoService.getEventosTodos(widget.token);
      } else {
        _eventos = await widget.eventoService
            .getEventoByIglesia(widget.idIglesia, widget.token);
      }
    } catch (e) {
      _mostrarError('Error al cargar eventos: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _navegarAGestionarItems(MisEventos evento) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventoItemsListPage(
          eventoId: evento.idEvento!.toString(),
          token: widget.token,
          userRole: widget.userRole,
        ),
      ),
    );
  }

  void _mostrarError(String mensaje) {
    AppSnackbar.show(
      context,
      message: mensaje,
      type: SnackbarType.error,
    );
  }

  void _mostrarExito(String mensaje) {
    AppSnackbar.show(
      context,
      message: mensaje,
      type: SnackbarType.success,
    );
  }

  Future<void> _eliminarEvento(int id) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este evento?'),
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
        await widget.eventoService.eliminarEvento(id.toString(), widget.token);
        _mostrarExito('Evento eliminado correctamente');
        _cargarEventos();
      } catch (e) {
        _mostrarError('Error al eliminar evento: $e');
      }
    }
  }

  Future<void> _aprobarEvento(int id) async {
    try {
      //await widget.eventoService.aprobarEvento(id);
      _mostrarExito('Evento aprobado correctamente');
      _cargarEventos();
    } catch (e) {
      _mostrarError('Error al aprobar evento: $e');
    }
  }

  void _navegarACrearEvento() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearEventoPage(
          userRole: widget.userRole,
          userId: widget.userId,
          idIglesia: int.parse(widget.idIglesia),
          idOrganizacion: int.parse(widget.idOrganizacion),
          eventoService: widget.eventoService,
          onEventoCreado: _cargarEventos,
          token: widget.token,
        ),
      ),
    );
  }

  void _navegarAEditarEvento(MisEventos evento) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarEventoPage(
          evento: evento,
          userRole: widget.userRole,
          eventoService: widget.eventoService,
          onEventoActualizado: _cargarEventos,
          token: widget.token,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventosMostrados = _showOnlyActive && widget.userRole == 100
        ? _eventos.where((e) => e.activo == 1).toList()
        : _eventos;

    return Scaffold(
      backgroundColor: ColorsUtils.fondoColor,
      appBar: AppBar(
        title: Text(
          'Mis eventos',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
        actions: [
          if (widget.userRole == 100)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _navegarACrearEvento,
              tooltip: 'Crear nuevo evento',
            ),
          if (widget.userRole == 100)
            IconButton(
              icon: Icon(
                  _showOnlyActive ? Icons.visibility_off : Icons.visibility),
              onPressed: () =>
                  setState(() => _showOnlyActive = !_showOnlyActive),
              tooltip:
                  _showOnlyActive ? 'Mostrar todos' : 'Mostrar solo activos',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarEventos,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : eventosMostrados.isEmpty
              ? Center(
                  child: Text(
                    'No hay eventos disponibles',
                    style:
                        TextStyle(fontSize: 18, color: ColorsUtils.blancoColor),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarEventos,
                  child: ListView.builder(
                    itemCount: eventosMostrados.length,
                    itemBuilder: (context, index) {
                      final evento = eventosMostrados[index];
                      return _EventoCard(
                        evento: evento,
                        userRole: widget.userRole,
                        onItems: () => _navegarAGestionarItems(evento),
                        onEdit: () => _navegarAEditarEvento(evento),
                        onDelete: () => _eliminarEvento(evento.idEvento!),
                        onApprove: evento.activo != 1
                            ? () => _aprobarEvento(evento.idEvento!)
                            : null,
                      );
                    },
                  ),
                ),
    );
  }
}

class _EventoCard extends StatelessWidget {
  final MisEventos evento;
  final int userRole;
  final VoidCallback? onItems;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onApprove;

  const _EventoCard({
    required this.evento,
    required this.userRole,
    this.onItems,
    this.onEdit,
    this.onDelete,
    this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: evento.activo == 1
          ? ColorsUtils.segundoColor
          : ColorsUtils.terceroColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: CachedNetworkImage(
          width: 80,
          height: 100,
          imageUrl: "${MainUtils.urlHostAssetsImagen}/${evento.imagen}",
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
        title: Text(
          evento.titulo!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: evento.activo! != 1
                ? ColorsUtils.blancoColor
                : ColorsUtils.principalColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(evento.lugar ?? "Lugar no asignado"),
            Text(
                '${_formatDate(DateTime.parse(evento.fecha!))} ${evento.hora!}'),
            if (evento.activo != 1)
              Text(
                'Pendiente de aprobación',
                style:
                    TextStyle(color: ColorsUtils.principalColor, fontSize: 12),
              ),
          ],
        ),
        trailing: userRole == 100 ? _buildAdminActions() : null,
        onTap: () {
          EventosApiClient()
              .getEventoByIdByUser(evento.idEvento!, "0")
              .then((eventoItem) {
            Navigator.of(context!).push(
              MaterialPageRoute(
                builder: (context) => DetalleEventoPush(
                  evento: eventoItem,
                  controller: PageController(),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildAdminActions() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        final items = <PopupMenuItem<String>>[];

        items.add(const PopupMenuItem(
          value: 'items',
          child: Row(children: [
            Icon(Icons.airplane_ticket),
            SizedBox(width: 8),
            Text('Gestionar entradas')
          ]),
        ));

        if (onEdit != null) {
          items.add(const PopupMenuItem(
            value: 'edit',
            child: Row(children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Editar')
            ]),
          ));
        }

        /*if (onApprove != null) {
          items.add(const PopupMenuItem(
            value: 'approve',
            child: Row(children: [
              Icon(Icons.check),
              SizedBox(width: 8),
              Text('Aprobar')
            ]),
          ));
        }*/

        if (onDelete != null) {
          items.add(const PopupMenuItem(
            value: 'delete',
            child: Row(children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Eliminar', style: TextStyle(color: Colors.red))
            ]),
          ));
        }

        return items;
      },
      onSelected: (value) {
        switch (value) {
          case 'items':
            onItems?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'approve':
            onApprove?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
