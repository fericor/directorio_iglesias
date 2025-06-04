import 'package:directorio_iglesias/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  Stripe.publishableKey =
      "pk_test_51M1mbVLz5pi4nHAq8FwHX7s7EGQx7EjpQ5RkSHOmw4nncusTL125M2py3ix3vuWUzSZ1s342rP78jBM4DZlaS59M00c0yHCDOe";
  // Configuración para pantalla completa
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  /*await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/
  runApp(ChurchDirectoryApp());
}

class ChurchDirectoryApp extends StatelessWidget {
  const ChurchDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda Iglesia',
      theme: ThemeData(
          fontFamily: 'Josefin',
          primarySwatch: Colors.orange,
          brightness: Brightness.dark),
      home: SplashScreen(),
    );
  }
}
