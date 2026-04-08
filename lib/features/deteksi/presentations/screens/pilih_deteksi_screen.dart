import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/background_image.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/button_deteksi.dart';
import 'package:panoramicai/utils/constant/colors.dart';

class PilihDeteksiScreen extends StatelessWidget {
  const PilihDeteksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeteksiController());

    return Scaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  const BackgroundImage(),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            "Select Type\nTooth Detection",
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: TColors.primaryColor,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Select one of the types of detection below to begin the analysis of your dental X-rays.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          _buildServiceCard(
                            context,
                            title: "Tooth Numbering",
                            subtitle:
                                "Identify the positions and numbers of the permanent and deciduous teeth.",
                            icon: Icons.format_list_numbered,
                            type: DeteksiType.numbering,
                          ),
                          const SizedBox(height: 16),
                          _buildServiceCard(
                            context,
                            title: "Caries Detection",
                            subtitle:
                                "Early detection of dental caries (dentin, enamel, pulp, root remnants).",
                            icon: Icons.biotech,
                            type: DeteksiType.caries,
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required DeteksiType type,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: TColors.primaryColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonDeteksi(
                label: "Gallery",
                icon: Icons.photo_library,
                isPrimary: false,
                isCamera: false,
                type: type,
              ),
              ButtonDeteksi(
                label: "Camera",
                icon: Icons.camera_alt,
                isPrimary: true,
                isCamera: true,
                type: type,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
