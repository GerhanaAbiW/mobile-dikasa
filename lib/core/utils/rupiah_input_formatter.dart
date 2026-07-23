import 'package:flutter/services.dart';
import 'package:mobile_dikasa/core/utils/formatted_currency.dart';

/// Memformat isian menjadi rupiah utuh saat diketik, mis. 120000 -> "Rp. 120.000".
///
/// Hanya digit yang dipertahankan, lalu pemisah ribuan dihitung ulang setiap
/// ketikan. Karena tidak ada karakter sen (`,00`) yang ikut disimpan di dalam
/// teks, menambah atau menghapus satu angka selalu berubah tepat satu digit.
class RupiahInputFormatter extends TextInputFormatter {
  const RupiahInputFormatter({this.maxDigits = 12});

  /// Batas jumlah digit agar angka tidak melampaui kapasitas int.
  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue();
    }
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    final String formatted = formatRupiah(int.parse(digits));
    return TextEditingValue(
      text: formatted,
      // Kursor selalu di ujung, jadi ketikan berikutnya masuk sebagai digit
      // satuan dan backspace menghapus digit terakhir.
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
