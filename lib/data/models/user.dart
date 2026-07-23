/// Data pengguna yang sedang login.
///
/// Model hanya mendefinisikan bentuk data dan cara membacanya dari JSON.
/// Tidak ada logika tampilan maupun jaringan di sini.
class User {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.outletName,
  });

  final String id;
  final String name;
  final String username;
  final String role;
  final String outletName;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      role: json['role'] as String? ?? '',
      outletName: json['outlet_name'] as String? ?? '',
    );
  }

  /// Inisial nama untuk ditampilkan pada avatar dashboard.
  String get initials {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
