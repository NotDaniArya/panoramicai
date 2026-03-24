import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panoramicai/utils/constant/colors.dart';
import 'package:panoramicai/utils/constant/sizes.dart';

import 'features/onboarding/onboarding_screen.dart';
import 'navigation_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  Future<void> _checkUserSession() async {
    await Future.delayed(const Duration(seconds: 3));

    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      Get.offAll(() => const NavigationMenu());
    } else {
      Get.offAll(() => const OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(TSizes.scaffoldPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_app.png', width: 280),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(
                'Panoramic AI',
                style: textTheme.headlineSmall!.copyWith(
                  color: TColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
