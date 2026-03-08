import 'package:flutter/material.dart';
import 'package:sawit/features/home/presentation/pages/dashboard_view.dart';
import 'package:sawit/features/kontrol_operasional/presentation/pages/list_kontrol_operasional_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Fungsi untuk mengubah tab dari dalam halaman anak (misal: diklik dari dashboard)
  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman (komponen) yang akan di-render di dalam template
    final List<Widget> pages = [
      DashboardView(onNavigateTab: _changeTab),
      const ListKontrolOperasionalView(),
      const Center(child: Text('Halaman Chart')),
      const Center(child: Text('Halaman Profil')),
    ];

    return Scaffold(
      // IndexedStack merender halaman sesuai index dan menyimpan state-nya
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),

      // Bottom Navigation Bar murni dikontrol dari sini
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changeTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2CB887),
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_drive_file), label: 'Doc'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: 'Chart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
