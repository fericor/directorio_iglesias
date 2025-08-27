import 'package:flutter/material.dart';

class PoliticasCheckboxValidado extends StatefulWidget {
  final bool esRequerido;
  final String? mensajeError;
  final String politicaPrivacidadUrl;
  final String terminosCondicionesUrl;

  const PoliticasCheckboxValidado({
    Key? key,
    this.esRequerido = true,
    this.mensajeError,
    required this.politicaPrivacidadUrl,
    required this.terminosCondicionesUrl,
  }) : super(key: key);

  @override
  _PoliticasCheckboxValidadoState createState() =>
      _PoliticasCheckboxValidadoState();
}

class _PoliticasCheckboxValidadoState extends State<PoliticasCheckboxValidado> {
  bool _aceptoPoliticas = false;
  bool _mostrarError = false;

  bool get isValid => !widget.esRequerido || _aceptoPoliticas;

  void validar() {
    setState(() {
      _mostrarError = !isValid;
    });
  }

  void reset() {
    setState(() {
      _aceptoPoliticas = false;
      _mostrarError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _aceptoPoliticas,
              onChanged: (bool? value) {
                setState(() {
                  _aceptoPoliticas = value ?? false;
                  _mostrarError = false;
                });
              },
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _aceptoPoliticas = !_aceptoPoliticas;
                    _mostrarError = false;
                  });
                },
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: _mostrarError ? Colors.red : null,
                    ),
                    children: [
                      const TextSpan(text: 'Acepto los '),
                      TextSpan(
                        text: 'términos y condiciones',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' y la '),
                      TextSpan(
                        text: 'política de privacidad',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_mostrarError)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              widget.mensajeError ??
                  'Debes aceptar las políticas para continuar',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
