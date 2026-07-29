import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_dikasa/core/network/api_client.dart';
import 'package:mobile_dikasa/core/network/mock_api_interceptor.dart';
import 'package:mobile_dikasa/data/models/product.dart';
import 'package:mobile_dikasa/data/repositories/auth_repository.dart';
import 'package:mobile_dikasa/data/repositories/product_repository.dart';
import 'package:mobile_dikasa/data/services/auth_service.dart';
import 'package:mobile_dikasa/data/services/product_service.dart';
import 'package:mobile_dikasa/features/new_order/view_model.dart';

import '../../helpers/test_env.dart';

void main() {
  late NewOrderViewModel viewModel;
  late AuthRepository authRepository;

  setUp(() async {
    loadTestEnv();

    final ApiClient apiClient = ApiClient();
    authRepository = AuthRepository(
      authService: AuthService(apiClient),
      apiClient: apiClient,
    );
    viewModel = NewOrderViewModel(
      productRepository: ProductRepository(
        productService: ProductService(apiClient),
      ),
      authRepository: authRepository,
    );

    await viewModel.loadProducts();
  });

  test('katalog terisi dan tab Makanan aktif secara awal', () {
    expect(viewModel.errorMessage, isNull);
    expect(viewModel.products, isNotEmpty);
    expect(viewModel.selectedGroup, ProductGroup.makanan);
    expect(viewModel.visibleProducts, isNotEmpty);
  });

  group('penyaringan katalog', () {
    test('berpindah tab hanya menampilkan produk kelompok tersebut', () {
      viewModel.selectGroup(ProductGroup.minuman);

      expect(
        viewModel.visibleProducts.every(
          (Product product) => product.group == ProductGroup.minuman,
        ),
        isTrue,
      );
    });

    test('berpindah tab mengembalikan filter kategori ke semula', () {
      viewModel.selectCategory('Seafood');
      expect(viewModel.selectedCategory, 'Seafood');

      viewModel.selectGroup(ProductGroup.minuman);

      expect(viewModel.selectedCategory, allCategoriesFilter);
    });

    test('pencarian menyaring berdasarkan nama tanpa peduli huruf besar', () {
      viewModel.onSearchChanged('NASI GORENG');

      expect(viewModel.visibleProducts, isNotEmpty);
      expect(
        viewModel.visibleProducts.every(
          (Product product) => product.name.toLowerCase().contains('nasi goreng'),
        ),
        isTrue,
      );
    });

    test('pencarian tanpa hasil mengembalikan daftar kosong', () {
      viewModel.onSearchChanged('rendang padang');

      expect(viewModel.visibleProducts, isEmpty);
    });
  });

  group('pesanan', () {
    test('menambah produk yang sama menaikkan jumlahnya, bukan barisnya', () {
      final Product product = viewModel.visibleProducts.first;

      viewModel.addProduct(product);
      viewModel.addProduct(product);
      viewModel.addProduct(product);

      expect(viewModel.orderItems.length, 1);
      expect(viewModel.orderItems.first.quantity, 3);
      expect(viewModel.totalQuantity, 3);
      expect(viewModel.totalPrice, product.price * 3);
    });

    test('mengurangi sampai habis menghapus barisnya', () {
      final Product product = viewModel.visibleProducts.first;

      viewModel.addProduct(product);
      viewModel.addProduct(product);
      viewModel.decreaseProduct(product);

      expect(viewModel.orderItems.first.quantity, 1);

      viewModel.decreaseProduct(product);

      expect(viewModel.orderItems, isEmpty);
      expect(viewModel.hasOrderItems, isFalse);
    });

    test('total dihitung dari beberapa produk berbeda', () {
      final Product first = viewModel.visibleProducts[0];
      final Product second = viewModel.visibleProducts[1];

      viewModel.addProduct(first);
      viewModel.addProduct(second);
      viewModel.addProduct(second);

      expect(viewModel.orderItems.length, 2);
      expect(viewModel.totalQuantity, 3);
      expect(viewModel.totalPrice, first.price + second.price * 2);
    });

    test('Hapus mengosongkan seluruh pesanan', () {
      viewModel.addProduct(viewModel.visibleProducts.first);
      viewModel.clearOrder();

      expect(viewModel.orderItems, isEmpty);
    });
  });

  group('kas awal', () {
    test('belum terjawab sebelum kasir menutup dialog', () {
      expect(viewModel.isOpeningCashResolved, isFalse);
      expect(viewModel.openingCash, isNull);
    });

    test('nominal tersimpan saat kasir menekan Masuk', () {
      viewModel.confirmOpeningCash(120000);

      expect(viewModel.openingCash, 120000);
      expect(viewModel.isOpeningCashResolved, isTrue);
    });

    test('dianggap terjawab meski kasir memilih Lewati', () {
      viewModel.confirmOpeningCash(null);

      expect(viewModel.openingCash, isNull);
      expect(viewModel.isOpeningCashResolved, isTrue);
    });
  });

  test('currentUser terbaca dari repository setelah login', () async {
    expect(viewModel.currentUser, isNull);

    await authRepository.login(
      username: MockApiInterceptor.demoUsername,
      password: MockApiInterceptor.demoPassword,
    );

    expect(viewModel.currentUser?.outletName, 'Warteg Bahari');
  });
}
