import 'package:mobile_dikasa/data/models/product.dart';

/// Satu baris pesanan pada panel kanan halaman Order.
class OrderItem {
  const OrderItem({
    required this.product,
    required this.quantity,
    this.note = '',
  });

  final Product product;
  final int quantity;

  /// Catatan pelanggan, mis. "Tidak Pedas". Kosong bila tidak ada.
  final String note;

  int get subtotal => product.price * quantity;

  OrderItem copyWith({int? quantity, String? note}) {
    return OrderItem(
      product: product,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
