import 'package:mobile_dikasa/data/models/user.dart';

/// Hasil login: token akses beserta data pengguna pemiliknya.
class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final User user;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: json['token'] as String? ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
