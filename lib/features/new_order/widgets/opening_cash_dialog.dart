import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';
import 'package:mobile_dikasa/core/themes/text_styles.dart';
import 'package:mobile_dikasa/core/utils/formatted_currency.dart';
import 'package:mobile_dikasa/core/utils/rupiah_input_formatter.dart';

/// Dialog "Kas Awal" yang muncul saat kasir membuka halaman Order.
///
/// Mengembalikan nominal kas yang diisi, atau `null` bila kasir memilih
/// "Lewati" maupun menutup dialog.
class OpeningCashDialog extends StatefulWidget {
  const OpeningCashDialog({super.key});

  /// Menampilkan dialog dan menunggu jawaban kasir.
  static Future<int?> show(BuildContext context) {
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.c0F0F0F.withAlpha(90),
      builder: (_) => const OpeningCashDialog(),
    );
  }

  @override
  State<OpeningCashDialog> createState() => _OpeningCashDialogState();
}

class _OpeningCashDialogState extends State<OpeningCashDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Membaca angka yang diketik, mengabaikan titik pemisah ribuan.
  int? get _amount {
    final String digits = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? null : int.parse(digits);
  }

  void _submit() => Navigator.of(context).pop(_amount);

  void _skip() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cFFFFFF,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _DialogHeader(onClose: _skip),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 26, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _AmountField(controller: _controller, onSubmitted: _submit),
                  const SizedBox(height: 14),
                  Text(
                    '**Uang Kas yang dipegang kasir sebagai modal kembalian',
                    style: AppTextStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: _skip,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.c097BC2,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          minimumSize: const Size(0, 52),
                          textStyle: AppTextStyles.button.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Lewati'),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 52,
                        width: 196,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cFF8227,
                            foregroundColor: AppColors.cFFFFFF,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: AppTextStyles.button.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('Masuk'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.c367AA0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 16, 16, 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Kas Awal',
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.cFFFFFF,
                  fontSize: 21,
                ),
              ),
            ),
            IconButton(
              onPressed: onClose,
              tooltip: 'Tutup',
              icon: Icon(
                Icons.cancel_outlined,
                color: AppColors.cFFFFFF,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.number,
      inputFormatters: const <TextInputFormatter>[RupiahInputFormatter()],
      onSubmitted: (_) => onSubmitted(),
      style: AppTextStyles.body.copyWith(fontSize: 18),
      decoration: InputDecoration(
        hintText: formatRupiah(0),
        hintStyle: AppTextStyles.body.copyWith(
          fontSize: 18,
          color: AppColors.cA4A4A4,
        ),
        filled: true,
        fillColor: AppColors.cFFFFFF,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: _border(AppColors.cD1D1D1),
        focusedBorder: _border(AppColors.c097BC2),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color),
  );
}
