import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as time;
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/deskripsi_numbering_section.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/detection_output_image.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/loading_detection.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/terindikasi_karies_section.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/widgets/tidak_terindikasi_karies_section.dart';
import 'package:panoramicai/utils/constant/colors.dart';
import 'package:panoramicai/utils/constant/pages_routes.dart';
import 'package:panoramicai/utils/constant/sizes.dart';

class DeteksiScreen extends GetView<DeteksiController> {
  final DeteksiType type;

  const DeteksiScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final Map<String, dynamic>? args = Get.arguments;
    final bool isFromHistory = args?['isFromHistory'] ?? false;
    final String? historyImageUrl = args?['imageUrl'];

    final tanggalSekarang = time.DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return PopScope(
      canPop: true,
      child: Scaffold(
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
                  if (isFromHistory)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DetectionOutputImage(
                          imageSize: const Size(640, 640),
                          controller: controller,
                          type: type,
                          textTheme: textTheme,
                          historyImageUrl: historyImageUrl,
                        ),
                        const SizedBox(height: TSizes.mediumSpace),
                        Text(
                          tanggalSekarang,
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.blueGrey,
                          ),
                        ),
                        if (type == DeteksiType.caries)
                          TerindikasiKariesSection(textTheme: textTheme)
                        else
                          DeskripsiNumberingSection(textTheme: textTheme),
                      ],
                    )
                  else
                    Obx(() {
                      if (controller.selectedImage.value == null) {
                        return const Text("Tidak ada gambar yang dipilih");
                      }

                      if (controller.isLoading.value ||
                          controller.imageWidth.value == 0 ||
                          controller.imageHeight.value == 0) {
                        return LoadingDetection(textTheme: textTheme);
                      }

                      final Size imageSize = Size(
                        controller.imageWidth.value.toDouble(),
                        controller.imageHeight.value.toDouble(),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DetectionOutputImage(
                            imageSize: imageSize,
                            controller: controller,
                            type: type,
                            textTheme: textTheme,
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
                            TerindikasiKariesSection(textTheme: textTheme),
                          ] else if (type == DeteksiType.caries &&
                              controller.detections.isEmpty &&
                              !controller.isLoading.value) ...[
                            TidakTerindikasiKariesSection(textTheme: textTheme),
                          ] else if (type == DeteksiType.numbering &&
                              controller.detections.isNotEmpty &&
                              !controller.isLoading.value) ...[
                            DeskripsiNumberingSection(textTheme: textTheme),
                          ] else if (type == DeteksiType.numbering &&
                              controller.detections.isEmpty &&
                              !controller.isLoading.value) ...[
                            const SizedBox(height: TSizes.spaceBtwItems),
                            Container(
                              width: 280,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: TColors.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Gambar yang di upload tidak valid. Silahkan masukkan gambar yang valid!',
                                  style: textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
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
        bottomNavigationBar: isFromHistory
            ? null
            : Obx(
                () =>
                    controller.detections.isNotEmpty &&
                        !controller.isLoading.value
                    ? Padding(
                        padding: const EdgeInsets.only(
                          bottom: TSizes.spaceBtwSections,
                          left: TSizes.scaffoldPadding,
                          right: TSizes.scaffoldPadding,
                          top: TSizes.spaceBtwItems,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.primaryColor,
                            ),
                            onPressed: controller.isSaving.value
                                ? null
                                : () => controller.simpanDeteksi(type),
                            child: controller.isSaving.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Simpan',
                                    style: textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
      ),
    );
  }
}
