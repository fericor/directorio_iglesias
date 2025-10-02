import 'package:cached_network_image/cached_network_image.dart';
import 'package:conexion_mas/controllers/MisIglesiaService.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/iglesias.dart';
import 'package:conexion_mas/pages/iglesias/CrearIglesiaPage.dart';
import 'package:conexion_mas/pages/iglesias/EditarIglesiaPage.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class IglesiasListPage extends StatefulWidget {
  final String token;
  final int userRole;

  const IglesiasListPage({
    Key? key,
    required this.token,
    required this.userRole,
  }) : super(key: key);

  @override
  _IglesiasListPageState createState() => _IglesiasListPageState();
}

class _IglesiasListPageState extends State<IglesiasListPage> {
  final MisIglesiaService _iglesiaService = MisIglesiaService(
    baseUrl: MainUtils.urlHostApi,
  );

  List<Iglesias> _iglesias = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarIglesias();
  }

  Future<void> _cargarIglesias() async {
    try {
      setState(() => _loading = true);
      if (widget.userRole == 1000) {
        _iglesias = await _iglesiaService.getIglesias(widget.token);
      } else {
        _iglesias = await _iglesiaService.getIglesiasUser(
            widget.token, localStorage.getItem('miIdUser').toString());
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _navegarACrearIglesia() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearIglesiaPage(
          token: widget.token,
          onIglesiaCreada: _cargarIglesias,
        ),
      ),
    );
  }

  void _navegarAEditarIglesia(Iglesias iglesia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarIglesiaPage(
          iglesia: iglesia,
          token: widget.token,
          onIglesiaActualizada: _cargarIglesias,
        ),
      ),
    );
  }

  Future<void> _eliminarIglesia(String id) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirmar eliminación',
          style: TextStyle(
            color: ColorsUtils.principalColor,
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar esta iglesia?',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
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
        await _iglesiaService.eliminarIglesia(id, widget.token);
        AppSnackbar.show(
          context,
          message: 'Iglesia eliminada correctamente',
          type: SnackbarType.success,
        );
        _cargarIglesias();
      } catch (e) {
        AppSnackbar.show(
          context,
          message: 'Error al eliminar: $e',
          type: SnackbarType.error,
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
          'Iglesias',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
        actions: [
          if (widget.userRole == 100)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _navegarACrearIglesia,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarIglesias,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _iglesias.isEmpty
                  ? const Center(child: Text('No hay iglesias registradas'))
                  : ListView.builder(
                      itemCount: _iglesias.length,
                      itemBuilder: (context, index) {
                        final iglesia = _iglesias[index];
                        return _IglesiaCard(
                          iglesia: iglesia,
                          userRole: widget.userRole,
                          onEdit: () => _navegarAEditarIglesia(iglesia),
                          onDelete: () =>
                              _eliminarIglesia(iglesia.idIglesia!.toString()),
                        );
                      },
                    ),
    );
  }
}

class _IglesiaCard extends StatelessWidget {
  final Iglesias iglesia;
  final int userRole;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _IglesiaCard({
    required this.iglesia,
    required this.userRole,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          iglesia.titulo ?? 'Sin nombre',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorsUtils.principalColor,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorsUtils.blancoColor,
                border: BoxBorder.all(
                  color: ColorsUtils.principalColor,
                  width: 2,
                ),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    "${MainUtils.urlHostAssetsImagen}/iglesias/iglesia_${iglesia.idIglesia}.png",
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
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (iglesia.direccion != null)
                    Text(
                      iglesia.direccion!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorsUtils.blancoColor,
                      ),
                    ),
                  if (iglesia.ciudad != null)
                    Text(
                        '${iglesia.ciudad!} ${iglesia.provincia != null ? '(${iglesia.provincia!})' : ''}'),
                  if (iglesia.telefono != null) Text('📞 ${iglesia.telefono!}'),
                  if (iglesia.email != null) Text('✉️ ${iglesia.email!}'),
                ],
              ),
            ),
          ],
        ),
        trailing: userRole == 100 ? _buildAdminActions() : null,
        onTap: () {
          // Navegar a detalles de la iglesia
        },
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
