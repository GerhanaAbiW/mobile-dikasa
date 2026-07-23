import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';
import 'package:mobile_dikasa/core/routing/app_routes.dart';

/// Halaman pembuka.
///
/// Murni animasi dua frame lalu berpindah ke halaman Login. Tidak ada data
/// yang diambil di sini, sehingga halaman ini tidak memerlukan ViewModel.
class SplashView extends StatefulWidget {
  const SplashView({
    super.key,
    this.firstFrameDuration = const Duration(milliseconds: 1200),
    this.secondFrameDuration = const Duration(milliseconds: 1800),
  });

  final Duration firstFrameDuration;
  final Duration secondFrameDuration;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  _SplashFrameType _currentFrame = _SplashFrameType.zero;
  Timer? _firstFrameTimer;
  Timer? _finishTimer;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  @override
  void dispose() {
    _firstFrameTimer?.cancel();
    _finishTimer?.cancel();
    super.dispose();
  }

  void _startSequence() {
    _firstFrameTimer = Timer(widget.firstFrameDuration, () {
      if (!mounted) {
        return;
      }

      setState(() {
        _currentFrame = _SplashFrameType.main;
      });
    });

    _finishTimer = Timer(
      widget.firstFrameDuration + widget.secondFrameDuration,
      () {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _currentFrame == _SplashFrameType.zero
          ? const SplashFrameZero(key: ValueKey<String>('splash_zero'))
          : const SplashFrameMain(key: ValueKey<String>('splash_main')),
    );
  }
}

enum _SplashFrameType { zero, main }

class SplashFrameZero extends StatelessWidget {
  const SplashFrameZero({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashScaffold(variant: _SplashBackgroundVariant.zero);
  }
}

class SplashFrameMain extends StatelessWidget {
  const SplashFrameMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashScaffold(
      variant: _SplashBackgroundVariant.main,
      child: _SplashMainLogo(),
    );
  }
}

class _SplashScaffold extends StatelessWidget {
  const _SplashScaffold({
    required this.variant,
    this.child,
  });

  final _SplashBackgroundVariant variant;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _SplashBackground(variant: variant),
          if (child != null)
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: child,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum _SplashBackgroundVariant { zero, main }

class _SplashBackground extends StatelessWidget {
  const _SplashBackground({required this.variant});

  final _SplashBackgroundVariant variant;

  @override
  Widget build(BuildContext context) {
    final bool isMain = variant == _SplashBackgroundVariant.main;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _IconPatternBand(
          alignment: Alignment.topCenter,
          heightFactor: isMain ? 0.34 : 0.30,
        ),
        _IconPatternBand(
          alignment: Alignment.bottomCenter,
          heightFactor: isMain ? 0.34 : 0.30,
        ),
      ],
    );
  }
}

class _IconPatternBand extends StatelessWidget {
  const _IconPatternBand({
    required this.alignment,
    required this.heightFactor,
  });

  static const List<IconData> _icons = <IconData>[
    Icons.point_of_sale_outlined,
    Icons.fastfood_outlined,
    Icons.receipt_long_outlined,
    Icons.person_outline,
  ];

  final Alignment alignment;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double bandHeight = screenSize.height * heightFactor;
    final double cellWidth = (screenSize.width / 5.2).clamp(96.0, 180.0).toDouble();
    final double runSpacing = (bandHeight * 0.20).clamp(18.0, 46.0).toDouble();
    final Color iconColor = AppColors.cD9D9D9.withAlpha(110);

    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: SizedBox(
          width: screenSize.width,
          height: bandHeight,
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            runAlignment: WrapAlignment.center,
            spacing: 0,
            runSpacing: runSpacing,
            children: List<Widget>.generate(15, (int index) {
              final IconData iconData = _icons[index % _icons.length];
              final double iconSize = index % 3 == 0 ? 30 : 26;

              return SizedBox(
                width: cellWidth,
                child: Center(
                  child: Icon(
                    iconData,
                    size: iconSize,
                    color: iconColor,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _SplashMainLogo extends StatelessWidget {
  const _SplashMainLogo();

  static const String logoAssetPath =
      'assets/images/dikasa_logo_splash_screen.png';

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double logoWidth =
        (screenSize.width * 0.70).clamp(260.0, 760.0).toDouble();

    return Image.asset(
      logoAssetPath,
      width: logoWidth,
      fit: BoxFit.contain,
    );
  }
}
