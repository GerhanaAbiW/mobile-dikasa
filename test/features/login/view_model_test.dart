import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_dikasa/core/network/api_client.dart';
import 'package:mobile_dikasa/core/network/mock_api_interceptor.dart';
import 'package:mobile_dikasa/data/repositories/auth_repository.dart';
import 'package:mobile_dikasa/data/services/auth_service.dart';
import 'package:mobile_dikasa/features/login/view_model.dart';

import '../../helpers/test_env.dart';

/// Menguji alur login dari ViewModel sampai lapisan jaringan.
/// Request dijawab oleh MockApiInterceptor, jadi tidak ada koneksi sungguhan.
void main() {
  late LoginViewModel viewModel;
  late AuthRepository authRepository;

  setUp(() {
    loadTestEnv();

    final ApiClient apiClient = ApiClient();
    authRepository = AuthRepository(
      authService: AuthService(apiClient),
      apiClient: apiClient,
    );
    viewModel = LoginViewModel(authRepository: authRepository);
  });

  group('validasi field', () {
    test('menolak username kosong maupun yang hanya berisi spasi', () {
      expect(viewModel.validateUsername(''), isNotNull);
      expect(viewModel.validateUsername('   '), isNotNull);
      expect(viewModel.validateUsername('admin'), isNull);
    });

    test('menolak password kosong', () {
      expect(viewModel.validatePassword(''), isNotNull);
      expect(viewModel.validatePassword('dikasa123'), isNull);
    });
  });

  group('submit', () {
    test('berhasil dengan kredensial yang benar', () async {
      viewModel.onUsernameChanged(MockApiInterceptor.demoUsername);
      viewModel.onPasswordChanged(MockApiInterceptor.demoPassword);

      final bool isSuccess = await viewModel.submit();

      expect(isSuccess, isTrue);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.isSubmitting, isFalse);
      expect(viewModel.loggedInUser?.username, MockApiInterceptor.demoUsername);
      // Session tersimpan di repository, bukan di ViewModel.
      expect(authRepository.isLoggedIn, isTrue);
    });

    test('gagal dengan pesan yang jelas saat password salah', () async {
      viewModel.onUsernameChanged(MockApiInterceptor.demoUsername);
      viewModel.onPasswordChanged('password-salah');

      final bool isSuccess = await viewModel.submit();

      expect(isSuccess, isFalse);
      expect(viewModel.errorMessage, 'Username atau password salah.');
      expect(viewModel.isSubmitting, isFalse);
      expect(authRepository.isLoggedIn, isFalse);
    });

    test('pesan error hilang begitu pengguna mengetik ulang', () async {
      viewModel.onUsernameChanged(MockApiInterceptor.demoUsername);
      viewModel.onPasswordChanged('password-salah');
      await viewModel.submit();
      expect(viewModel.errorMessage, isNotNull);

      viewModel.onPasswordChanged('p');

      expect(viewModel.errorMessage, isNull);
    });
  });

  test('reset mengosongkan input sensitif', () async {
    viewModel.onUsernameChanged(MockApiInterceptor.demoUsername);
    viewModel.onPasswordChanged(MockApiInterceptor.demoPassword);
    await viewModel.submit();

    viewModel.reset();

    expect(viewModel.username, isEmpty);
    expect(viewModel.password, isEmpty);
    expect(viewModel.loggedInUser, isNull);
    expect(viewModel.isPasswordHidden, isTrue);
  });
}
