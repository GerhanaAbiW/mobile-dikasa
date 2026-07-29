import 'package:dio/dio.dart';
import 'package:mobile_dikasa/core/network/api_client.dart';
import 'package:mobile_dikasa/core/network/api_endpoints.dart';
import 'package:mobile_dikasa/core/network/api_exception.dart';
import 'package:mobile_dikasa/data/models/auth_session.dart';

/// Lapisan jaringan untuk autentikasi.
///
/// Tugasnya hanya memanggil API dan mengubah response menjadi model.
/// Tidak menyimpan state apa pun — itu tugas Repository.
class AuthService {
  const AuthService(this._apiClient);

  final ApiClient _apiClient;

  /// POST /auth/login
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    try {
      final Response<dynamic> response = await _apiClient.dio.post<dynamic>(
        ApiEndpoints.login,
        data: <String, dynamic>{'username': username, 'password': password},
      );

      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    } on TypeError {
      throw const ApiException(
        type: ApiErrorType.parsing,
        message: 'Format data dari server tidak sesuai.',
      );
    }
  }
}
