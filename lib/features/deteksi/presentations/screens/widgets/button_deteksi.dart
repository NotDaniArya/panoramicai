import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panoramicai/utils/constant/colors.dart';
import 'package:get/get.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/deteksi_screen.dart';

class ButtonDeteksi extends StatelessWidget {
  const ButtonDeteksi({
    super.key,
    required this.label,
    required this.icon,
    this.isPrimary = false,
    this.isCamera = true,
    required this.type,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isCamera;
  final DeteksiType type;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DeteksiController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: TColors.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            await controller.pickImage(
              isCamera ? ImageSource.camera : ImageSource.gallery,
              type,
            );
            if (controller.selectedImage.value != null) {
              Get.to(() => DeteksiScreen(type: type));
            }
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isPrimary ? TColors.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: isPrimary ? null : Border.all(color: TColors.primaryColor, width: 3),
            ),
            child: Icon(
              icon,
              color: isPrimary ? Colors.white : TColors.primaryColor,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
