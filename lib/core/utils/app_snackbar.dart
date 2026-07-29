import 'package:flutter/material.dart';

/// Menampilkan pesan singkat di bawah layar dengan durasi seragam.
void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1400),
    ),
  );
}
