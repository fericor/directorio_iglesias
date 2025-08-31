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
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
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
