import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constant/colors.dart';

class LoadingDetection extends StatelessWidget {
  const LoadingDetection({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: TColors.primaryColor),
            const SizedBox(height: 16),
            Text(
              "Analyzing Images...",
              style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please do not leave this page",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
