import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../../../utils/helper_functions/helper.dart';
import '../../data/user_profile_model.dart';

class UserProfileController extends GetxController {
  // Mocking Firebase data
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
    isLoading.value = true;

    try {
      // Dummy data replacement for Firebase
      await Future.delayed(const Duration(milliseconds: 500));
      
      final dummyProfile = UserProfileModel(
        Uid: 'dummy_uid_123',
        userName: 'User Dummy',
        email: 'user@dummy.com',
        photoUrl: 'https://i.pravatar.cc/150?u=dummy',
        institusi: 'Universitas Dummy',
        npa: '12345678',
        tanggalLahir: '01-01-1990',
      );

      userProfile.value = dummyProfile;

      fullNameController.text = dummyProfile.userName;
      institusiController.text = dummyProfile.institusi ?? '';
      npaController.text = dummyProfile.npa ?? '';
      tanggalLahirController.text = dummyProfile.tanggalLahir ?? '';

    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      MyHelperFunction.errorToast('Terjadi kesalahan saat mengambil data dummy');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserProfile() async {
    if (!formKey.currentState!.validate()) return;

    isUpdating.value = true;
    try {
      String photoUrl = userProfile.value?.photoUrl ?? '';

      if (selectedImage.value != null) {
        // Still keeping Supabase for storage if it's not banned, 
        // but adding a fallback for safety if the user wants everything local.
        try {
          final String fileName =
              'profile_dummy_${DateTime.now().millisecondsSinceEpoch}.png';

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
        } catch (e) {
          debugPrint('Supabase storage error (optional): $e');
        }
      }

      final updatedProfile = UserProfileModel(
        Uid: userProfile.value?.Uid ?? 'dummy_uid_123',
        userName: fullNameController.text.trim(),
        email: userProfile.value?.email ?? 'user@dummy.com',
        photoUrl: photoUrl,
        tanggalLahir: tanggalLahirController.text.trim(),
        institusi: institusiController.text.trim(),
        npa: npaController.text.trim(),
      );

      userProfile.value = updatedProfile;
      selectedImage.value = null;
      isUpdating.value = false;

      Get.back();
      MyHelperFunction.suksesToast('Profil berhasil diperbarui (Local Dummy)'); 
    } catch (e) {
      debugPrint('Error updating profile: $e');
      MyHelperFunction.errorToast('Gagal memperbarui profil: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // Mock logout
      Get.offAllNamed('/onboarding'); // Adjusted to use named route if possible
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }
}
