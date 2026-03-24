import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/pilih_deteksi_screen.dart';
import 'package:panoramicai/features/histori_deteksi/presentations/screens/history_deteksi_screen.dart';
import 'package:panoramicai/features/home/presentations/screens/home_screen.dart';
import 'package:panoramicai/features/profile/presentations/screens/profile_screen.dart'; // Pastikan path ini benar
import 'package:panoramicai/utils/constant/colors.dart';

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    const HomeScreen(),
    const PilihDeteksiScreen(),
    const HistoryDeteksiScreen(),
    const ProfileScreen(), // Menambahkan layar profil
  ];
}

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      extendBody: true, // Membuat body berada di belakang navbar agar efek transparan terlihat
      backgroundColor: TColors.backgroundColor,
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20), // Memberikan jarak agar terlihat melayang
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: TColors.primaryColor.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: FontAwesomeIcons.house,
                    activeIcon: FontAwesomeIcons.houseUser,
                    label: 'Home',
                    index: 0,
                    controller: controller,
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.stethoscope,
                    activeIcon: FontAwesomeIcons.stethoscope,
                    label: 'Deteksi',
                    index: 1,
                    controller: controller,
                    isSpecial: true, // Memberikan penekanan pada tombol deteksi
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.clockRotateLeft,
                    activeIcon: FontAwesomeIcons.clockRotateLeft,
                    label: 'History',
                    index: 2,
                    controller: controller,
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.user,
                    activeIcon: FontAwesomeIcons.userCheck,
                    label: 'Profil',
                    index: 3,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required NavigationController controller,
    bool isSpecial = false,
  }) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      final color = isSelected ? TColors.primaryColor : Colors.grey.shade400;

      if (isSpecial) {
        return GestureDetector(
          onTap: () => controller.selectedIndex.value = index,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? TColors.primaryColor : TColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: TColors.primaryColor.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ]
                  : [],
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.white : TColors.primaryColor,
              size: 24,
            ),
          ),
        );
      }

      return InkWell(
        onTap: () => controller.selectedIndex.value = index,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 4,
                width: 4,
                decoration: const BoxDecoration(
                  color: TColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      );
    });
  }
}
