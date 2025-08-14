import 'package:flutter/material.dart';
import 'package:panoramicai/features/auth/presentation/screens/login/login_screen.dart';
import 'package:panoramicai/features/auth/presentation/screens/register/register_screen.dart';
import 'package:panoramicai/utils/constant/colors.dart';

import '../../utils/constant/sizes.dart';
import '../../utils/shared_widgets/button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFE5FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.spaceBtwSections),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Panoramic AI',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge!.copyWith(),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Image.asset(
                  'assets/images/onboarding_image.png',
                  width: 272,
                  height: 272,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(
                  width: 250,
                  child: MyButton(
                    text: 'Login',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: TSizes.smallSpace),
                Text(
                  'Belum punya akun?',
                  style: textTheme.bodyMedium!.copyWith(
                    color: TColors.secondaryText,
                  ),
                ),
                const SizedBox(height: TSizes.smallSpace),
                SizedBox(
                  width: 250,
                  child: MyButton(
                    text: 'Register',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(50),
                      ),
                    ),
                    onPressed: () {},
                    icon: Image.asset('assets/icons/google.png', width: 30),
                    label: Text(
                      'Login with Google',
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
