import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:conexion_mas/utils/mainUtils.dart';

class StripePaymentHandle {
  Map<String, dynamic>? paymentIntent;

  /// Inicia el flujo de pago y retorna true si fue exitoso
  Future<bool> stripeMakePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'EUR');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          billingDetails: BillingDetails(
            name: 'Felix cortez',
            email: 'fericor@gmail.com',
            phone: '633535178',
            address: Address(
              city: 'Madrid',
              country: 'España',
              line1: 'Calle de Ejemplo 1',
              line2: 'Apto. 2',
              postalCode: '28001',
              state: 'Madrid',
            ),
          ),
          paymentIntentClientSecret: paymentIntent!['clientSecret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Conexion +',
        ),
      );

      // Mostrar la hoja de pago y esperar confirmación
      await Stripe.instance.presentPaymentSheet();

      // ✅ Pago correcto
      return true;
    } catch (e) {
      // ❌ Error en el pago
      return false;
    }
  }

  /// Crea el PaymentIntent en el servidor
  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    final response = await http.post(
      Uri.parse('${MainUtils.urlHostApi}/createPaymentIntent'),
      body: {
        'amount': calculateAmount(amount),
        'currency': currency,
      },
    );
    return jsonDecode(response.body);
  }

  /// Registra la reserva en el backend
  Future<bool> reservarProducto(String productoId, String usuarioId) async {
    try {
      final response = await http.post(
        Uri.parse("${MainUtils.urlHostApi}/reservarProducto"),
        body: {
          "producto_id": productoId,
          "usuario_id": usuarioId,
          "monto": paymentIntent?['amount'] ?? "0",
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Convierte euros a céntimos
  String calculateAmount(String amount) {
    final calculatedAmount = ((double.parse(amount)) * 100).toStringAsFixed(0);
    return calculatedAmount;
  }
}
