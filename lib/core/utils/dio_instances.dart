import 'package:dio/dio.dart';
import 'package:mobile_dikasa/core/constants/urls.dart';

final Dio v1Instance = Dio(
  BaseOptions(
    baseUrl: AppUrls.apiHostV1,
    headers: const <String, String>{
      Headers.contentTypeHeader: Headers.jsonContentType,
      'Access-Control-Allow-Headers':
          'Origin, X-Requested-With, Content-Type, Accept, Authorization',
    },
  ),
);
