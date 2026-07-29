import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';
import 'package:mobile_dikasa/core/themes/text_styles.dart';
import 'package:mobile_dikasa/core/utils/app_snackbar.dart';
import 'package:mobile_dikasa/data/models/user.dart';

/// Baris teratas halaman Order: menu, peralihan Transaksi/Notifikasi,
/// tombol kunci layar, dan identitas outlet beserta kasir yang bertugas.
class OrderTopBar extends StatelessWidget implements PreferredSizeWidget {
  const OrderTopBar({
    super.key,
    required this.user,
    required this.onMenuPressed,
    required this.onLockPressed,
  });

  static const double height = 88;

  final User? user;
  final VoidCallback onMenuPressed;
  final VoidCallback onLockPressed;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cFFFFFF,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: <Widget>[
              _IconAction(
                assetPath: 'assets/icons/menu_icon.svg',
                size: 30,
                tooltip: 'Buka menu',
                onPressed: onMenuPressed,
              ),
              const SizedBox(width: 36),
              const _SectionSwitch(),
              const Spacer(),
              _IconAction(
                assetPath: 'assets/icons/lock_circle_icon.svg',
                size: 52,
                tooltip: 'Kunci layar',
                onPressed: onLockPressed,
              ),
              const Spacer(),
              _OutletIdentity(user: user),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.assetPath,
    required this.size,
    required this.tooltip,
    required this.onPressed,
  });

  final String assetPath;
  final double size;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: SvgPicture.asset(assetPath, width: size, height: size),
    );
  }
}

/// Peralihan antara daftar transaksi dan notifikasi.
///
/// Halaman Notifikasi belum dibuat, sehingga tab kedua masih menampilkan
/// pemberitahuan singkat alih-alih berpindah halaman.
class _SectionSwitch extends StatelessWidget {
  const _SectionSwitch();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _SwitchSegment(
                label: 'Transaksi',
                isActive: true,
                onPressed: () {},
              ),
              _SwitchSegment(
                label: 'Notifikasi',
                isActive: false,
                onPressed: () => showAppSnackBar(
                  context,
                  'Halaman Notifikasi belum tersedia.',
                ),
              ),
            ],
          ),
        ),
        // Digambar di atas kedua segmen; kalau dipasang sebagai latar,
        // isi segmen menutupi garis tepinya.
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.c097BC2, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SwitchSegment extends StatelessWidget {
  const _SwitchSegment({
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppColors.c097BC2 : AppColors.cFFFFFF,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 156,
          height: 42,
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: isActive ? AppColors.cFFFFFF : AppColors.c097BC2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutletIdentity extends StatelessWidget {
  const _OutletIdentity({required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final User? currentUser = user;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              currentUser?.outletName ?? '-',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 2),
            Text(
              '${currentUser?.role ?? ''} ${currentUser?.name ?? ''}'.trim(),
              style: AppTextStyles.caption.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cD9D9D9),
            image: const DecorationImage(
              image: AssetImage('assets/images/avatar_profile_men.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
