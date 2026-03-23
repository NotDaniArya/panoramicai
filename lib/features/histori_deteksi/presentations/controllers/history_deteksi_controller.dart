import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panoramicai/features/histori_deteksi/data/models/history_models.dart';

import '../../../../utils/helper_functions/helper.dart';

class HistoryDeteksiController extends GetxController {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final RxList<HistoryModels> historyList = <HistoryModels>[].obs;

  final User? currentUser = FirebaseAuth.instance.currentUser;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    if (currentUser == null) {
      MyHelperFunction.errorToast('User belum login');
      return;
    }

    isLoading.value = true;
    historyList.clear();

    try {
      final QuerySnapshot querySnapshot = await db
          .collection('histori_deteksi')
          .where('userId', isEqualTo: currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .get();

      final List<QueryDocumentSnapshot<Object?>> history = querySnapshot.docs;

      historyList.value = history.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return HistoryModels.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching history: $e');
      MyHelperFunction.errorToast('Terjadi kesalahan saat mengambil data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteHistory(String historyId) async {
    try {
      await db.collection('histori_deteksi').doc(historyId).delete();

      historyList.removeWhere((history) => history.id == historyId);

      fetchHistory();
      MyHelperFunction.suksesToast('Riwayat berhasil dihapus');
    } catch (e) {
      debugPrint('Error deleting history: $e');
      MyHelperFunction.errorToast('Terjadi kesalahan saat menghapus data: $e');
    }
  }
}
