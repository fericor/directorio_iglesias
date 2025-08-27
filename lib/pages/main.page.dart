import 'package:conexion_mas/screens/ChurchMapScreen.dart';
import 'package:conexion_mas/screens/EventosScreen.dart';
import 'package:conexion_mas/screens/LoginScreen.dart';
import 'package:conexion_mas/screens/MisReservasScreen.dart';
import 'package:conexion_mas/screens/PerfilUsuarioScreen.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  _MainPageViewState createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool is_Login = false;
  String idUser = "0";

  @override
  void initState() {
    super.initState();

    isLogin();
  }

  Future<void> isLogin() async {
    await initLocalStorage();

    setState(() {
      is_Login = localStorage.getItem('isLogin') == 'true';
      idUser = localStorage.getItem('miIdUser').toString();
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Bloquea el botón de retroceso
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                EventosScreen(), // SeatsScreen()
                ChurchMapScreen(),
                is_Login
                    ? MisreservasScreen()
                    : LoginScreen(controller: _pageController),
                is_Login
                    ? PerfilUsuarioScreen()
                    : LoginScreen(controller: _pageController),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: frcaWidget.frca_main_menu(
                  _goToPage, _currentPage, is_Login, idUser),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
