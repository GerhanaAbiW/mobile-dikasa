import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';
import 'package:mobile_dikasa/core/network/api_client.dart';
import 'package:mobile_dikasa/core/routing/app_routes.dart';
import 'package:mobile_dikasa/data/repositories/auth_repository.dart';
import 'package:mobile_dikasa/data/repositories/product_repository.dart';
import 'package:mobile_dikasa/data/services/auth_service.dart';
import 'package:mobile_dikasa/data/services/product_service.dart';
import 'package:mobile_dikasa/features/login/view_model.dart';
import 'package:mobile_dikasa/features/new_order/view_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Wajib dipanggil sebelum memakai plugin (dotenv) di dalam `main`.
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MobileDikasaApp());
}

class MobileDikasaApp extends StatelessWidget {
  const MobileDikasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // --- Lapisan jaringan ---
        Provider<ApiClient>(create: (_) => ApiClient()),

        // --- Lapisan data ---
        // Repository dibuat sekali dan dipakai bersama, sehingga session
        // login tetap dikenali di seluruh halaman.
        Provider<AuthRepository>(
          create: (BuildContext context) {
            final ApiClient apiClient = context.read<ApiClient>();
            return AuthRepository(
              authService: AuthService(apiClient),
              apiClient: apiClient,
            );
          },
        ),
        Provider<ProductRepository>(
          create: (BuildContext context) => ProductRepository(
            productService: ProductService(context.read<ApiClient>()),
          ),
        ),

        // --- Lapisan presentasi ---
        Provider<LoginViewModel>(
          create: (BuildContext context) =>
              LoginViewModel(authRepository: context.read<AuthRepository>()),
        ),
        Provider<NewOrderViewModel>(
          create: (BuildContext context) => NewOrderViewModel(
            productRepository: context.read<ProductRepository>(),
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'DIKASA Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.cFFFFFF,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.c097BC2),
        ),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
