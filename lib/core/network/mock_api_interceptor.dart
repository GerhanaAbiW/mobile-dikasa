import 'package:dio/dio.dart';
import 'package:mobile_dikasa/core/network/api_endpoints.dart';

/// Penjawab request tiruan sementara backend belum ada; data mengikuti Figma dan dinonaktifkan lewat `USE_MOCK_API=false`.
class MockApiInterceptor extends Interceptor {
  /// Kredensial demo untuk mencoba alur login.
  static const String demoUsername = 'admin';
  static const String demoPassword = 'dikasa123';

  /// Jeda buatan supaya indikator loading benar-benar terlihat saat dicoba.
  static const Duration _latency = Duration(milliseconds: 700);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(_latency);

    switch (options.path) {
      case ApiEndpoints.login:
        return _handleLogin(options, handler);
      case ApiEndpoints.products:
        return _handleProducts(options, handler);
      default:
        return handler.next(options);
    }
  }

  void _handleLogin(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final Map<String, dynamic> body =
        (options.data as Map<String, dynamic>?) ?? <String, dynamic>{};
    final String username = (body['username'] as String? ?? '').trim();
    final String password = body['password'] as String? ?? '';

    final bool isValid =
        username.toLowerCase() == demoUsername && password == demoPassword;

    if (!isValid) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: _response(options, 401, <String, dynamic>{
            'message': 'Username atau password salah.',
          }),
        ),
      );
    }

    handler.resolve(
      _response(options, 200, <String, dynamic>{
        'token': 'mock-token-dikasa',
        'user': <String, dynamic>{
          'id': '1',
          'name': 'Jane Doe',
          'username': demoUsername,
          'role': 'Kasir',
          'outlet_name': 'Warteg Bahari',
        },
      }),
    );
  }

  void _handleProducts(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    handler.resolve(_response(options, 200, _products));
  }

  Response<dynamic> _response(
    RequestOptions options,
    int statusCode,
    dynamic data,
  ) {
    return Response<dynamic>(
      requestOptions: options,
      statusCode: statusCode,
      data: data,
    );
  }

  /// Katalog contoh. Nama, harga, dan gambar mengikuti desain Figma
  /// "Order - Clean" beserta variannya.
  static const List<Map<String, dynamic>> _products = <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'p1',
      'name': 'Cumi Goreng Asam Manis',
      'price': 21000,
      'image_asset': 'assets/images/cumia_goreng_asam_manis.png',
      'group': 'makanan',
      'category': 'Seafood',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p2',
      'name': 'Cumi Goreng Mentega',
      'price': 21000,
      'image_asset': 'assets/images/cumi_goreng_mentega.png',
      'group': 'makanan',
      'category': 'Seafood',
      'is_highlighted': true,
    },
    <String, dynamic>{
      'id': 'p3',
      'name': "Se'i Sapi Single Portion",
      'price': 21000,
      'image_asset': 'assets/images/sei_sapi_single_portion.png',
      'group': 'makanan',
      'category': 'Daging',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p4',
      'name': 'Ayam Geprek Sambal Matah',
      'price': 21000,
      'image_asset': 'assets/images/ayam_geprek_sambel_matah.png',
      'group': 'makanan',
      'category': 'Ayam',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p5',
      'name': 'Nasi Goreng Nugget',
      'price': 21000,
      'image_asset': 'assets/images/nasi_goreng_nugget.png',
      'group': 'makanan',
      'category': 'Nasi Goreng',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p6',
      'name': "Se'i Sapi Double Portion",
      'price': 21000,
      'image_asset': 'assets/images/sei_sapi_double_portion.png',
      'group': 'makanan',
      'category': 'Daging',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p7',
      'name': 'Nasi Goreng Spesial',
      'price': 21000,
      'image_asset': 'assets/images/nasi_goreng_spesial.png',
      'group': 'makanan',
      'category': 'Nasi Goreng',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p8',
      'name': 'Nasi Goreng Sosis',
      'price': 21000,
      'image_asset': 'assets/images/nasi_goreng_sosis.png',
      'group': 'makanan',
      'category': 'Nasi Goreng',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p9',
      'name': 'Ayam Geprek Spesial',
      'price': 21000,
      'image_asset': 'assets/images/ayam_geprek_spesial.png',
      'group': 'makanan',
      'category': 'Ayam',
      'is_highlighted': true,
    },
    <String, dynamic>{
      'id': 'p10',
      'name': 'Nasi Goreng Katsu',
      'price': 21000,
      'image_asset': 'assets/images/nasi_goreng_katsu.png',
      'group': 'makanan',
      'category': 'Nasi Goreng',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p11',
      'name': 'Chicken Katsu with Rice',
      'price': 21000,
      'image_asset': 'assets/images/chicken_katsu_with_rice.png',
      'group': 'makanan',
      'category': 'Ayam',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p12',
      'name': 'Es Teh Manis Jumbo',
      'price': 10000,
      'image_asset': 'assets/images/es_teh_manis_jumbo.png',
      'group': 'minuman',
      'category': 'Teh',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p13',
      'name': 'Teh Manis Panas',
      'price': 8000,
      'image_asset': 'assets/images/teh_manis_panas.png',
      'group': 'minuman',
      'category': 'Teh',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p14',
      'name': 'Ice Lemon Tea',
      'price': 12000,
      'image_asset': 'assets/images/ice_lemon_tea.png',
      'group': 'minuman',
      'category': 'Teh',
      'is_highlighted': false,
    },
    <String, dynamic>{
      'id': 'p15',
      'name': 'Ice Choco Hazelnut',
      'price': 25000,
      'image_asset': 'assets/images/ice_choco_hazelnut.png',
      'group': 'minuman',
      'category': 'Kopi & Coklat',
      'is_highlighted': false,
    },
  ];
}
