import 'package:flutter/material.dart';
import 'package:panoramicai/utils/constant/sizes.dart';

class DeteksiAppbar extends StatelessWidget implements PreferredSizeWidget {
  const DeteksiAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 90,
          foregroundDecoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: TSizes.spaceBtwSections,
          ),
          child: Text(
            'Deteksi',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.1);
}
