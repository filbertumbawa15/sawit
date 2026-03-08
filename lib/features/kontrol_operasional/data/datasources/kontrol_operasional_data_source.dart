import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KontrolOperasionalDataSource {
  final Dio dio;

  KontrolOperasionalDataSource({required this.dio});

  Future<List<dynamic>> fetchListKontrol({int page = 1}) async {
    try {
      final response = await dio.get(
        '/api/operational-controls',
        queryParameters: {'page': page},
      );

      // 4. Cek apakah response sukses
      if (response.statusCode == 200 && response.data['success'] == true) {
        // Karena ada pagination, list array aslinya ada di dalam ['data']['data']
        return response.data['data']['data'];
      } else {
        throw Exception('Gagal mengambil data dari server');
      }
    } on DioException catch (e) {
      // Menangkap error khusus dari Dio (seperti 401 Unauthorized, 500 Server Error)
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan koneksi';
      throw Exception(errorMessage);
    } catch (e) {
      // Menangkap error umum lainnya
      throw Exception(e.toString());
    }
  }
}
