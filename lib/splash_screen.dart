import 'package:flutter/material.dart';
import 'package:panoramicai/utils/constant/colors.dart';
import 'package:panoramicai/utils/constant/sizes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(TSizes.scaffoldPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_app.png', width: 150),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(
                'EmpowerMe',
                style: textTheme.headlineMedium!.copyWith(
                  color: TColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: TSizes.smallSpace),
              Text(
                'Peduli, Terhubung, Bangkit: Bersama untuk Masa Depan Lebih Baik',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium!.copyWith(
                  color: TColors.secondaryText,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const SizedBox(
                width: 150,
                child: LinearProgressIndicator(color: TColors.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
