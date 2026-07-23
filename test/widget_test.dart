import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_dikasa/features/login/view.dart';
import 'package:mobile_dikasa/features/splash/view.dart';
import 'package:mobile_dikasa/main.dart';

import 'helpers/test_env.dart';

void main() {
  setUp(loadTestEnv);

  /// Menunggu kedua frame splash selesai (1200ms + 1800ms).
  Future<void> skipSplash(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();
  }

  testWidgets('Splash berpindah otomatis ke halaman Login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MobileDikasaApp());

    expect(find.byType(SplashView), findsOneWidget);
    expect(find.byType(LoginView), findsNothing);

    await skipSplash(tester);

    expect(find.byType(LoginView), findsOneWidget);
    expect(find.text('Masuk ke Dashboard'), findsOneWidget);
  });

  testWidgets('Menekan Masuk dengan field kosong menampilkan pesan validasi', (
    WidgetTester tester,
  ) async {
    // Ukuran tablet agar login memakai layout dua kolom seperti pada desain
    // dan tombol Masuk berada di dalam layar.
    tester.view.physicalSize = const Size(1340, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MobileDikasaApp());
    await skipSplash(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk'));
    await tester.pump();

    expect(find.text('Username / nomor HP wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });
}
