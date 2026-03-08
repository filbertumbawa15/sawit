import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sawit/core/utils/date_extension.dart';
import 'package:sawit/features/kontrol_operasional/presentation/bloc/kontroloperasional_bloc.dart';

class ListKontrolOperasionalView extends StatefulWidget {
  const ListKontrolOperasionalView({super.key});

  @override
  State<ListKontrolOperasionalView> createState() =>
      _ListKontrolOperasionalViewState();
}

class _ListKontrolOperasionalViewState
    extends State<ListKontrolOperasionalView> {
  @override
  void initState() {
    super.initState();
    context.read<KontrolOperasionalBloc>().add(FetchListKontrol());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // 1. APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF2CB887),
        elevation: 0,
        centerTitle: true,
        // Tombol Back (leading) DIHAPUS agar tidak bentrok dengan routing Tab
        automaticallyImplyLeading: false,
        title: const Text(
          'List Kontrol Operasional',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),

      // 2. BODY (LIST VIEW)
      body: BlocBuilder<KontrolOperasionalBloc, KontrolOperasionalState>(
        builder: (context, state) {
          if (state is KontrolOperasionalLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is KontrolOperasionalError) {
            return Center(child: Text('Gagal memuat: ${state.message}'));
          }

          if (state is KontrolOperasionalLoaded) {
            final listData = state.data;

            if (listData.isEmpty) {
              return const Center(child: Text('Tidak ada data operasional.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: listData.length,
              itemBuilder: (context, index) {
                return _buildCardItem(listData[index]);
              },
            );
          }

          return const Center(child: Text('Memuat data...'));
        },
      ),

      // BottomNavigationBar SUDAH DIHAPUS DARI SINI
    );
  }

  // WIDGET UNTUK CARD ITEM
  Widget _buildCardItem(Map<String, dynamic> data) {
    final status = data['status'] ?? 'H+0';
    final badgeBgColor =
        status == 'H+0' ? const Color(0xFFFDF3E8) : const Color(0xFFE0F5E9);
    final badgeTextColor =
        status == 'H+0' ? const Color(0xFFE88A1A) : const Color(0xFF16A55C);
    final String rawDate = data['created_at'] ?? '';
    final String formattedDate = rawDate.toIndoDateTime();

    final List<dynamic> details = data['details'] ?? [];

    List<dynamic> lampiranList = [];
    if (data['lampiran'] != null) {
      try {
        lampiranList = jsonDecode(data['lampiran']);
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TANGGAL
          Text(
            formattedDate,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // List Afdeling & Blok
              Expanded(
                child: Wrap(
                  spacing: 24, // Jarak antar afdeling
                  children: details.map((detail) {
                    final afdelingName =
                        detail['afdeling']?['afdeling_name'] ?? '-';
                    final blokName = detail['blok']?['blok_name'] ?? '-';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          afdelingName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          blokName,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              // Badge (H+1 / H+0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),

          // BARIS DETAIL (Kelengkapan APD, Alat Kerja, Baris Sampel)
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _buildDetailInfo('Kelengkapan APD', data['apd_status'] ?? '-'),
              _buildDetailInfo('Alat Kerja', data['alat_kerja_status'] ?? '-'),

              // Looping untuk Baris Sampel jika ada di array details
              ...details.map((detail) {
                final barisSampel =
                    detail['baris_sampel']?['baris_sampel_code'] ?? '-';
                return _buildDetailInfo('Baris Sampel', barisSampel);
              }),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),

          // BARIS GAMBAR (LAMPIRAN)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: lampiranList.isEmpty
                  ? [
                      _buildImagePlaceholder()
                    ] // Jika tidak ada foto, tampilkan icon abu-abu
                  : lampiranList.map((lampiranPath) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildImageNetwork(
                            'http://10.0.2.2:8050/storage/$lampiranPath'),
                      );
                    }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER UNTUK GAMBAR PLACEHOLDER KOTAK ABU-ABU
  Widget _buildDetailInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        Icons.image,
        color: Colors.grey.shade400,
        size: 30,
      ),
    );
  }

  // WIDGET HELPER UNTUK MENAMPILKAN GAMBAR ASLI DARI BACKEND
  Widget _buildImageNetwork(String imageUrl) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildImagePlaceholder(),
        ),
      ),
    );
  }
}
