import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MainUtils {
  static final urlHostApi = "https://tdv.api.vallmarketing.es";
  static final urlHostAssets = "https://vallmarketing.es/app_assets";

  Future<void> openMap(lat, long) async {
    try {
      await launchUrlString(
          'https://www.google.com/maps/search/?api=1&query=$lat,$long',
          mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("🚀 catched error~ $e:");
    }
  }

  Future<void> calTel(telefono) async {
    try {
      canLaunchUrl(Uri(scheme: 'tel', path: telefono)).then((bool result) {});
    } catch (e) {
      debugPrint("🚀 catched error~ $e:");
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
}
