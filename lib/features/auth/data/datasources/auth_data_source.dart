import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_response_model.dart';

class AuthDataSource {
  final Dio dio;
  final SharedPreferences prefs;

  //Get from Dependency Injection
  AuthDataSource({required this.dio, required this.prefs});

  Future<AuthResponseModel> login(String email, String password, String deviceName) async {
    try {
      final response = await dio.post('/api/login', data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      });

      final result = AuthResponseModel.fromJson(response.data);

      if (result.token.isNotEmpty) {
        await prefs.setString('auth_token', result.token);
      }

      // Simpan Object User (diubah jadi String JSON dulu)
      if (result.user.isNotEmpty) {
        await prefs.setString('user_data', jsonEncode(result.user));
      }

      return result;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;

        if (responseData['message'] != null &&
            responseData['success'] == false) {
          throw Exception(responseData['message']);
        } else if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first[0];
          throw Exception(firstError);
        }
      }
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak terduga');
    }
  }

  String? getToken() {
    return prefs.getString('auth_token');
  }

  // Fungsi untuk mengambil data user (di-decode kembali ke Object)
  Map<String, dynamic>? getUser() {
    final userString = prefs.getString('user_data');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }
}
