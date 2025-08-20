import 'package:flutter/material.dart';
import 'package:panoramicai/features/home/presentation/screens/widgets/chart_card_jenis_kerusakan.dart';
import 'package:panoramicai/features/home/presentation/screens/widgets/chart_card_jumlah_deteksi.dart';
import 'package:panoramicai/utils/constant/images.dart';
import 'package:panoramicai/utils/constant/sizes.dart';
import 'package:panoramicai/utils/shared_widgets/button.dart';
import 'package:panoramicai/utils/shared_widgets/information_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_app.png', width: 40, height: 40),
            const SizedBox(width: TSizes.smallSpace),
            Text('Panoramic AI', style: textTheme.titleMedium),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: TSizes.mediumSpace),
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: TSizes.scaffoldPadding),
              child: const InformationSlider(
                imageList: MyImages.homeImageTopList,
                isHaveInformation: false,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.scaffoldPadding,
              ).copyWith(bottom: TSizes.scaffoldPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Analisis Deteksi',
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.smallSpace),
                  const Row(
                    children: [
                      Expanded(child: ChartCardJenisKerusakan()),
                      Expanded(child: ChartCardJumlahDeteksi()),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: 250,
                    child: MyButton(text: 'Mulai Analisis', onPressed: () {}),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Jenis Kerusakan',
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: TSizes.scaffoldPadding),
                    child: const InformationSlider(
                      imageList: MyImages.homeImageBotList,
                      isHaveInformation: false,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
