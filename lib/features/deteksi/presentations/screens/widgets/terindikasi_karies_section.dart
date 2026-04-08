import 'package:flutter/material.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/treatment_plan_list.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import 'caries_description_table.dart';

class TerindikasiKariesSection extends StatelessWidget {
  const TerindikasiKariesSection({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: TSizes.spaceBtwItems),
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: TColors.primaryColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: TColors.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Indicated Caries',
              style: textTheme.titleMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Detailed Description',
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const CariesDescriptionTable(),
        const SizedBox(height: TSizes.spaceBtwSections),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Treatment Plan',
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        const TreatmentPlanList(),
        const SizedBox(height: TSizes.spaceBtwSections),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Clinical Reference',
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(2, 5),
              ),
            ],
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_pin),
                  const SizedBox(width: TSizes.smallSpace),
                  Expanded(
                    child: Text(
                      'RSGMP UNIVERSITAS HASANUDDIN',
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.smallSpace),
              Text(
                'Jl. Kandea No.5, Baraya, Kec. Bontoala, Kota Makassar, Sulawesi Selatan',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}