class AuthResponseModel {
  final String token;
  final String message;
  final Map<String, dynamic> user; // Tambahan untuk object user

  AuthResponseModel({
    required this.token,
    required this.message,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['data']?['token'] ?? '',
      message: json['message'] ?? 'Login berhasil',
      user: json['data']?['user'] ?? {},
    );
  }
}
