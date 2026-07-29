import 'package:mobile_dikasa/core/network/api_client.dart';
import 'package:mobile_dikasa/data/models/auth_session.dart';
import 'package:mobile_dikasa/data/models/user.dart';
import 'package:mobile_dikasa/data/services/auth_service.dart';

/// Sumber kebenaran tunggal untuk status autentikasi.
///
/// Session disimpan di sini, bukan di ViewModel, supaya halaman lain
/// (mis. Dashboard) bisa membaca siapa yang sedang login tanpa harus
/// mengoper data lewat argumen navigasi.
class AuthRepository {
  AuthRepository({
    required AuthService authService,
    required ApiClient apiClient,
  }) : _authService = authService,
       _apiClient = apiClient;

  final AuthService _authService;
  final ApiClient _apiClient;

  AuthSession? _session;

  /// Pengguna yang sedang login, `null` jika belum login.
  User? get currentUser => _session?.user;

  bool get isLoggedIn => _session != null;

  /// Melakukan login lalu menyimpan session dan token aktif.
  ///
  /// Melempar [ApiException] bila gagal — penanganannya di ViewModel.
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final AuthSession session = await _authService.login(
      username: username,
      password: password,
    );

    _session = session;
    // Sejak titik ini semua request otomatis membawa header Authorization.
    _apiClient.updateAuthToken(session.token);

    return session.user;
  }

  /// Menghapus session dan token yang tersimpan.
  void logout() {
    _session = null;
    _apiClient.updateAuthToken(null);
  }
}
