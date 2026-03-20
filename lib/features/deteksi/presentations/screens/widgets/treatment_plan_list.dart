import 'package:flutter/material.dart';

class TreatmentPlanList extends StatelessWidget {
  const TreatmentPlanList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TreatmentPlanItem(
          title: '1. RA (Initial Stage)',
          description:
          'Lesi terbatas pada enamel hingga outer dentin dan biasanya non-cavitated.',
          treatment:
          'Perawatan difokuskan pada tindakan preventif dan remineralisasi, seperti aplikasi fluoride, fissure sealant, peningkatan kebersihan mulut, serta edukasi diet rendah gula.',
          color: Colors.green,
        ),
        _TreatmentPlanItem(
          title: '2. RB (Moderate Stage)',
          description:
          'Lesi mencapai middle dentin dan dapat cavitated atau non-cavitated.',
          treatment:
          'Perawatan dapat berupa non-operatif (sealant, resin infiltration, kontrol plak dan fluoride) jika belum berkavitas, atau restorasi minimal invasif jika telah terjadi kavitas.',
          color: Colors.orange,
        ),
        _TreatmentPlanItem(
          title: '3. RC (Extensive Stage)',
          description:
          'Lesi mencapai inner dentin hingga mendekati pulpa dan umumnya sudah cavitated.',
          treatment:
          'Perawatan meliputi restorasi definitif, dan bila pulpa terlibat dapat dilakukan terapi pulpa seperti pulpotomi atau perawatan saluran akar sesuai kondisi klinis.',
          color: Colors.red,
        ),
      ],
    );
  }
}

class _TreatmentPlanItem extends StatelessWidget {
  final String title;
  final String description;
  final String treatment;
  final Color color;

  const _TreatmentPlanItem({
    required this.title,
    required this.description,
    required this.treatment,
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
          Text(
            description,
            style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(treatment, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}