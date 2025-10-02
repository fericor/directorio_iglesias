import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MainUtils {
  static final urlHostApi = "https://api.conexion-mas.com";
  static final urlHostAssets = "https://api.conexion-mas.com/assets_app";
  static final urlHostAssetsImagen = "https://api.conexion-mas.com/imagen";

  // static final urlHostApi = "http://conexion_mas.local";
  // static final urlHostAssets = "http://conexion_mas.local/assets_app";
  // static final urlHostAssetsImagen = "http://conexion_mas.local/imagen";

  Future<void> openMap(lat, long) async {
    try {
      await launchUrlString(
          'https://www.google.com/maps/search/?api=1&query=$lat,$long',
          mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("🚀 catched error~ $e:");
    }
  }

  Future<void> calTelOld(telefono) async {
    print(telefono);
    try {
      canLaunchUrl(Uri(scheme: 'tel', path: telefono)).then((bool result) {});
    } catch (e) {
      debugPrint("🚀 catched error~ $e:");
    }
  }

  Future<void> calTel(String telefono) async {
    final Uri uri = Uri(scheme: 'tel', path: telefono);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // <- importante
        );
      } else {
        debugPrint("🚨 No se puede lanzar la llamada a $telefono");
      }
    } catch (e) {
      debugPrint("🚀 Error atrapado: $e");
    }
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<double> calculateDistanceUsingGeolocator(double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) async {
    double distancia = Geolocator.distanceBetween(
          startLatitude,
          startLongitude,
          endLatitude,
          endLongitude,
        ) /
        1000; // Convertir de metros a kilómetros
    return distancia;
  }

  // Transformar "2025-12-30" a "30/12/2025"
  String formatFecha(String fecha) {
    try {
      DateTime date = DateTime.parse(fecha);
      return "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";
    } catch (e) {
      return fecha; // En caso de error devuelve el string original
    }
  }

// Transformar "10:00:00" a "10:00"
  String formatHora(String hora) {
    try {
      List<String> partes = hora.split(":");
      if (partes.length >= 2) {
        return "${partes[0]}:${partes[1]}";
      }
      return hora;
    } catch (e) {
      return hora;
    }
  }
}
