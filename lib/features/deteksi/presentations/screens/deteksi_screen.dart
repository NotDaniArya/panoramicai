import 'package:flutter/material.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/background_image.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/deteksi_appbar.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/lapisan_bawah.dart';

class DeteksiScreen extends StatelessWidget {
  const DeteksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Column(children: [DeteksiAppbar(), Spacer(), LapisanBawah()]),
        ],
      ),
    );
  }
}
