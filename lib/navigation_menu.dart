import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/deteksi_screen.dart';
import 'package:panoramicai/features/home/presentation/screens/home_screen.dart';
import 'package:panoramicai/utils/constant/colors.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0; // State untuk melacak tab yang aktif

  static final List<Widget> _listMenu = [
    // const HomeScreen(),
    const HomeScreen(),
    const DeteksiScreen(),
    Container(),
  ];

  void _onSelectedMenu(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      // extendBody: true, // Membuat body bisa berada di belakang navbar
      body: _listMenu[_selectedIndex],

      // 3. Gunakan BottomAppBar, bukan BottomNavigationBar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Anda bisa atur warna bar di sini
          boxShadow: [
            BoxShadow(
              // Atur warna dan transparansi bayangan
              color: Colors.black.withOpacity(0.18),
              // Atur tingkat blur
              blurRadius: 20,
              // Atur seberapa menyebar bayangannya
              spreadRadius: 5,
              // KUNCI UTAMA: Atur posisi bayangan (x, y)
              // Nilai y negatif berarti bayangan akan bergeser ke atas
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,

          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Item Navigasi di Kiri
              _buildNavItem(
                icon: FontAwesomeIcons.home,
                label: 'Dashboard ',
                index: 0,
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.stethoscope,
                label: 'Deteksi',
                index: 1,
              ),

              // Item Navigasi di Kanan
              _buildNavItem(
                icon: FontAwesomeIcons.clockRotateLeft,
                label: 'Rekam Medis',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk membuat setiap item navigasi agar kode tidak berulang
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Colors.black : Colors.grey;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => _onSelectedMenu(index),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.labelSmall!.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
