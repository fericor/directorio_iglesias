import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationSearchDialog extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationSearchDialog({Key? key, this.initialLocation})
      : super(key: key);

  @override
  _LocationSearchDialogState createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<LocationSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  LatLng? _selectedLocation;
  List<NominatimResult> _searchResults = [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _latController.text = widget.initialLocation!.latitude.toStringAsFixed(6);
      _lngController.text =
          widget.initialLocation!.longitude.toStringAsFixed(6);
    }
  }

  Future<void> _searchAddress() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _searching = true);

    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/search?format=json&q=$query&limit=5'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _searchResults =
              data.map((item) => NominatimResult.fromJson(item)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la búsqueda: $e')),
      );
    } finally {
      setState(() => _searching = false);
    }
  }

  void _selectSearchResult(NominatimResult result) {
    setState(() {
      _selectedLocation =
          LatLng(double.parse(result.lat), double.parse(result.lon));
      _latController.text = result.lat;
      _lngController.text = result.lon;
      _searchResults.clear();
    });
  }

  void _useManualCoordinates() {
    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);

    if (lat != null && lng != null) {
      setState(() {
        _selectedLocation = LatLng(lat, lng);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Buscar ubicación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Búsqueda por dirección
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por dirección',
                suffixIcon: IconButton(
                  icon: _searching
                      ? const CircularProgressIndicator(value: 16)
                      : const Icon(Icons.search),
                  onPressed: _searchAddress,
                ),
              ),
              onSubmitted: (_) => _searchAddress,
            ),
            const SizedBox(height: 8),

            // Resultados de búsqueda
            if (_searchResults.isNotEmpty)
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return ListTile(
                      title: Text(result.displayName),
                      onTap: () => _selectSearchResult(result),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            // Coordenadas manuales
            const Text(
              'O ingresar coordenadas manualmente:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latController,
                    decoration: const InputDecoration(
                      labelText: 'Latitud',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _lngController,
                    decoration: const InputDecoration(
                      labelText: 'Longitud',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedLocation != null
                      ? () => Navigator.pop(context, _selectedLocation)
                      : null,
                  child: const Text('Seleccionar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NominatimResult {
  final String displayName;
  final String lat;
  final String lon;

  NominatimResult({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory NominatimResult.fromJson(Map<String, dynamic> json) {
    return NominatimResult(
      displayName: json['display_name'] ?? '',
      lat: json['lat'] ?? '0',
      lon: json['lon'] ?? '0',
    );
  }
}
