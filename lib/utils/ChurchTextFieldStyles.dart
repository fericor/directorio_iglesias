import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';

class ChurchTextFieldStyles {
  // Estilo específico para app de iglesias
  static InputDecoration churchTextField({
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: ColorsUtils.terceroColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: ColorsUtils.terceroColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.purple.shade600, width: 2),
      ),
      filled: true,
      fillColor: ColorsUtils.terceroColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      labelStyle: TextStyle(
        color: ColorsUtils.blancoColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        color: ColorsUtils.blancoColor,
        fontSize: 14,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  // Estilo para búsqueda de iglesias
  static InputDecoration churchSearchField({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(Icons.search, color: ColorsUtils.blancoColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.purple.shade600, width: 2),
      ),
      filled: true,
      fillColor: ColorsUtils.fondoColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      hintStyle: TextStyle(
        color: ColorsUtils.negroColor,
        fontSize: 16,
      ),
    );
  }
}
