import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliticasFormField extends FormField<bool> {
  PoliticasFormField({
    Key? key,
    required String politicaPrivacidadUrl,
    required String terminosCondicionesUrl,
    String? mensajeError,
    bool inicialmenteAceptado = false,
  }) : super(
          key: key,
          initialValue: inicialmenteAceptado,
          validator: (value) {
            if (value == null || !value) {
              return mensajeError ??
                  'Debes aceptar las políticas para continuar';
            }
            return null;
          },
          builder: (FormFieldState<bool> field) {
            final TapGestureRecognizer terminosRecognizer =
                TapGestureRecognizer()
                  ..onTap = () => _abrirUrl(terminosCondicionesUrl);

            final TapGestureRecognizer politicaRecognizer =
                TapGestureRecognizer()
                  ..onTap = () => _abrirUrl(politicaPrivacidadUrl);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: field.value ?? false,
                      onChanged: (bool? value) {
                        field.didChange(value);
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: field.hasError
                                ? ColorsUtils.rojoColor
                                : ColorsUtils.negroColor,
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
                              recognizer: terminosRecognizer,
                            ),
                            TextSpan(
                              text: ' y la ',
                              style: TextStyle(
                                color: ColorsUtils.negroColor,
                              ),
                            ),
                            TextSpan(
                              text: 'política de privacidad',
                              style: TextStyle(
                                color: ColorsUtils.principalColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: politicaRecognizer,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        color: ColorsUtils.rojoColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );

  static Future<void> _abrirUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('No se pudo abrir la URL: $url');
    }
  }
}
