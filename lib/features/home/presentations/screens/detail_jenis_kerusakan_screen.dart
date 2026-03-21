import 'package:flutter/material.dart';
import 'package:panoramicai/utils/constant/sizes.dart';

class DetailJenisKerusakanScreen extends StatelessWidget {
  const DetailJenisKerusakanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Karies Gigi', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/image_home_bot1.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsetsGeometry.all(TSizes.scaffoldPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Deskripsi',
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.smallSpace),
                  Text(
                    'Karies gigi adalah masalah gigi berlubang, yaitu ketika gigi mengalami kerusakan serta pembusukan di bagian luar dan dalam. Kondisi ini merupakan permasalahan gigi yang dapat menyerang saraf, sering kali karies gigi disebabkan oleh aktivitas bakteri Streptococcus mutans di dalam mulut.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Text(
                    'ICD Code',
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'XXXXXXXXXX010101',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Text(
                    'Literatur Medis',
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '- XXXXXXXXXX010101',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    '- XXXXXXXXXX010101',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
