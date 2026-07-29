import 'package:dio/dio.dart';
import 'package:mobile_dikasa/core/network/api_client.dart';
import 'package:mobile_dikasa/core/network/api_endpoints.dart';
import 'package:mobile_dikasa/core/network/api_exception.dart';
import 'package:mobile_dikasa/data/models/product.dart';

/// Lapisan jaringan untuk katalog produk.
class ProductService {
  const ProductService(this._apiClient);

  final ApiClient _apiClient;

  /// GET /products
  Future<List<Product>> fetchProducts() async {
    try {
      final Response<dynamic> response = await _apiClient.dio.get<dynamic>(
        ApiEndpoints.products,
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
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
