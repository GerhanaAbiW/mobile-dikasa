import 'package:flutter/material.dart';
import 'package:mobile_dikasa/features/login/view.dart';
import 'package:mobile_dikasa/features/new_order/view.dart';
import 'package:mobile_dikasa/features/splash/view.dart';

/// Daftar nama route beserta pemetaannya ke halaman.
///
/// Penambahan halaman berikutnya (register, produk, laporan) cukup
/// ditambahkan di satu tempat ini.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String newOrder = '/order';

  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
    splash: (_) => const SplashView(),
    login: (_) => const LoginView(),
    newOrder: (_) => const NewOrderView(),
  };
}
