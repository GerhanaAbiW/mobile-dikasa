/// Memformat nominal rupiah mengikuti penulisan pada desain Figma.
///
/// Desain memakai dua gaya penulisan:
/// - kartu produk        : `Rp. 21.000`      -> formatRupiah(21000)
/// - baris & total order : `Rp 210.000,00`   -> formatRupiah(210000, showCents: true, prefix: 'Rp ')
///
/// Ditulis manual (tanpa package `intl`) karena kebutuhannya masih sebatas
/// pemisah ribuan untuk satu mata uang.
String formatRupiah(
  int amount, {
  String prefix = 'Rp. ',
  bool showCents = false,
}) {
  final bool isNegative = amount < 0;
  final String digits = amount.abs().toString();

  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    // Sisipkan titik setiap kelipatan 3 digit dihitung dari belakang.
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }

  // Harga disimpan dalam rupiah utuh, sehingga sen selalu nol.
  final String cents = showCents ? ',00' : '';

  return '${isNegative ? '-' : ''}$prefix$buffer$cents';
}
