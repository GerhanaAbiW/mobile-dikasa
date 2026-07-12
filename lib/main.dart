import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_dikasa/core/utils/api_error_handler.dart';
import 'package:mobile_dikasa/core/utils/screen_utils.dart';
import 'package:mobile_dikasa/features/login/main.dart';
import 'package:mobile_dikasa/features/splash/main.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MobileDikasaApp());
}

class MobileDikasaApp extends StatelessWidget {
  const MobileDikasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: ScreenConfig.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      child: const _AppEntryPoint(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          navigatorKey: appNavigatorKey,
          title: 'DIKASA Mobile',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
          home: child,
        );
      },
    );
  }
}

class _AppEntryPoint extends StatefulWidget {
  const _AppEntryPoint();

  @override
  State<_AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<_AppEntryPoint> {
  bool _showLogin = false;

  void _openLogin() {
    if (_showLogin) {
      return;
    }

    setState(() {
      _showLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _showLogin
          ? const LoginPage(key: ValueKey<String>('login_page'))
          : SplashScreen(
              key: const ValueKey<String>('splash_page'),
              onFinished: _openLogin,
            ),
    );
  }
}
