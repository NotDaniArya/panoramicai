import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/button_deteksi.dart';
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';

class LapisanBawah extends StatelessWidget {
  final DeteksiType type;
  const LapisanBawah({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonDeteksi(
                label: 'Camera',
                icon: Icons.camera_alt,
                isPrimary: true,
                type: type,
              ),
              ButtonDeteksi(
                label: 'Gallery',
                icon: Icons.photo_library,
                isPrimary: false,
                isCamera: false,
                type: type,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
