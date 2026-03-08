import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../injection.dart' as di;

class DashboardView extends StatefulWidget {
  // Tambahan: Callback untuk memberi tahu MainScreen agar memindahkan tab
  final Function(int) onNavigateTab;

  const DashboardView({super.key, required this.onNavigateTab});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // Variabel untuk menampung data dari backend
  String userName = 'Loading...';
  String userEmail = 'Loading...';
  String userNpk = '-';
  String userJabatan = '-';

  // _currentIndex sudah dihapus karena state BottomNavigationBar ada di MainScreen

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = di.sl<SharedPreferences>();
    final userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      setState(() {
        userName = userData['name'] ?? 'User';
        userEmail = userData['email'] ?? 'email@domain.com';
        userNpk = userData['npk']?.toString() ?? '-';
        if (userData['jabatan'] != null && userData['jabatan'] is Map) {
          userJabatan = userData['jabatan']['nama_jabatan'] ?? '-';
        } else {
          userJabatan = '-';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F9FA), // Warna background abu-abu sangat muda

      // 1. APP BAR CUSTOM
      appBar: AppBar(
        backgroundColor: const Color(0xFF2CB887), // Hijau sesuai desain
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'Nunito',
            fontSize: 16.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
        // Membuat lengkungan di bawah AppBar
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),

      // 2. BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildMenuGrid(),
          ],
        ),
      ),

      // BottomNavigationBar SUDAH DIHAPUS DARI SINI
    );
  }

  // --- WIDGET PROFIL ---
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFFD1F2E6), // Hijau pastel
            child:
                Container(), // Bisa diganti NetworkImage kalau ada foto profil
          ),
          const SizedBox(height: 16),

          // Nama User
          Text(
            userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),

          // Kotak Detail (NPK, Email, Jabatan)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F6), // Abu-abu terang
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildDetailRow('NPK:', userNpk),
                const Divider(height: 24, color: Colors.black12),
                _buildDetailRow('Email:', userEmail),
                const Divider(height: 24, color: Colors.black12),
                _buildDetailRow('Jabatan:', userJabatan),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk baris detail
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGET MENU ---
  Widget _buildMenuGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              // PERUBAHAN: Menambahkan Material & InkWell agar tombol bisa diklik
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // Memicu perubahan tab ke index 1 (Doc) di MainScreen
                    widget.onNavigateTab(1);
                  },
                  child: _buildMenuCard(
                    title: 'Kontrol\nOperasional',
                    icon: Icons.receipt_long_outlined,
                    iconColor: Colors.blueAccent,
                    bgColor: Colors.blue.withOpacity(0.1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMenuCard(
                title: 'Planning Early\nWarning System',
                icon: Icons.calendar_month_outlined,
                iconColor: Colors.orange,
                bgColor: Colors.orange.withOpacity(0.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Menu Setting ditengah bawah
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: _buildMenuCard(
            title: 'Settings',
            icon: Icons.monetization_on_outlined,
            iconColor: Colors.purpleAccent,
            bgColor: Colors.purple.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  // Helper untuk membungkus tiap tombol menu
  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A4A4A),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
