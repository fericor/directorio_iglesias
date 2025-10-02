import 'dart:async';

import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/widgets/LocationSearchDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapLocationSelector extends StatefulWidget {
  final double? initialLatitud;
  final double? initialLongitud;
  final ValueChanged<LatLng> onLocationSelected;
  final String? labelText;

  const MapLocationSelector({
    Key? key,
    this.initialLatitud,
    this.initialLongitud,
    required this.onLocationSelected,
    this.labelText = 'Seleccionar ubicación',
  }) : super(key: key);

  @override
  _MapLocationSelectorState createState() => _MapLocationSelectorState();
}

class _MapLocationSelectorState extends State<MapLocationSelector> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  bool _loading = false;
  String _error = '';
  double _zoomLevel = 13.0;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() {
    if (widget.initialLatitud != null && widget.initialLongitud != null) {
      _selectedLocation =
          LatLng(widget.initialLatitud!, widget.initialLongitud!);
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _loading = true;
      _error = "";
    });

    try {
      // 1. Verificar si los servicios de ubicación están activados
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loading = false);
        _showLocationServiceDisabledDialog();
        return;
      }

      // 2. Verificar y solicitar permisos
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        setState(() => _loading = false);
        _showPermissionPermanentlyDeniedDialog();
        return;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          setState(() => _loading = false);
          _showPermissionDeniedDialog();
          return;
        }
      }

      // 3. Obtener la ubicación actual
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );

      // 4. Actualizar el estado con la nueva ubicación
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        if (_selectedLocation == null) {
          _selectedLocation = _currentLocation;
          widget.onLocationSelected(_selectedLocation!);
        }
        _loading = false;
      });

      // 5. Mover el mapa a la ubicación actual si está listo
      if (_mapReady) {
        _mapController.move(_currentLocation!, _zoomLevel);
      }
    } on LocationServiceDisabledException {
      setState(() => _loading = false);
      _showLocationServiceDisabledDialog();
    } on TimeoutException {
      setState(() {
        _error = 'Tiempo de espera agotado. Intente nuevamente.';
        _loading = false;
      });
      _showLocationErrorDialog('No se pudo obtener la ubicación a tiempo. '
          'Por favor, verifique su conexión y GPS.');
    } catch (e) {
      setState(() {
        _error = 'Error al obtener ubicación: ${e.toString()}';
        _loading = false;
      });
      _showLocationErrorDialog('Ocurrió un error inesperado: ${e.toString()}');
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    widget.onLocationSelected(location);
  }

  void _centerOnCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, _zoomLevel);
    }
  }

  Future<void> _searchLocation() async {
    final result = await showDialog<LatLng>(
      context: context,
      builder: (context) => LocationSearchDialog(
        initialLocation: _selectedLocation,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
      widget.onLocationSelected(result);
      _mapController.move(result, _zoomLevel);
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel += 1;
    });
    _mapController.move(_mapController.camera.center, _zoomLevel);
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = _zoomLevel > 1 ? _zoomLevel - 1 : 1;
    });
    _mapController.move(_mapController.camera.center, _zoomLevel);
  }

  void _showLocationServiceDisabledDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Servicios de ubicación desactivados',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              'Los servicios de ubicación de su dispositivo están desactivados. '
              'Por favor, active el GPS para utilizar esta función.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Abrir configuración de ubicación
                Geolocator.openLocationSettings();
              },
              child: Text('Activar GPS', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permisos denegados permanentemente',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              'Ha denegado los permisos de ubicación permanentemente. '
              'Debe habilitarlos manualmente en la configuración de la aplicación.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Abrir configuración de la app
                Geolocator.openAppSettings();
              },
              child: Text('Abrir configuración',
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permisos de ubicación requeridos',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Esta aplicación necesita acceso a su ubicación '
              'para mostrar su posición en el mapa.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Entendido', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showLocationErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de ubicación',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ColorsUtils.blancoColor,
          ),
        ),
        const SizedBox(height: 12),

        if (_error.isNotEmpty)
          Text(
            _error,
            style: const TextStyle(color: Colors.red),
          ),

        if (_loading)
          const Center(child: CircularProgressIndicator())
        else
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      _selectedLocation ?? const LatLng(40.4168, -3.7038),
                  initialZoom: _zoomLevel,
                  onTap: _onMapTap,
                ),
                children: [
                  // Capa de tiles (OpenStreetMap)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.fericor.conexionmas',
                  ),

                  // Marcadores
                  MarkerLayer(
                    markers: [
                      if (_selectedLocation != null)
                        Marker(
                          point: _selectedLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      if (_currentLocation != null)
                        Marker(
                          point: _currentLocation!,
                          width: 30,
                          height: 30,
                          child: const Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 12),

        // Coordenadas seleccionadas
        /* if (_selectedLocation != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Coordenadas seleccionadas:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Latitud: ${_selectedLocation!.latitude.toStringAsFixed(6)}'),
                  Text(
                      'Longitud: ${_selectedLocation!.longitude.toStringAsFixed(6)}'),
                ],
              ),
            ),
          ),*/

        // Botones de acción
        Wrap(
          spacing: 10,
          runSpacing: 1,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorsUtils.terceroColor, // Color de fondo
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
              ),
              child: IconButton(
                onPressed:
                    _centerOnCurrentLocation, // Required - Función al presionar
                icon: Icon(Icons.my_location), // Required - Icono a mostrar
                iconSize: 30.0, // Tamaño del icono
                color: ColorsUtils.blancoColor, // Color del icono
                splashColor: ColorsUtils.negroColor, // Color del efecto splash
                highlightColor: ColorsUtils.principalColor
                    .withOpacity(0.1), // Color de highlight
                padding: EdgeInsets.all(8.0), // Padding interno
                constraints: BoxConstraints(), // Restricciones de tamaño
                tooltip: 'Mi ubicación', // Texto al hacer hover/largo press
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsUtils.terceroColor, // Color de fondo
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
              ),
              child: IconButton(
                onPressed: _searchLocation, // Required - Función al presionar
                icon: Icon(Icons.search), // Required - Icono a mostrar
                iconSize: 30.0, // Tamaño del icono
                color: ColorsUtils.blancoColor, // Color del icono
                splashColor: ColorsUtils.negroColor, // Color del efecto splash
                highlightColor: ColorsUtils.principalColor
                    .withOpacity(0.1), // Color de highlight
                padding: EdgeInsets.all(8.0), // Padding interno
                constraints: BoxConstraints(), // Restricciones de tamaño
                tooltip: 'Buscar', // Texto al hacer hover/largo press
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsUtils.terceroColor, // Color de fondo
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
              ),
              child: IconButton(
                onPressed: _zoomIn, // Required - Función al presionar
                icon: Icon(Icons.zoom_in), // Required - Icono a mostrar
                iconSize: 30.0, // Tamaño del icono
                color: ColorsUtils.blancoColor, // Color del icono
                splashColor: ColorsUtils.negroColor, // Color del efecto splash
                highlightColor: ColorsUtils.principalColor
                    .withOpacity(0.1), // Color de highlight
                padding: EdgeInsets.all(8.0), // Padding interno
                constraints: BoxConstraints(), // Restricciones de tamaño
                tooltip: 'Zoom +', // Texto al hacer hover/largo press
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsUtils.terceroColor, // Color de fondo
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
              ),
              child: IconButton(
                onPressed: _zoomOut, // Required - Función al presionar
                icon: Icon(Icons.zoom_out), // Required - Icono a mostrar
                iconSize: 30.0, // Tamaño del icono
                color: ColorsUtils.blancoColor, // Color del icono
                splashColor: ColorsUtils.negroColor, // Color del efecto splash
                highlightColor: ColorsUtils.principalColor
                    .withOpacity(0.1), // Color de highlight
                padding: EdgeInsets.all(8.0), // Padding interno
                constraints: BoxConstraints(), // Restricciones de tamaño
                tooltip: 'Zoom -', // Texto al hacer hover/largo press
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsUtils.principalColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              icon: Icon(
                Icons.refresh,
                size: 30,
                color: ColorsUtils.blancoColor,
              ),
              label: Text(
                'Actualizar',
                style: TextStyle(color: ColorsUtils.blancoColor),
              ),
              onPressed: _getCurrentLocation,
            ),
          ],
        ),
      ],
    );
  }
}
