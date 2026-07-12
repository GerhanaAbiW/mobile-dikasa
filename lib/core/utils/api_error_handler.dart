import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

bool _isErrorDialogVisible = false;

String getApiErrorMessage(Object error) {
  if (error is! DioException) {
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }

  final String? backendMessage = _extractBackendMessage(error.response?.data);
  if (backendMessage != null) {
    return backendMessage;
  }

  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout =>
      'Koneksi ke server habis waktu. Silakan coba lagi.',
    DioExceptionType.connectionError =>
      'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
    DioExceptionType.cancel => 'Permintaan dibatalkan.',
    _ => 'Terjadi kesalahan. Silakan coba lagi.',
  };
}

Future<void> handleApiError(Object error) async {
  final BuildContext? context = appNavigatorKey.currentContext;
  if (context == null || _isErrorDialogVisible) {
    return;
  }

  _isErrorDialogVisible = true;

  try {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(getApiErrorMessage(error)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } finally {
    _isErrorDialogVisible = false;
  }
}

String? _extractBackendMessage(Object? data) {
  if (data is String && data.trim().isNotEmpty) {
    return data.trim();
  }

  if (data is! Map) {
    return null;
  }

  for (final String key in <String>['message', 'error', 'detail']) {
    final Object? value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }

  final Object? errors = data['errors'];
  if (errors is List && errors.isNotEmpty) {
    return _extractBackendMessage(errors.first);
  }

  if (errors is Map) {
    for (final Object? value in errors.values) {
      if (value is List && value.isNotEmpty) {
        return _extractBackendMessage(value.first);
      }
      final String? message = _extractBackendMessage(value);
      if (message != null) {
        return message;
      }
    }
  }

  return null;
}
