import 'package:conexion_mas/controllers/notifications_service.dart';
import 'package:conexion_mas/screens/SplashScreen.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  Stripe.publishableKey =
      "pk_live_51RyDhkBoePltu1kjNepmIIjTBlM3P9itXT0dOZHDvh8vWNFzLBvHHdCLRZ3liWpMyhfUyZp2go3nCaEMbpG50EIE008X7o4nLr";

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupPushNotifications();
  runApp(ChurchDirectoryApp());
}

class ChurchDirectoryApp extends StatelessWidget {
  const ChurchDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conexión +',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: MaterialColor(
          0xFF110c19,
          <int, Color>{
            50: Color(0xFFF3E5F5),
            100: Color(0xFFE1BEE7),
            200: Color(0xFFCE93D8),
            300: Color(0xFFBA68C8),
            400: Color(0xFFAB47BC),
            500: Color(0xFF9C27B0),
            600: Color(0xFF8E24AA),
            700: Color(0xFF7B1FA2),
            800: Color(0xFF6A1B9A),
            900: Color(0xFF4A148C),
          },
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ColorsUtils.fondoColor,
        appBarTheme: AppBarTheme(
          backgroundColor: ColorsUtils.fondoColor,
          foregroundColor: ColorsUtils.fondoColor,
          iconTheme: IconThemeData(color: ColorsUtils.blancoColor),
          actionsIconTheme: IconThemeData(color: ColorsUtils.blancoColor),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
