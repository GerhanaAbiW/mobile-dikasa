import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class ScreenConfig {
  // Samsung Galaxy Tab A7 Lite portrait resolution.
  static const Size designSize = Size(800, 1340);
}

enum ScreenType { mobile, tablet, desktop }

@immutable
class ScreenUtils {
  const ScreenUtils._({
    required this.size,
    required this.viewPadding,
    required this.viewInsets,
  });

  factory ScreenUtils.of(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ScreenUtil screenUtil = ScreenUtil();

    return ScreenUtils._(
      size: Size(screenUtil.screenWidth, screenUtil.screenHeight),
      viewPadding: mediaQuery.viewPadding,
      viewInsets: mediaQuery.viewInsets,
    );
  }

  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1100;

  final Size size;
  final EdgeInsets viewPadding;
  final EdgeInsets viewInsets;

  double get width => size.width;
  double get height => size.height;
  double get shortestSide => size.shortestSide;
  double get keyboardHeight => viewInsets.bottom;
  bool get isKeyboardVisible => keyboardHeight > 0;
  bool get isPortrait => height >= width;
  bool get isLandscape => !isPortrait;

  ScreenType get screenType {
    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    }
    if (width < desktopBreakpoint) {
      return ScreenType.tablet;
    }
    return ScreenType.desktop;
  }

  bool get isMobile => screenType == ScreenType.mobile;
  bool get isTablet => screenType == ScreenType.tablet;
  bool get isDesktop => screenType == ScreenType.desktop;

  double widthPercent(double percent) => (percent / 100).sw;
  double heightPercent(double percent) => (percent / 100).sh;

  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    return switch (screenType) {
      ScreenType.mobile => mobile,
      ScreenType.tablet => tablet ?? mobile,
      ScreenType.desktop => desktop ?? tablet ?? mobile,
    };
  }

  double get horizontalPagePadding => responsive<double>(
    mobile: 20.w.clamp(16, 24).toDouble(),
    tablet: 32.w.clamp(24, 40).toDouble(),
    desktop: 40.w.clamp(32, 56).toDouble(),
  );

  EdgeInsets get pagePadding => EdgeInsets.symmetric(
    horizontal: horizontalPagePadding,
    vertical: responsive<double>(
      mobile: 20.h.clamp(16, 28).toDouble(),
      tablet: 24.h.clamp(20, 36).toDouble(),
      desktop: 32.h.clamp(24, 48).toDouble(),
    ),
  );
}

extension ScreenUtilsContext on BuildContext {
  ScreenUtils get screen => ScreenUtils.of(this);
}
