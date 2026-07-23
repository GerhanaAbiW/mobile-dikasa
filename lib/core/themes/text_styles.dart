import 'package:flutter/material.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';

/// Kumpulan gaya teks aplikasi.
///
/// Sebelumnya setiap `TextStyle` ditulis ulang langsung di dalam widget.
/// Dipusatkan di sini agar perubahan desain cukup dilakukan satu kali dan
/// tidak ada nilai font yang berbeda-beda antar halaman.
class AppTextStyles {
  const AppTextStyles._();

  // =========================
  // Judul & Heading
  // =========================
  static TextStyle get heading => TextStyle(
    color: AppColors.c0F0F0F,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get sectionTitle => TextStyle(
    color: AppColors.c0F0F0F,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get formTitle => TextStyle(
    color: AppColors.c737373,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // =========================
  // Isi
  // =========================
  static TextStyle get body => TextStyle(
    color: AppColors.c0F0F0F,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get caption => TextStyle(
    color: AppColors.c737373,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  /// Angka besar pada kartu ringkasan dashboard.
  static TextStyle get metricValue => TextStyle(
    color: AppColors.c0F0F0F,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  // =========================
  // Input & Aksi
  // =========================
  static TextStyle get input => body;

  static TextStyle get inputHint => TextStyle(
    color: AppColors.c707070.withAlpha(128),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get error => TextStyle(
    color: AppColors.c9D1414,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}
