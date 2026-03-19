import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as time;
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';
import 'package:panoramicai/features/deteksi/data/models/detection_result.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';
import 'package:panoramicai/utils/constant/colors.dart';
import 'package:panoramicai/utils/constant/sizes.dart';

class DeteksiScreen extends GetView<DeteksiController> {
  final DeteksiType type;

  const DeteksiScreen({super.key, required this.type});

  void _showFullScreenImage(BuildContext context, Size imageSize) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            InteractiveViewer(
              maxScale: 7.0,
              minScale: 0.5,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double screenAspectRatio =
                        constraints.maxWidth / constraints.maxHeight;
                    final double imageAspectRatio =
                        imageSize.width / imageSize.height;

                    double drawWidth, drawHeight;
                    if (imageAspectRatio > screenAspectRatio) {
                      drawWidth = constraints.maxWidth;
                      drawHeight = drawWidth / imageAspectRatio;
                    } else {
                      drawHeight = constraints.maxHeight;
                      drawWidth = drawHeight * imageAspectRatio;
                    }

                    return Stack(
                      children: [
                        Image.file(
                          controller.selectedImage.value!,
                          width: drawWidth,
                          height: drawHeight,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          width: drawWidth,
                          height: drawHeight,
                          child: CustomPaint(
                            painter: DetectionPainter(
                              detections: controller.detections,
                              imageSize: imageSize,
                              type: type,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tanggalSekarang = time.DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          type == DeteksiType.numbering ? "Numbering Gigi" : "Karies Gigi",
          style: textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: TColors.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: TColors.primaryColor,
        elevation: 0,
      ),
      backgroundColor: TColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  if (controller.selectedImage.value == null) {
                    return const Text("Tidak ada gambar yang dipilih");
                  }

                  if (controller.imageWidth.value == 0 ||
                      controller.imageHeight.value == 0) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final Size imageSize = Size(
                    controller.imageWidth.value.toDouble(),
                    controller.imageHeight.value.toDouble(),
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final double imageAspectRatio =
                                  imageSize.width / imageSize.height;
                              double drawWidth = constraints.maxWidth;
                              double drawHeight = drawWidth / imageAspectRatio;

                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      controller.selectedImage.value!,
                                      width: drawWidth,
                                      height: drawHeight,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  if (!controller.isLoading.value &&
                                      controller.detections.isNotEmpty)
                                    SizedBox(
                                      width: drawWidth,
                                      height: drawHeight,
                                      child: CustomPaint(
                                        painter: DetectionPainter(
                                          detections: controller.detections,
                                          imageSize: imageSize,
                                          type: type,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () =>
                                  _showFullScreenImage(context, imageSize),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Lihat Gambar",
                                      style: textTheme.labelMedium,
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.open_in_full, size: 14),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.mediumSpace),
                      Text(
                        tanggalSekarang,
                        style: textTheme.bodySmall!.copyWith(
                          color: Colors.blueGrey,
                        ),
                      ),
                      if (type == DeteksiType.caries &&
                          controller.detections.isNotEmpty &&
                          !controller.isLoading.value) ...[
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
                              'Terindikasi Karies',
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
                            'Detail Deskripsi',
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const CariesDescriptionTable(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Rencana Perawatan',
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        const TreatmentPlanList(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Referensi Klinis',
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
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
                                      'Rumah Sakit Universitas Hasanuddin',
                                      style: textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: TSizes.smallSpace),
                              Text(
                                'Jl. Perintis Kemerdekaan No.Km. 10, Tamalanrea, Kec. Tamalanrea, Kota Makassar, Sulawesi Selatan 90245',
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ] else if (type == DeteksiType.caries &&
                          controller.detections.isEmpty &&
                          !controller.isLoading.value) ...[
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Container(
                          width: 240,
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
                              'Tidak Terindikasi Karies',
                              style: textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: TSizes.spaceBtwSections),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: TColors.primaryColor),
                ),
                onPressed: () {},
                child: Text(
                  'Batal',
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TColors.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwSections,),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryColor
                ),
                onPressed: () {},
                child: Text(
                  'Simpan',
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CariesDescriptionTable extends StatelessWidget {
  const CariesDescriptionTable({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.5), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Table(
          border: TableBorder(
            verticalInside: BorderSide(
              color: Colors.black.withOpacity(0.5),
              width: 0.5,
            ),
            horizontalInside: BorderSide(
              color: Colors.black.withOpacity(0.5),
              width: 0.5,
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                _buildCell(
                  'RA\nInitial Stage',
                  isHeader: true,
                  textTheme: textTheme,
                ),
                _buildCell(
                  'RB\nModerate Stage',
                  isHeader: true,
                  textTheme: textTheme,
                ),
                _buildCell(
                  'RC\nExtensive Stage',
                  isHeader: true,
                  textTheme: textTheme,
                ),
              ],
            ),
            TableRow(
              children: [
                _buildCell(
                  'Radiolucency in the enamel ± EDJ (enamel–dentin junction)',
                  textTheme: textTheme,
                ),
                _buildCell(
                  'Radiolucency in the outer or middle 1/3 of dentin',
                  textTheme: textTheme,
                ),
                _buildCell(
                  'Radiolucency in the inner 1/3 of dentin or into the pulp',
                  textTheme: textTheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    bool isHeader = false,
    required TextTheme textTheme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: textTheme.bodySmall!.copyWith(
          fontSize: 10,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: Colors.black,
        ),
      ),
    );
  }
}

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

class DetectionPainter extends CustomPainter {
  final List<DetectionResult> detections;
  final Size imageSize;
  final DeteksiType type;

  DetectionPainter({
    required this.detections,
    required this.imageSize,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    for (var det in detections) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = det.color;

      final rect = Rect.fromLTRB(
        det.box.left * scaleX,
        det.box.top * scaleY,
        det.box.right * scaleX,
        det.box.bottom * scaleY,
      );

      canvas.drawRect(rect, paint);

      if (type == DeteksiType.numbering) {
        final numSpan = TextSpan(
          text: det.className,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        );
        final numPainter = TextPainter(
          text: numSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        final numOffset = Offset(
          rect.left + (rect.width - numPainter.width) / 2,
          rect.top + (rect.height - numPainter.height) / 2,
        );
        numPainter.paint(canvas, numOffset);
      } else {
        String labelText = "${det.className} ${det.score.toStringAsFixed(2)}";
        final textSpan = TextSpan(
          text: labelText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        final labelBgRect = Rect.fromLTWH(
          rect.left,
          rect.top - textPainter.height - 2,
          textPainter.width + 4,
          textPainter.height + 2,
        );
        canvas.drawRect(labelBgRect, Paint()..color = det.color);
        textPainter.paint(
          canvas,
          Offset(rect.left + 2, rect.top - textPainter.height - 1),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DetectionPainter oldDelegate) => true;
}
