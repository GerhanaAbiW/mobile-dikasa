import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';
import 'package:mobile_dikasa/core/themes/text_styles.dart';

/// Dropdown putih bersudut membulat yang dipakai pada kedua panel biru
/// halaman Order ("Filter Kategori" dan "Pilih Jenis Order").
///
/// Berubah menjadi biru begitu sebuah pilihan aktif, mengikuti desain.
class PanelDropdown<T> extends StatelessWidget {
  const PanelDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.optionLabel,
    required this.onSelected,
    this.isActive = false,
  });

  /// Teks yang ditampilkan saat ini.
  final String label;

  final List<T> options;

  /// Cara mengubah satu pilihan menjadi teks.
  final String Function(T option) optionLabel;

  final ValueChanged<T> onSelected;

  /// True bila sudah ada pilihan yang dipakai, memicu tampilan biru.
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color background = isActive ? AppColors.c529DC8 : AppColors.cFFFFFF;
    final Color foreground = isActive ? AppColors.cFFFFFF : AppColors.c656565;

    return PopupMenuButton<T>(
      onSelected: onSelected,
      tooltip: label,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 6),
      constraints: const BoxConstraints(minWidth: 220),
      itemBuilder: (BuildContext context) => options
          .map(
            (T option) => PopupMenuItem<T>(
              value: option,
              child: Text(optionLabel(option), style: AppTextStyles.body),
            ),
          )
          .toList(),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: foreground,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/arrow_down_icon.svg',
              width: 15,
              height: 15,
              colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
