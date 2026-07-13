import 'dart:io';

class SubmitFormH0Param {
  final int perusahaanId;
  final int afdelingId;
  final int blokId;
  final int bsId;
  final int tsId;
  final int? seranganId;
  final String? notes;
  final Map<int, bool> apdItems; // Menyimpan ID checklist APD dan statusnya
  final Map<int, bool> alatKerjaItems; // Menyimpan ID checklist Alat Kerja dan statusnya
  final List<File> images;

  SubmitFormH0Param({
    required this.perusahaanId,
    required this.afdelingId,
    required this.blokId,
    required this.bsId,
    required this.tsId,
    this.seranganId,
    this.notes,
    required this.apdItems,
    required this.alatKerjaItems,
    required this.images,
  });
}