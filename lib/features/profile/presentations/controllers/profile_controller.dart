import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:panoramicai/features/onboarding/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../../../utils/helper_functions/helper.dart';
import '../../../auth/presentations/screens/login/login_screen.dart';
import '../../data/user_profile_model.dart';

class UserProfileController extends GetxController {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final Rxn<UserProfileModel> userProfile = Rxn<UserProfileModel>();

  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;

  final formKey = GlobalKey<FormState>();
  late final TextEditingController fullNameController;
  late final TextEditingController institusiController;
  late final TextEditingController npaController;
  late final TextEditingController tanggalLahirController;

  final Rxn<File> selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();

    fullNameController = TextEditingController();
    institusiController = TextEditingController();
    npaController = TextEditingController();
    tanggalLahirController = TextEditingController();

    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (currentUser == null) {
      MyHelperFunction.errorToast('User belum login');
      return;
    }

    isLoading.value = true;

    try {
      DocumentSnapshot documentSnapshot = await db
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final profile = UserProfileModel.fromMap(data);
        userProfile.value = profile;

        // Inisialisasi controller dengan data dari Firestore
        fullNameController.text = profile.userName;
        institusiController.text = profile.institusi ?? '';
        npaController.text = profile.npa ?? '';
        tanggalLahirController.text = profile.tanggalLahir ?? '';

      } else {
        userProfile.value = null;
        MyHelperFunction.errorToast('Data pengguna tidak ditemukan');
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      MyHelperFunction.errorToast('Terjadi kesalahan saat mengambil data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserProfile() async {
    if (currentUser == null) return;
    if (!formKey.currentState!.validate()) return;

    isUpdating.value = true;
    try {
      String photoUrl = userProfile.value?.photoUrl ?? '';

      if (selectedImage.value != null) {
        final String fileName =
            'profile_${currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.png';

        await Supabase.instance.client.storage
            .from('panoramic-bucket')
            .uploadBinary(
              fileName,
              await selectedImage.value!.readAsBytes(),
              fileOptions: const FileOptions(contentType: 'image/png'),
            );

        photoUrl = Supabase.instance.client.storage
            .from('panoramic-bucket')
            .getPublicUrl(fileName);
      }

      final updatedData = {
        'userName': fullNameController.text.trim(),
        'tanggalLahir': tanggalLahirController.text.trim(),
        'institusi': institusiController.text.trim(),
        'npa': npaController.text.trim(),
        'photoUrl': photoUrl,
      };

      await db.collection('users').doc(currentUser!.uid).update(updatedData);

      await fetchUserProfile();

      selectedImage.value = null;

      isUpdating.value = false;

      Get.back();
      MyHelperFunction.suksesToast('Profil berhasil diperbarui'); //
    } catch (e) {
      debugPrint('Error updating profile: $e');
      MyHelperFunction.errorToast('Gagal memperbarui profil: $e');
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Get.offAll(() => const OnboardingScreen());
    } catch (e) {
      debugPrint('Error logging out: $e');
      MyHelperFunction.errorToast('Terjadi kesalahan saat logout: $e');
    }
  }
}
