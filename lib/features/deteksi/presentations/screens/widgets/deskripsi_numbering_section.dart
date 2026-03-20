import 'package:flutter/material.dart';

import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/constant/texts.dart';

class DeskripsiNumberingSection extends StatelessWidget {
  const DeskripsiNumberingSection({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: TSizes.spaceBtwItems),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Detail Deskripsi',
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),
        _Description(
          title: 'Gigi Permanen',
          description: TTexts.descGigiPermanent,
          color: const Color(0xFFFF1493),
        ),
        _Description(
          title: 'Gigi Sulung',
          description: TTexts.descGigiSulung,
          color: const Color(0xFFFFA500),
        ),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const _Description({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(description, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
