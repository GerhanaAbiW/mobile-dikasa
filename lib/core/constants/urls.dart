import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppUrls {
  static String get apiHostV1 => dotenv.env['DIKASA_BASE_API_V1'] ?? '';
}
