/// Kelompok besar produk, sesuai tiga tab pada halaman Order.
enum ProductGroup {
  makanan('Makanan'),
  minuman('Minuman'),
  tambahan('Tambahan');

  const ProductGroup(this.label);

  /// Teks yang ditampilkan pada tab.
  final String label;

  static ProductGroup fromJson(String? value) {
    return ProductGroup.values.firstWhere(
      (ProductGroup group) => group.name == value,
      orElse: () => ProductGroup.makanan,
    );
  }
}

/// Satu produk yang bisa dipesan.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageAsset,
    required this.group,
    required this.category,
    required this.isHighlighted,
  });

  final String id;
  final String name;
  final int price;

  /// Path gambar di `assets/images/`.
  final String imageAsset;

  final ProductGroup group;

  /// Kategori yang dipakai oleh dropdown "Filter Kategori".
  final String category;

  /// Pada desain Figma sebagian nama produk dicetak merah.
  /// Arti pastinya belum dikonfirmasi ke tim desain - dugaan sementara
  /// adalah penanda stok menipis. Sementara ini hanya memengaruhi warna teks.
  final bool isHighlighted;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      imageAsset: json['image_asset'] as String? ?? '',
      group: ProductGroup.fromJson(json['group'] as String?),
      category: json['category'] as String? ?? '',
      isHighlighted: json['is_highlighted'] as bool? ?? false,
    );
  }
}
