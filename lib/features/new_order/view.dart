import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';
import 'package:mobile_dikasa/core/routing/app_routes.dart';
import 'package:mobile_dikasa/core/themes/text_styles.dart';
import 'package:mobile_dikasa/core/utils/app_snackbar.dart';
import 'package:mobile_dikasa/features/new_order/view_model.dart';
import 'package:mobile_dikasa/features/new_order/widgets/catalog_filter_bar.dart';
import 'package:mobile_dikasa/features/new_order/widgets/opening_cash_dialog.dart';
import 'package:mobile_dikasa/features/new_order/widgets/order_panel.dart';
import 'package:mobile_dikasa/features/new_order/widgets/order_top_bar.dart';
import 'package:mobile_dikasa/features/new_order/widgets/product_catalog.dart';
import 'package:provider/provider.dart';

/// Halaman Order — layar utama kasir setelah login.
///
/// Kiri berisi katalog produk, kanan berisi pesanan yang sedang disusun.
class NewOrderView extends StatefulWidget {
  const NewOrderView({super.key});

  @override
  State<NewOrderView> createState() => _NewOrderViewState();
}

class _NewOrderViewState extends State<NewOrderView> {
  /// Lebar panel pesanan pada layar tablet, mengikuti proporsi desain.
  static const double _orderPanelWidth = 450;

  /// Di bawah lebar ini panel pesanan dipindah ke bawah katalog agar
  /// keduanya tetap terbaca.
  static const double _twoColumnBreakpoint = 1000;

  late final NewOrderViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<NewOrderViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadProducts();
      _askOpeningCash();
    });
  }

  /// Menanyakan kas awal sekali saja per sesi kasir.
  Future<void> _askOpeningCash() async {
    if (_viewModel.isOpeningCashResolved) {
      return;
    }

    final int? amount = await OpeningCashDialog.show(context);
    _viewModel.confirmOpeningCash(amount);
  }

  void _onLockPressed() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (Route<dynamic> route) => false,
    );
  }

  void _onMenuPressed() =>
      showAppSnackBar(context, 'Menu navigasi belum tersedia.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: OrderTopBar(
        user: _viewModel.currentUser,
        onMenuPressed: _onMenuPressed,
        onLockPressed: _onLockPressed,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget catalog = _CatalogColumn(viewModel: _viewModel);
            final Widget panel = OrderPanel(viewModel: _viewModel);

            if (constraints.maxWidth < _twoColumnBreakpoint) {
              return Column(
                children: <Widget>[
                  Expanded(child: catalog),
                  SizedBox(height: constraints.maxHeight * 0.45, child: panel),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: catalog),
                SizedBox(width: _orderPanelWidth, child: panel),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CatalogColumn extends StatelessWidget {
  const _CatalogColumn({required this.viewModel});

  final NewOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CatalogFilterBar(viewModel: viewModel),
        Expanded(
          child: Observer(
            builder: (_) {
              if (viewModel.isLoading && viewModel.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final String? error = viewModel.errorMessage;
              if (error != null && viewModel.products.isEmpty) {
                return _CatalogError(
                  message: error,
                  onRetry: () => viewModel.loadProducts(forceRefresh: true),
                );
              }

              return ProductCatalog(
                products: viewModel.visibleProducts,
                onProductSelected: viewModel.addProduct,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.cloud_off, size: 48, color: AppColors.cA4A4A4),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cFF8227,
                foregroundColor: AppColors.cFFFFFF,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: AppTextStyles.button,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
