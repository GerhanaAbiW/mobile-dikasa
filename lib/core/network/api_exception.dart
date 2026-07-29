import 'package:dio/dio.dart';

/// Jenis kegagalan request, dipisah agar UI bisa memberi pesan yang tepat.
enum ApiErrorType {
  /// Tidak sampai ke server: timeout, tidak ada internet, DNS gagal.
  network,

  /// Sampai ke server tetapi kredensial ditolak (HTTP 401 / 403).
  unauthorized,

  /// Sampai ke server tetapi server menjawab error (HTTP 4xx / 5xx lainnya).
  server,

  /// Response berhasil diterima tetapi bentuk datanya di luar dugaan.
  parsing,
}

/// Error tunggal lapisan Service; ViewModel cukup menangkap tipe ini tanpa perlu tahu soal Dio.
class ApiException implements Exception {
  const ApiException({required this.type, required this.message});

  final ApiErrorType type;

  /// Pesan siap tampil ke pengguna (bahasa Indonesia).
  final String message;

  /// Menerjemahkan [DioException] menjadi [ApiException] yang lebih ramah.
  factory ApiException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          type: ApiErrorType.network,
          message: 'Koneksi timeout. Periksa jaringan Anda lalu coba lagi.',
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return const ApiException(
          type: ApiErrorType.network,
          message: 'Tidak dapat terhubung ke server. Periksa koneksi internet.',
        );

      case DioExceptionType.badCertificate:
        return const ApiException(
          type: ApiErrorType.network,
          message: 'Sertifikat server tidak valid.',
        );

      case DioExceptionType.cancel:
        return const ApiException(
          type: ApiErrorType.network,
          message: 'Permintaan dibatalkan.',
        );

      case DioExceptionType.badResponse:
        return ApiException._fromStatusCode(error.response);
    }
  }

  /// Server menjawab, tetapi dengan status gagal.
  factory ApiException._fromStatusCode(Response<dynamic>? response) {
    final int statusCode = response?.statusCode ?? 0;

    // Backend boleh mengirim {"message": "..."}; kalau ada, itu yang dipakai.
    final dynamic body = response?.data;
    final String? serverMessage = body is Map<String, dynamic>
        ? body['message'] as String?
        : null;

    if (statusCode == 401 || statusCode == 403) {
      return ApiException(
        type: ApiErrorType.unauthorized,
        message: serverMessage ?? 'Username atau password salah.',
      );
    }

    if (statusCode >= 500) {
      return ApiException(
        type: ApiErrorType.server,
        message:
            serverMessage ?? 'Server sedang bermasalah. Coba beberapa saat lagi.',
      );
    }

    return ApiException(
      type: ApiErrorType.server,
      message: serverMessage ?? 'Permintaan gagal diproses ($statusCode).',
    );
  }

  @override
  String toString() => 'ApiException(${type.name}): $message';
}
