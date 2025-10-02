import 'package:conexion_mas/controllers/MisUsuarioService.dart';
import 'package:conexion_mas/models/MisUsuarios.dart';

class UsuarioManager {
  final MisUsuarioService _usuarioService;
  List<MisUsuario> _usuarios = [];
  int? _idIglesiaFiltro;
  String _filtroBusqueda = '';
  String _filtroRol = 'Todos';

  List<MisUsuario> get usuarios => _getUsuariosFiltrados();
  bool _cargando = false;
  String? _error;

  bool get cargando => _cargando;
  String? get error => _error;

  // Callbacks para notificar cambios
  Function()? onUsuariosChanged;
  Function()? onLoadingChanged;
  Function(String?)? onErrorChanged;

  UsuarioManager({required MisUsuarioService usuarioService})
      : _usuarioService = usuarioService;

  List<MisUsuario> _getUsuariosFiltrados() {
    var filtered = _usuarios;

    // Filtrar por búsqueda
    if (_filtroBusqueda.isNotEmpty) {
      filtered = filtered
          .where((usuario) =>
              usuario.nombre!
                  .toLowerCase()
                  .contains(_filtroBusqueda.toLowerCase()) ||
              usuario.apellidos!
                  .toLowerCase()
                  .contains(_filtroBusqueda.toLowerCase()) ||
              usuario.email!
                  .toLowerCase()
                  .contains(_filtroBusqueda.toLowerCase()))
          .toList();
    }

    // Filtrar por rol
    if (_filtroRol != 'Todos') {
      filtered =
          filtered.where((usuario) => usuario.role == _filtroRol).toList();
    }

    return filtered;
  }

  void setFiltroBusqueda(String query) {
    _filtroBusqueda = query;
    onUsuariosChanged?.call();
  }

  void setFiltroRol(String rol) {
    _filtroRol = rol;
    onUsuariosChanged?.call();
  }

  void _setCargando(bool cargando) {
    _cargando = cargando;
    onLoadingChanged?.call();
  }

  void _setError(String? error) {
    _error = error;
    onErrorChanged?.call(error);
  }

  Future<void> cargarUsuariosPorIglesia(int idIglesia) async {
    if (_cargando) return;

    _setCargando(true);
    _setError(null);

    try {
      _idIglesiaFiltro = idIglesia;
      _usuarios = await _usuarioService.getUsuarios(idIglesia: idIglesia);
      onUsuariosChanged?.call();
    } catch (e) {
      _setError('Error al cargar usuarios: $e');
    } finally {
      _setCargando(false);
    }
  }

  Future<void> agregarUsuario(MisUsuario usuario) async {
    _setCargando(true);
    _setError(null);

    try {
      final nuevoUsuario = await _usuarioService.createUsuario(usuario);
      if (nuevoUsuario.idIglesia == _idIglesiaFiltro) {
        _usuarios.add(nuevoUsuario);
        onUsuariosChanged?.call();
      }
    } catch (e) {
      _setError('Error al agregar usuario: $e');
    } finally {
      _setCargando(false);
    }
  }

  Future<void> actualizarUsuario(MisUsuario usuario) async {
    _setCargando(true);
    _setError(null);

    try {
      final usuarioActualizado = await _usuarioService.updateUsuario(usuario);
      final index = _usuarios.indexWhere((u) => u.id == usuarioActualizado.id);
      if (index != -1) {
        _usuarios[index] = usuarioActualizado;
        onUsuariosChanged?.call();
      }
    } catch (e) {
      _setError('Error al actualizar usuario: $e');
    } finally {
      _setCargando(false);
    }
  }

  Future<void> eliminarUsuario(int id) async {
    _setCargando(true);
    _setError(null);

    try {
      final success = await _usuarioService.deleteUsuario(id);
      if (success) {
        _usuarios.removeWhere((usuario) => usuario.id == id);
        onUsuariosChanged?.call();
      } else {
        _setError('Error al eliminar usuario');
      }
    } catch (e) {
      _setError('Error al eliminar usuario: $e');
    } finally {
      _setCargando(false);
    }
  }

  void limpiarError() {
    _setError(null);
  }

  void limpiarFiltros() {
    _filtroBusqueda = '';
    _filtroRol = 'Todos';
    onUsuariosChanged?.call();
  }

  // Método para buscar usuarios localmente (sin API)
  void buscarLocalmente(String query) {
    setFiltroBusqueda(query);
  }

  // Método para filtrar por rol localmente
  void filtrarPorRolLocalmente(String rol) {
    setFiltroRol(rol);
  }

  // Obtener usuarios activos
  List<MisUsuario> get usuariosActivos {
    return _usuarios.where((usuario) => usuario.activo == 1).toList();
  }

  // Obtener usuarios por rol
  List<MisUsuario> usuariosPorRol(String rol) {
    return _usuarios.where((usuario) => usuario.role == rol).toList();
  }
}
