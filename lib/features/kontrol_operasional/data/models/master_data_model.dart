class MasterDataResponse {
  final List<CheckParameterModel> checkParameters;
  final List<AfdelingModel> afdelings;
  final List<BlokModel> bloks;
  final List<BarisSampelModel> barisSampels;
  final List<TitikSampelModel> titikSampels;
  final List<PerusahaanModel> perusahaans;
  final List<SeranganModel> serangans;

  MasterDataResponse({
    required this.checkParameters,
    required this.afdelings,
    required this.bloks,
    required this.barisSampels,
    required this.titikSampels,
    required this.perusahaans,
    required this.serangans,
  });

  factory MasterDataResponse.fromJson(Map<String, dynamic> json) {
    return MasterDataResponse(
      checkParameters: (json['check_parameters'] as List?)
              ?.map((e) => CheckParameterModel.fromJson(e))
              .toList() ??
          [],
      afdelings: (json['afdelings'] as List?)
              ?.map((e) => AfdelingModel.fromJson(e))
              .toList() ??
          [],
      bloks: (json['bloks'] as List?)
              ?.map((e) => BlokModel.fromJson(e))
              .toList() ??
          [],
      barisSampels: (json['baris_sampels'] as List?)
              ?.map((e) => BarisSampelModel.fromJson(e))
              .toList() ??
          [],
      titikSampels: (json['titik_sampels'] as List?)
              ?.map((e) => TitikSampelModel.fromJson(e))
              .toList() ??
          [],
      perusahaans: (json['perusahaans'] as List?)
              ?.map((e) => PerusahaanModel.fromJson(e))
              .toList() ??
          [],
      serangans: (json['serangans'] as List?)
              ?.map((e) => SeranganModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CheckParameterModel {
  final int id;
  final String category;
  final String parameterName;
  final bool isActive;

  CheckParameterModel(
      {required this.id,
      required this.category,
      required this.parameterName,
      required this.isActive});

  factory CheckParameterModel.fromJson(Map<String, dynamic> json) =>
      CheckParameterModel(
        id: json['id'] ?? 0,
        category: json['category'] ?? '',
        parameterName: json['parameter_name'] ?? '',
        isActive: json['is_active'] == true || json['is_active'] == 1,
      );
}

class AfdelingModel {
  final int id;
  final String name;

  AfdelingModel({required this.id, required this.name});

  factory AfdelingModel.fromJson(Map<String, dynamic> json) => AfdelingModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );
}

class BlokModel {
  final int id;
  final String name;
  final int afdelingId;

  BlokModel({required this.id, required this.name, required this.afdelingId});

  factory BlokModel.fromJson(Map<String, dynamic> json) => BlokModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        afdelingId: json['afdeling_id'] ?? 0,
      );
}

class BarisSampelModel {
  final int id;
  final String name;
  final int blokId;

  BarisSampelModel(
      {required this.id, required this.name, required this.blokId});

  factory BarisSampelModel.fromJson(Map<String, dynamic> json) =>
      BarisSampelModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        blokId: json['blok_id'] ?? 0,
      );
}

class TitikSampelModel {
  final int id;
  final String name;
  final int barisSampelId;

  TitikSampelModel(
      {required this.id, required this.name, required this.barisSampelId});

  factory TitikSampelModel.fromJson(Map<String, dynamic> json) =>
      TitikSampelModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        barisSampelId: json['baris_sampel_id'] ?? 0,
      );
}

class PerusahaanModel {
  final int id;
  final String name;

  PerusahaanModel({required this.id, required this.name});

  factory PerusahaanModel.fromJson(Map<String, dynamic> json) =>
      PerusahaanModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );
}

class SeranganModel {
  final int id;
  final String name;

  SeranganModel({required this.id, required this.name});

  factory SeranganModel.fromJson(Map<String, dynamic> json) => SeranganModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );
}
