import 'dart:convert';

class KontrolOperasionalModel {
  final int id;
  final String status;
  final String? notes;
  final String createdAt;
  final String apdStatus;
  final String alatKerjaStatus;
  final List<String> lampiran;
  final List<DetailModel> details;

  KontrolOperasionalModel({
    required this.id,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.apdStatus,
    required this.alatKerjaStatus,
    required this.lampiran,
    required this.details,
  });

  factory KontrolOperasionalModel.fromJson(Map<String, dynamic> json) {
    // Parsing string JSON lampiran menjadi List<String> yang aman
    List<String> parsedLampiran = [];
    if (json['lampiran'] != null) {
      try {
        parsedLampiran = List<String>.from(jsonDecode(json['lampiran']));
      } catch (_) {}
    }

    return KontrolOperasionalModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? 'H+0',
      notes: json['notes'],
      createdAt: json['created_at'] ?? '',
      apdStatus: json['apd_status'] ?? 'Tidak Lengkap',
      alatKerjaStatus: json['alat_kerja_status'] ?? 'Tidak Lengkap',
      lampiran: parsedLampiran,
      // Mapping array details
      details: (json['details'] as List?)
              ?.map((item) => DetailModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class DetailModel {
  final String afdelingName;
  final String blokName;
  final String barisSampelCode;
  final String titikSampelCode;
  final String luasTanah;
  final List<ChecklistModel> apdChecklist;
  final List<ChecklistModel> alatKerjaChecklist;

  DetailModel({
    required this.afdelingName,
    required this.blokName,
    required this.barisSampelCode,
    required this.titikSampelCode,
    required this.luasTanah,
    required this.apdChecklist,
    required this.alatKerjaChecklist,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      // Menggunakan operator ? agar aman jika relasi dari backend null
      afdelingName: json['afdeling']?['afdeling_name'] ?? '-',
      blokName: json['blok']?['blok_name'] ?? '-',
      luasTanah: json['blok']?['luas_ha_baku'] ?? '-',
      barisSampelCode: json['baris_sampel']?['baris_sampel_code'] ?? '-',
      titikSampelCode: json['titik_sampel']?['sample_point_code'] ?? '-',
      // Mapping checklist dinamis dari backend
      apdChecklist: (json['apd_checklist'] as List?)
              ?.map((item) => ChecklistModel.fromJson(item))
              .toList() ??
          [],
      alatKerjaChecklist: (json['alat_kerja_checklist'] as List?)
              ?.map((item) => ChecklistModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ChecklistModel {
  final int id;
  final String parameterName;
  final bool isChecked;

  ChecklistModel({
    required this.id,
    required this.parameterName,
    required this.isChecked,
  });

  factory ChecklistModel.fromJson(Map<String, dynamic> json) {
    return ChecklistModel(
      id: json['id'] ?? 0,
      parameterName: json['parameter_name'] ?? '-',
      isChecked: json['is_checked'] ?? false,
    );
  }
}
