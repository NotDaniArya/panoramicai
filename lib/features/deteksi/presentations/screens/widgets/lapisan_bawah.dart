import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/button_deteksi.dart';

class LapisanBawah extends StatelessWidget {
  const LapisanBawah({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadiusGeometry.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsetsGeometry.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonDeteksi(
                label: 'Camera',
                icon: Icons.camera_alt,
                isPrimary: true,
              ),
              ButtonDeteksi(
                label: 'Gallery',
                icon: Icons.add,
                isPrimary: false,
                isCamera: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
