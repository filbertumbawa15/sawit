import 'package:dio/dio.dart';
import 'package:sawit/features/kontrol_operasional/data/models/form_submit_h0_param.dart';
import 'package:sawit/features/kontrol_operasional/data/models/kontrol_operasional_model.dart';
import 'package:sawit/features/kontrol_operasional/data/models/master_data_model.dart';

class KontrolOperasionalDataSource {
  final Dio dio;

  KontrolOperasionalDataSource({required this.dio});

  Future<List<KontrolOperasionalModel>> fetchListKontrol({int page = 1}) async {
    try {
      final response = await dio.get(
        '/api/operational-controls',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawData = response.data['data']['data'];
        return rawData
            .map((json) => KontrolOperasionalModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Gagal mengambil data dari server');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan koneksi';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<MasterDataResponse> getMasterData() async {
    try {
      final response = await dio.get('/api/operational-controls/master-data');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return MasterDataResponse.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Gagal mengambil data master');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan koneksi ke server.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> submitFormH0(SubmitFormH0Param param) async {
    try {
      var formData = FormData();

      // Header Data
      formData.fields.addAll([
        MapEntry('perusahaan_id', param.perusahaanId.toString()),
        const MapEntry('status', 'H+0'),
      ]);

      if (param.notes != null && param.notes!.isNotEmpty) {
        formData.fields.add(MapEntry('notes', param.notes!));
      }

      // Details Array
      formData.fields.addAll([
        MapEntry('details[0][afdeling_id]', param.afdelingId.toString()),
        MapEntry('details[0][blok_id]', param.blokId.toString()),
        MapEntry('details[0][baris_sampel_id]', param.bsId.toString()),
        MapEntry('details[0][titik_sampel_id]', param.tsId.toString()),
      ]);

      if (param.seranganId != null) {
        formData.fields.add(
            MapEntry('details[0][serangan_id]', param.seranganId.toString()));
      }

      // Looping APD
      int apdIndex = 0;
      param.apdItems.forEach((id, isChecked) {
        formData.fields.addAll([
          MapEntry('apd_items[$apdIndex][parameter_id]', id.toString()),
          MapEntry('apd_items[$apdIndex][is_checked]', isChecked ? '1' : '0'),
        ]);
        apdIndex++;
      });

      // Looping Alat Kerja
      int alatIndex = 0;
      param.alatKerjaItems.forEach((id, isChecked) {
        formData.fields.addAll([
          MapEntry('alat_kerja_items[$alatIndex][parameter_id]', id.toString()),
          MapEntry('alat_kerja_items[$alatIndex][is_checked]',
              isChecked ? '1' : '0'),
        ]);
        alatIndex++;
      });

      // Looping Lampiran Gambar (MultipartFile)
      for (int i = 0; i < param.images.length; i++) {
        formData.files.add(MapEntry(
          'lampiran[]',
          await MultipartFile.fromFile(param.images[i].path,
              filename: 'foto_inspeksi_$i.jpg'),
        ));
      }

      // Eksekusi API
      final response = await dio.post(
        '/api/operational-controls',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Gagal menyimpan data');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        print('Validasi gagal: ${e.response?.data['errors']}');
        throw Exception(e.response?.data['message'] ?? 'Kesalahan koneksi.');
      } else {
        final errorMessage = e.response?.data['message'] ??
            'Terjadi kesalahan koneksi ke server.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
