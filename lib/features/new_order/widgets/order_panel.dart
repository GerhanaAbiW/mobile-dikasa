import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';
import 'package:mobile_dikasa/core/themes/text_styles.dart';
import 'package:mobile_dikasa/core/utils/app_snackbar.dart';
import 'package:mobile_dikasa/core/utils/formatted_currency.dart';
import 'package:mobile_dikasa/data/models/order_item.dart';
import 'package:mobile_dikasa/features/new_order/view_model.dart';
import 'package:mobile_dikasa/features/new_order/widgets/panel_dropdown.dart';

/// Panel kanan halaman Order: pesanan yang sedang disusun beserta totalnya.
class OrderPanel extends StatelessWidget {
  const OrderPanel({super.key, required this.viewModel});

  final NewOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.cFBFCFC,
      child: Column(
        children: <Widget>[
          _PanelHeader(viewModel: viewModel),
          Expanded(
            child: Observer(
              builder: (_) {
                // Disalin di dalam builder agar Observer benar-benar
                // memantau isi daftar. Membaca `orderItems` lewat itemBuilder
                // ListView tidak terpantau, karena itemBuilder dipanggil saat
                // layout — di luar cakupan builder ini.
                final List<OrderItem> items = viewModel.orderItems.toList();
                if (items.isEmpty) {
                  return const _EmptyOrder();
                }
                return _OrderItemList(
                  items: items,
                  onRemove: (OrderItem item) =>
                      viewModel.decreaseProduct(item.product),
                );
              },
            ),
          ),
          _TotalsBand(viewModel: viewModel),
          _PanelActions(viewModel: viewModel),
        ],
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.viewModel});

  final NewOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.c367AA0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _HeaderButton(
                    label: 'Daftar Order',
                    onPressed: () => _showComingSoon(context, 'Daftar Order'),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _HeaderButton(
                    label: 'Pelanggan',
                    onPressed: () => _showComingSoon(context, 'Pelanggan'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Observer(
              builder: (_) => PanelDropdown<OrderType>(
                label: viewModel.orderType?.label ?? '-- Pilih Jenis Order --',
                options: OrderType.values,
                optionLabel: (OrderType type) => type.label,
                onSelected: viewModel.selectOrderType,
                isActive: viewModel.orderType != null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String pageName) =>
      showAppSnackBar(context, 'Halaman $pageName belum tersedia.');
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cFFFFFF,
          foregroundColor: AppColors.c37474F,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.w500),
        ),
        child: Text(label),
      ),
    );
  }
}

class _EmptyOrder extends StatelessWidget {
  const _EmptyOrder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            'assets/icons/empty_order_book_icon.svg',
            width: 150,
            height: 150,
            colorFilter: ColorFilter.mode(AppColors.cD1D1D1, BlendMode.srcIn),
          ),
          const SizedBox(height: 28),
          Text(
            'Belum ada menu yang dipilih',
            style: AppTextStyles.body.copyWith(
              color: AppColors.cB5B5B5,
              fontSize: 17,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Daftar pesanan. Widget "bodoh": menerima potret pesanan dari pemanggil
/// dan tidak membaca store, sehingga reaktivitas ditangani Observer di atas.
///
/// Dijadikan stateful semata untuk memiliki [ScrollController] sendiri, agar
/// scrollbar tetap tampil dan posisi gulir tidak melompat saat daftar berubah.
class _OrderItemList extends StatefulWidget {
  const _OrderItemList({required this.items, required this.onRemove});

  final List<OrderItem> items;
  final ValueChanged<OrderItem> onRemove;

  @override
  State<_OrderItemList> createState() => _OrderItemListState();
}

class _OrderItemListState extends State<_OrderItemList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      thumbVisibility: true,
      child: ListView.separated(
        controller: _controller,
        padding: EdgeInsets.zero,
        itemCount: widget.items.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          thickness: 1,
          color: AppColors.cEAEAEA,
        ),
        itemBuilder: (BuildContext context, int index) {
          final OrderItem item = widget.items[index];
          return _OrderItemRow(
            item: item,
            isEven: index.isEven,
            onRemove: () => widget.onRemove(item),
          );
        },
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({
    required this.item,
    required this.isEven,
    required this.onRemove,
  });

  final OrderItem item;
  final bool isEven;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isEven ? AppColors.cFFFFFF : AppColors.cF8F8F8,
      child: InkWell(
        onTap: onRemove,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 46,
                child: Text(
                  '${item.quantity}x',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.c37474F,
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.product.name,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 15,
                        height: 1.3,
                        color: AppColors.c37474F,
                      ),
                    ),
                    if (item.note.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        'Notes : ${item.note}',
                        style: AppTextStyles.caption.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formatRupiah(item.subtotal, showCents: true),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.c37474F,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalsBand extends StatelessWidget {
  const _TotalsBand({required this.viewModel});

  final NewOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.cD6D6D6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Observer(
          builder: (_) => Column(
            children: <Widget>[
              _TotalRow(
                label: 'Total Pesanan',
                value: '${viewModel.totalQuantity} Produk',
              ),
              const SizedBox(height: 12),
              _TotalRow(
                label: 'Total Harga',
                value: formatRupiah(
                  viewModel.totalPrice,
                  prefix: 'Rp ',
                  showCents: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = AppTextStyles.sectionTitle.copyWith(
      fontSize: 15,
      color: AppColors.c37474F,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text(label, style: style), Text(value, style: style)],
    );
  }
}

class _PanelActions extends StatelessWidget {
  const _PanelActions({required this.viewModel});

  final NewOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    // Ketiga tombol selalu tampil penuh mengikuti desain. Pesanan yang masih
    // kosong ditangani lewat pesan, bukan dengan menonaktifkan tombol.
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _ActionButton(
                  label: 'Hapus',
                  foreground: AppColors.c9D1414,
                  background: AppColors.cFFFFFF,
                  borderColor: AppColors.c9D1414,
                  onPressed: () => _requireItems(context, viewModel.clearOrder),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _ActionButton(
                  label: 'Simpan',
                  foreground: AppColors.cFFFFFF,
                  background: AppColors.c097BC2,
                  onPressed: () => _requireItems(
                    context,
                    () => showAppSnackBar(
                      context,
                      'Simpan pesanan belum tersedia.',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: _ActionButton(
              label: 'Bayar',
              foreground: AppColors.cFFFFFF,
              background: AppColors.cFF8227,
              onPressed: () => _requireItems(
                context,
                () => showAppSnackBar(context, 'Pembayaran belum tersedia.'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Menjalankan [action] bila sudah ada pesanan, selain itu memberi tahu
  /// kasir bahwa belum ada menu yang dipilih.
  void _requireItems(BuildContext context, VoidCallback action) {
    if (!viewModel.hasOrderItems) {
      showAppSnackBar(context, 'Pilih menu terlebih dahulu.');
      return;
    }
    action();
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.foreground,
    required this.background,
    required this.onPressed,
    this.borderColor,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color? borderColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Color? border = borderColor;

    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: background.withAlpha(90),
          disabledForegroundColor: foreground.withAlpha(140),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: border == null
                ? BorderSide.none
                : BorderSide(color: border, width: 2),
          ),
          textStyle: AppTextStyles.button.copyWith(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
