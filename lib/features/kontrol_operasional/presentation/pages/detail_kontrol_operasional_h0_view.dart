import 'package:flutter/material.dart';
import 'package:sawit/core/utils/date_extension.dart';
import 'package:sawit/features/kontrol_operasional/data/models/kontrol_operasional_model.dart';
import '../widgets/stat_card.dart';
import '../widgets/info_item.dart';
import '../widgets/readonly_checkbox_item.dart';
import '../widgets/detail_image_card.dart';

class DetailKontrolOperasionalH0View extends StatelessWidget {
  final KontrolOperasionalModel data;

  const DetailKontrolOperasionalH0View({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Parsing Data Khusus H+0
    final status = data.status;
    final List<DetailModel> details = data.details;
    final DetailModel firstDetail = details[0];

    final afdelingName = firstDetail.afdelingName;
    final blokName = firstDetail.blokName;
    final barisSampel = firstDetail.barisSampelCode;
    final titikSampel = firstDetail.titikSampelCode;

    final luasTanah = firstDetail.luasTanah;
    final String rawDate = data.createdAt;
    final String formattedDate = rawDate.toIndoDateTime();

    List<dynamic> lampiranList = data.lampiran;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2CB887),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Kontrol (H+0)',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jenis Validasi Kontrol',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                    child: StatCard(
                        icon: Icons.map_outlined, value: '0.35', unit: 'Km')),
                SizedBox(width: 16),
                Expanded(
                    child: StatCard(
                        icon: Icons.directions_walk,
                        value: '350',
                        unit: 'Langkah')),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Informasi Detail H+0',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoItem(label: 'Jenis Afdeling', value: afdelingName),
                      InfoItem(label: 'Blok', value: blokName),
                      InfoItem(label: 'Baris Sampel', value: barisSampel),
                      InfoItem(label: 'Titik Sampel', value: titikSampel),
                      InfoItem(label: 'Kelebaran Tanah', value: luasTanah),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Kelengkapan Alat Kerja :',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...firstDetail.alatKerjaChecklist.map((item) =>
                          ReadOnlyCheckboxItem(
                              label: item.parameterName,
                              isChecked: item.isChecked)),
                      const SizedBox(height: 16),
                      const Text('Kelengkapan APD :',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...firstDetail.apdChecklist.map((item) =>
                          ReadOnlyCheckboxItem(
                              label: item.parameterName,
                              isChecked: item.isChecked)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InfoItem(label: 'Tanggal/Jam Pengecekan', value: formattedDate),
            const SizedBox(height: 24),
            const Text('Lampiran Gambar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: lampiranList.isEmpty
                    ? const [
                        DetailImageCard(imageUrl: null, size: 100)
                      ] // Memanggil placeholder
                    : lampiranList
                        .map((path) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: DetailImageCard(
                                imageUrl:
                                    'http://192.168.1.100:8000/storage/$path',
                                size: 100,
                              ),
                            ))
                        .toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
