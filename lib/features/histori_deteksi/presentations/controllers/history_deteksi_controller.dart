import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panoramicai/features/histori_deteksi/data/models/history_models.dart';
import '../../../../utils/helper_functions/helper.dart';

class HistoryDeteksiController extends GetxController {
  final RxList<HistoryModels> historyList = <HistoryModels>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    historyList.clear();

    try {
      // Dummy data replacement for Firebase
      await Future.delayed(const Duration(seconds: 1));
      
      final dummyHistory = [
        HistoryModels(
          id: '1',
          imageUrl: 'https://picsum.photos/200',
          jumlahTerdeteksi: 3,
          type: 'Karies',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        HistoryModels(
          id: '2',
          imageUrl: 'https://picsum.photos/201',
          jumlahTerdeteksi: 12,
          type: 'Numbering',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

      historyList.assignAll(dummyHistory);
    } catch (e) {
      debugPrint('Error fetching history: $e');
      MyHelperFunction.errorToast('Terjadi kesalahan saat mengambil data dummy');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteHistory(String historyId) async {
    try {
      // Mock delete
      historyList.removeWhere((history) => history.id == historyId);
      MyHelperFunction.suksesToast('Riwayat berhasil dihapus (Dummy)');
    } catch (e) {
      debugPrint('Error deleting history: $e');
      MyHelperFunction.errorToast('Terjadi kesalahan saat menghapus data');
    }
  }
}
