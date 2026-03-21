import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';
import 'package:panoramicai/features/histori_deteksi/presentations/controllers/history_deteksi_controller.dart';
import 'package:panoramicai/utils/constant/colors.dart';
import 'package:panoramicai/utils/constant/pages_routes.dart';

class HistoryDeteksiScreen extends GetView<HistoryDeteksiController> {
  const HistoryDeteksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HistoryDeteksiController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Riwayat Deteksi',
          style: textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: TColors.primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: TColors.primaryColor),
          );
        }

        if (controller.historyList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 20),
                Text(
                  'Belum Ada Riwayat',
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Anda belum memiliki riwayat rekam medis. Silakan lakukan deteksi gigi Anda sekarang.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium!.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.historyList.length,
          itemBuilder: (context, index) {
            final history = controller.historyList[index];
            final isCaries = history.type != 'Numbering';

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  final deteksiController = Get.put(DeteksiController());

                  deteksiController.detections.clear();
                  deteksiController.selectedImage.value = null;

                  Get.toNamed(
                    PagesRoutes.RUTE_HASIL_DETEKSI,
                    arguments: {
                      'type': isCaries
                          ? DeteksiType.caries
                          : DeteksiType.numbering,
                      'imageUrl': history.imageUrl,
                      'isFromHistory': true,
                      'count': history.jumlahTerdeteksi,
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: history.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isCaries
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isCaries ? 'Karies Gigi' : 'Numbering Gigi',
                                style: textTheme.labelSmall!.copyWith(
                                  color: isCaries ? Colors.red : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isCaries
                                  ? 'Terdeteksi ${history.jumlahTerdeteksi} Karies'
                                  : 'Terdeteksi ${history.jumlahTerdeteksi} Gigi',
                              style: textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat(
                                    'dd MMM yyyy, HH:mm',
                                    'id_ID',
                                  ).format(history.createdAt),
                                  style: textTheme.labelSmall!.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
