import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_dikasa/main.dart';

void main() {
  testWidgets('App shows splash flow', (WidgetTester tester) async {
    await tester.pumpWidget(const MobileDikasaApp());

    final Finder splashLogoFinder = find.byWidgetPredicate((Widget widget) {
      if (widget is! Image) {
        return false;
      }
      if (widget.image is! AssetImage) {
        return false;
      }

      return (widget.image as AssetImage).assetName ==
          'lib/assets/images/splash_screen/dikasa_logo_splash_screen.png';
    });

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(splashLogoFinder, findsNothing);

    await tester.pump(const Duration(milliseconds: 1300));

    expect(splashLogoFinder, findsOneWidget);
  });
}