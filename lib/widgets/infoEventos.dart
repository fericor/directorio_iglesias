import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoButtons extends StatelessWidget {
  final String jsonString;

  const InfoButtons({super.key, required this.jsonString});

  // Detectar acción según el tipo de dato
  void _handleTap(String key, String value) async {
    if (key.toLowerCase().contains("telefono")) {
      final Uri telUri = Uri(scheme: 'tel', path: value);
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      }
    } else if (key.toLowerCase().contains("web") ||
        value.startsWith("http") ||
        value.startsWith("www")) {
      final Uri url = Uri.parse(value);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else if (key.toLowerCase().contains("direccion")) {
      final Uri mapsUri =
          Uri.parse("https://www.google.com/maps/search/?api=1&query=$value");
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  IconData _getIcon(String key) {
    if (key.toLowerCase().contains("telefono")) return Icons.phone;
    if (key.toLowerCase().contains("web")) return Icons.public;
    if (key.toLowerCase().contains("direccion")) return Icons.location_on;
    return Icons.info; // Por defecto
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = json.decode(jsonString);

    return Wrap(
      spacing: 10,
      runSpacing: 1,
      children: data.entries.map((entry) {
        final key = entry.key;
        final value = entry.value.toString();

        return ElevatedButton.icon(
          onPressed: () => _handleTap(key, value),
          icon: Icon(_getIcon(key)),
          label: Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }).toList(),
    );
  }
}
