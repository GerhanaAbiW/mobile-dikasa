import 'package:mobile_dikasa/core/network/api_exception.dart';
import 'package:mobile_dikasa/data/models/user.dart';
import 'package:mobile_dikasa/data/repositories/auth_repository.dart';
import 'package:mobx/mobx.dart';

part 'view_model.g.dart';

class LoginViewModel = LoginViewModelBase with _$LoginViewModel;

/// State dan logika halaman Login.
///
/// Seluruh keputusan ada di sini: kapan tombol boleh ditekan, apa isi pesan
/// error, dan kapan navigasi ke dashboard boleh dilakukan. View hanya
/// menggambar apa yang dikatakan store ini.
abstract class LoginViewModelBase with Store {
  LoginViewModelBase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @observable
  String username = '';

  @observable
  String password = '';

  /// Password disembunyikan secara default; ditoggle lewat ikon mata.
  @observable
  bool isPasswordHidden = true;

  @observable
  bool isSubmitting = false;

  /// Pesan error dari server / jaringan. Error validasi form tidak lewat sini.
  @observable
  String? errorMessage;

  /// Terisi setelah login berhasil, menjadi penanda bagi View untuk pindah
  /// halaman. Dipakai sebagai sinyal satu arah agar View tetap "bodoh".
  @observable
  User? loggedInUser;

  @action
  void onUsernameChanged(String value) {
    username = value;
    _clearError();
  }

  @action
  void onPasswordChanged(String value) {
    password = value;
    _clearError();
  }

  @action
  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
  }

  /// Validasi field username, dipakai langsung oleh `TextFormField`.
  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username / nomor HP wajib diisi';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password wajib diisi';
    }
    return null;
  }

  /// Menjalankan proses login. Mengembalikan `true` bila berhasil.
  @action
  Future<bool> submit() async {
    if (isSubmitting) {
      return false;
    }

    isSubmitting = true;
    errorMessage = null;

    try {
      loggedInUser = await _authRepository.login(
        username: username.trim(),
        password: password,
      );
      return true;
    } on ApiException catch (error) {
      // Pesan sudah diterjemahkan di lapisan network, tinggal ditampilkan.
      errorMessage = error.message;
      return false;
    } catch (error) {
      errorMessage = 'Terjadi kesalahan tak terduga. Silakan coba lagi.';
      return false;
    } finally {
      isSubmitting = false;
    }
  }

  /// Mengosongkan input sensitif saat meninggalkan halaman.
  @action
  void reset() {
    username = '';
    password = '';
    isPasswordHidden = true;
    errorMessage = null;
    loggedInUser = null;
  }

  @action
  void _clearError() {
    if (errorMessage != null) {
      errorMessage = null;
    }
  }
}
