import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_dikasa/core/utils/rupiah_input_formatter.dart';

void main() {
  const RupiahInputFormatter formatter = RupiahInputFormatter();

  /// Meniru satu ketikan: teks lama diganti [newText] dengan kursor di ujung,
  /// lalu dijalankan lewat formatter seperti yang terjadi di TextField asli.
  TextEditingValue type(TextEditingValue previous, String newText) {
    return formatter.formatEditUpdate(
      previous,
      TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      ),
    );
  }

  test('mengetik angka menambah tepat satu digit', () {
    TextEditingValue value = const TextEditingValue();

    value = type(value, '${value.text}1');
    expect(value.text, 'Rp. 1');

    value = type(value, '${value.text}2');
    expect(value.text, 'Rp. 12');

    value = type(value, '${value.text}0');
    expect(value.text, 'Rp. 120');

    value = type(value, '${value.text}0');
    expect(value.text, 'Rp. 1.200');
  });

  test('mengetik nol tidak menggandakan digit (regresi bug Kas Awal)', () {
    TextEditingValue value = type(const TextEditingValue(), '5');
    expect(value.text, 'Rp. 5');

    value = type(value, '${value.text}0');
    expect(value.text, 'Rp. 50');

    value = type(value, '${value.text}0');
    expect(value.text, 'Rp. 500');
  });

  test('backspace menghapus tepat satu digit, bukan menambah', () {
    TextEditingValue value = type(const TextEditingValue(), '500');
    expect(value.text, 'Rp. 500');

    // Backspace membuang karakter terakhir dari teks.
    value = type(value, value.text.substring(0, value.text.length - 1));
    expect(value.text, 'Rp. 50');

    value = type(value, value.text.substring(0, value.text.length - 1));
    expect(value.text, 'Rp. 5');
  });

  test('kolom dikosongkan saat semua digit dihapus', () {
    final TextEditingValue value = type(const TextEditingValue(), 'Rp. ');
    expect(value.text, isEmpty);
  });

  test('kursor selalu berada di ujung teks', () {
    final TextEditingValue value = type(const TextEditingValue(), '12000');
    expect(value.text, 'Rp. 12.000');
    expect(value.selection.baseOffset, value.text.length);
  });

  test('membatasi jumlah digit agar tidak melampaui kapasitas int', () {
    final TextEditingValue value = type(
      const TextEditingValue(),
      '99999999999999999999',
    );
    final String digitsOnly = value.text.replaceAll(RegExp(r'[^0-9]'), '');
    expect(digitsOnly.length, lessThanOrEqualTo(12));
  });
}
