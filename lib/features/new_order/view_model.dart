import 'package:mobile_dikasa/core/network/api_exception.dart';
import 'package:mobile_dikasa/data/models/order_item.dart';
import 'package:mobile_dikasa/data/models/product.dart';
import 'package:mobile_dikasa/data/models/user.dart';
import 'package:mobile_dikasa/data/repositories/auth_repository.dart';
import 'package:mobile_dikasa/data/repositories/product_repository.dart';
import 'package:mobx/mobx.dart';

part 'view_model.g.dart';

class NewOrderViewModel = NewOrderViewModelBase with _$NewOrderViewModel;

/// Nilai yang dipakai dropdown kategori untuk mewakili "semua kategori".
///
/// Ditulis sebagai konstanta lepas, bukan anggota statis store, karena
/// anggota statis tidak ikut terbawa ke class hasil mixin MobX.
const String allCategoriesFilter = 'Filter Kategori';

/// Pilihan pada dropdown "Pilih Jenis Order".
enum OrderType {
  bebasPilihMeja('Bebas Pilih Meja'),
  pesanMeja('Pesan Meja'),
  bawaPulang('Bawa Pulang');

  const OrderType(this.label);

  final String label;
}

/// State dan logika halaman Order (transaksi kasir).
abstract class NewOrderViewModelBase with Store {
  NewOrderViewModelBase({
    required ProductRepository productRepository,
    required AuthRepository authRepository,
  }) : _productRepository = productRepository,
       _authRepository = authRepository;

  final ProductRepository _productRepository;
  final AuthRepository _authRepository;

  // =========================
  // Katalog
  // =========================

  @observable
  ObservableList<Product> products = ObservableList<Product>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ProductGroup selectedGroup = ProductGroup.makanan;

  @observable
  String selectedCategory = allCategoriesFilter;

  @observable
  String searchQuery = '';

  // =========================
  // Pesanan berjalan
  // =========================

  @observable
  ObservableList<OrderItem> orderItems = ObservableList<OrderItem>();

  @observable
  OrderType? orderType;

  /// Kas awal yang dipegang kasir. `null` selama dialog belum diisi.
  @observable
  int? openingCash;

  /// Menjadi true setelah kasir mengisi atau melewati dialog Kas Awal,
  /// sehingga dialog tidak muncul lagi saat halaman di-rebuild.
  @observable
  bool isOpeningCashResolved = false;

  User? get currentUser => _authRepository.currentUser;

  /// Produk pada tab yang sedang aktif.
  @computed
  List<Product> get _productsInGroup => products
      .where((Product product) => product.group == selectedGroup)
      .toList();

  /// Isi dropdown "Filter Kategori", mengikuti tab yang sedang aktif.
  @computed
  List<String> get categories => <String>[
    allCategoriesFilter,
    ..._productsInGroup
        .map((Product product) => product.category)
        .toSet()
        .toList()
      ..sort(),
  ];

  /// Produk yang lolos filter tab, kategori, dan pencarian.
  @computed
  List<Product> get visibleProducts {
    final String query = searchQuery.trim().toLowerCase();

    return _productsInGroup.where((Product product) {
      final bool matchesCategory =
          selectedCategory == allCategoriesFilter ||
          product.category == selectedCategory;
      final bool matchesQuery =
          query.isEmpty || product.name.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  @computed
  bool get hasOrderItems => orderItems.isNotEmpty;

  @computed
  int get totalQuantity => orderItems.fold<int>(
    0,
    (int total, OrderItem item) => total + item.quantity,
  );

  @computed
  int get totalPrice => orderItems.fold<int>(
    0,
    (int total, OrderItem item) => total + item.subtotal,
  );

  // =========================
  // Aksi
  // =========================

  @action
  Future<void> loadProducts({bool forceRefresh = false}) async {
    isLoading = true;
    errorMessage = null;

    try {
      final List<Product> result = await _productRepository.getProducts(
        forceRefresh: forceRefresh,
      );
      products = ObservableList<Product>.of(result);
    } on ApiException catch (error) {
      errorMessage = error.message;
    } catch (error) {
      errorMessage = 'Terjadi kesalahan tak terduga. Silakan coba lagi.';
    } finally {
      isLoading = false;
    }
  }

  @action
  void selectGroup(ProductGroup group) {
    if (selectedGroup == group) {
      return;
    }
    selectedGroup = group;
    // Kategori pada tab lama belum tentu ada di tab baru.
    selectedCategory = allCategoriesFilter;
  }

  @action
  void selectCategory(String category) => selectedCategory = category;

  @action
  void onSearchChanged(String value) => searchQuery = value;

  @action
  void selectOrderType(OrderType type) => orderType = type;

  /// Menambah produk ke pesanan; bila sudah ada, jumlahnya bertambah satu.
  @action
  void addProduct(Product product) {
    final int index = orderItems.indexWhere(
      (OrderItem item) => item.product.id == product.id,
    );

    if (index == -1) {
      orderItems.add(OrderItem(product: product, quantity: 1));
      return;
    }

    orderItems[index] = orderItems[index].copyWith(
      quantity: orderItems[index].quantity + 1,
    );
  }

  /// Mengurangi satu jumlah; baris terhapus saat jumlahnya habis.
  @action
  void decreaseProduct(Product product) {
    final int index = orderItems.indexWhere(
      (OrderItem item) => item.product.id == product.id,
    );
    if (index == -1) {
      return;
    }

    final OrderItem item = orderItems[index];
    if (item.quantity <= 1) {
      orderItems.removeAt(index);
      return;
    }

    orderItems[index] = item.copyWith(quantity: item.quantity - 1);
  }

  @action
  void clearOrder() => orderItems.clear();

  @action
  void confirmOpeningCash(int? amount) {
    openingCash = amount;
    isOpeningCashResolved = true;
  }
}
