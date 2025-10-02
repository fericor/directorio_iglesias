// screens/lista_usuarios_screen.dart
import 'package:conexion_mas/controllers/MisUsuarioService.dart';
import 'package:conexion_mas/models/MisUsuarios.dart';
import 'package:conexion_mas/pages/usuarios/formulario_usuario_screen.dart';
import 'package:conexion_mas/pages/usuarios/usuario_manager.dart';
import 'package:conexion_mas/utils/ChurchTextFieldStyles.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ListaUsuariosScreen extends StatefulWidget {
  final int idIglesia;
  final UsuarioManager usuarioManager;

  const ListaUsuariosScreen({
    super.key,
    required this.idIglesia,
    required this.usuarioManager,
  });

  @override
  _ListaUsuariosScreenState createState() => _ListaUsuariosScreenState();
}

class _ListaUsuariosScreenState extends State<ListaUsuariosScreen> {
  final MisUsuarioService usuarioService = MisUsuarioService(
    MainUtils.urlHostApi,
    token: localStorage.getItem('miToken').toString(),
  );

  final _searchController = TextEditingController();
  String _selectedRole = 'Todos';

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();

    // Escuchar cambios en el manager
    widget.usuarioManager.onUsuariosChanged = _onUsuariosChanged;
    widget.usuarioManager.onLoadingChanged = _onLoadingChanged;
    widget.usuarioManager.onErrorChanged = _onErrorChanged;
  }

  @override
  void dispose() {
    _searchController.dispose();
    widget.usuarioManager.onUsuariosChanged = null;
    widget.usuarioManager.onLoadingChanged = null;
    widget.usuarioManager.onErrorChanged = null;
    super.dispose();
  }

  void _onUsuariosChanged() {
    setState(() {});
  }

  void _onLoadingChanged() {
    setState(() {});
  }

  void _onErrorChanged(String? error) {
    if (error != null) {
      _mostrarError(error);
    }
  }

  Future<void> _cargarUsuarios() async {
    await widget.usuarioManager.cargarUsuariosPorIglesia(widget.idIglesia);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _filtrarUsuarios(String query) {
    widget.usuarioManager.buscarLocalmente(query);
  }

  void _filtrarPorRol(String? rol) {
    setState(() {
      _selectedRole = rol ?? 'Todos';
    });
    widget.usuarioManager.filtrarPorRolLocalmente(_selectedRole);
  }

  void _navegarAFormularioUsuario(MisUsuario? usuario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioUsuarioScreen(
          idIglesia: widget.idIglesia,
          usuario: usuario,
          usuarioManager: widget.usuarioManager,
        ),
      ),
    );
  }

  void _mostrarDialogoEliminar(MisUsuario usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro de que quieres eliminar a ${usuario.nombre} ${usuario.apellidos}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await widget.usuarioManager.eliminarUsuario(usuario.id!);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _mostrarOpcionesUsuario(MisUsuario usuario) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar usuario'),
            onTap: () {
              Navigator.pop(context);
              _navegarAFormularioUsuario(usuario);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _mostrarDialogoEliminar(usuario);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUsuarioCard(MisUsuario usuario) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: usuario.activo == 1 ? Colors.green : Colors.grey,
          child: Text(
            usuario.nombre![0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text('${usuario.nombre} ${usuario.apellidos}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(usuario.email!),
            Text('Rol: ${usuario.role}'),
            Text(usuario.activo == 1 ? 'Activo' : 'Inactivo'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _mostrarOpcionesUsuario(usuario),
        ),
        onTap: () => _mostrarOpcionesUsuario(usuario),
      ),
    );
  }

  Widget _buildListaUsuarios() {
    final usuarios = widget.usuarioManager.usuarios;

    if (widget.usuarioManager.cargando && usuarios.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (usuarios.isEmpty) {
      return const Center(
        child: Text('No hay usuarios registrados'),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarUsuarios,
      child: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return _buildUsuarioCard(usuario);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.fondoColor,
        title: Text(
          'Gestión de Usuarios',
          style: TextStyle(
            color: ColorsUtils.blancoColor,
          ),
        ),
        actions: [
          if (widget.usuarioManager.cargando)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _cargarUsuarios,
            ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorsUtils.principalColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: ColorsUtils.blancoColor,
                    ),
                    decoration: ChurchTextFieldStyles.churchTextField(
                      hintText: '',
                      prefixIcon: const Icon(Icons.search),
                      labelText: 'Buscar usuarios',
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filtrarUsuarios('');
                              },
                            )
                          : null,
                    ),
                    onChanged: _filtrarUsuarios,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: [
                      'Todos',
                      'admin',
                      'pastor',
                      'lider',
                      'miembro',
                      'visitante'
                    ]
                        .map((rol) => DropdownMenuItem(
                              value: rol,
                              child:
                                  Text(rol[0].toUpperCase() + rol.substring(1)),
                            ))
                        .toList(),
                    onChanged: _filtrarPorRol,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      fillColor: ColorsUtils.terceroColor,
                      hintText: 'Sociedad',
                      hintStyle: TextStyle(color: ColorsUtils.blancoColor),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildListaUsuarios(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarAFormularioUsuario(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
