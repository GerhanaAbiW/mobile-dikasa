import 'package:flutter/material.dart';

Color hexToArgb(String hex) {
  final cleanedHex = hex.replaceAll('#', '').toUpperCase();

  if (cleanedHex.length == 6) {
    return Color(int.parse('FF$cleanedHex', radix: 16));
  }

  if (cleanedHex.length == 8) {
    return Color(int.parse(cleanedHex, radix: 16));
  }

  throw FormatException("Invalid HEX color format");
}