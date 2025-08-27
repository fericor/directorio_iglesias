import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliticasCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final String politicaPrivacidadUrl;
  final String terminosCondicionesUrl;

  const PoliticasCheckbox({
    Key? key,
    required this.onChanged,
    required this.politicaPrivacidadUrl,
    required this.terminosCondicionesUrl,
  }) : super(key: key);

  @override
  _PoliticasCheckboxState createState() => _PoliticasCheckboxState();
}

class _PoliticasCheckboxState extends State<PoliticasCheckbox> {
  bool _aceptoPoliticas = false;
  final TapGestureRecognizer _terminosRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _politicaRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _terminosRecognizer.onTap = () => _abrirUrl(widget.terminosCondicionesUrl);
    _politicaRecognizer.onTap = () => _abrirUrl(widget.politicaPrivacidadUrl);
  }

  @override
  void dispose() {
    _terminosRecognizer.dispose();
    _politicaRecognizer.dispose();
    super.dispose();
  }

  Future<void> _abrirUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('No se pudo abrir la URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _aceptoPoliticas,
          onChanged: (bool? value) {
            setState(() {
              _aceptoPoliticas = value ?? false;
            });
            widget.onChanged(_aceptoPoliticas);
          },
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: ColorsUtils.negroColor,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                    text: 'Acepto los ',
                    style: TextStyle(
                      color: ColorsUtils.negroColor,
                    )),
                TextSpan(
                  text: 'términos y condiciones',
                  style: TextStyle(
                    color: ColorsUtils.principalColor,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: _terminosRecognizer,
                ),
                const TextSpan(text: ' y la '),
                TextSpan(
                  text: 'política de privacidad',
                  style: TextStyle(
                    color: ColorsUtils.principalColor,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: _politicaRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
