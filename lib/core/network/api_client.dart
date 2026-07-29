import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_dikasa/core/network/mock_api_interceptor.dart';

/// Pembungkus tunggal Dio; base URL, timeout, header auth, dan logging diatur sekali di sini.
class ApiClient {
  ApiClient({Dio? dio}) : dio = dio ?? Dio() {
    _configure();
  }

  final Dio dio;

  /// Token yang dilampirkan otomatis ke setiap request setelah login.
  String? _authToken;

  void _configure() {
    dio.options = BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
    );

    // Menyisipkan Authorization header tanpa perlu diulang di tiap Service.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final String? token = _authToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    // Set USE_MOCK_API=false di .env untuk memakai backend asli.
    if (dotenv.env['USE_MOCK_API'] == 'true') {
      dio.interceptors.add(MockApiInterceptor());
    }

    // Log request/response hanya saat debug, agar tidak bocor di build rilis.
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true));
    }
  }

  /// Dipanggil AuthRepository setelah login berhasil / saat logout.
  void updateAuthToken(String? token) => _authToken = token;
}
