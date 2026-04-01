import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panoramicai/utils/constant/pages_routes.dart';
import 'package:panoramicai/utils/helper_functions/helper.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    isLoading.value = true;

    final trimmedEmail = email.trim();
    final trimmedName = fullName.trim();

    if (trimmedEmail.isEmpty || password.isEmpty || trimmedName.isEmpty) {
      MyHelperFunction.errorToast('Semua kolom harus diisi dengan benar');
      isLoading.value = false;
      return;
    }
    
    try {
      // Mocking Firebase registration
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(PagesRoutes.RUTE_HOME);
      MyHelperFunction.suksesToast('Registrasi berhasil (Dummy Mode)');
    } catch (e) {
      MyHelperFunction.errorToast('Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty || password.isEmpty) {
      MyHelperFunction.errorToast('Email dan Password tidak boleh kosong');
      isLoading.value = false;
      return;
    }

    try {
      // Mocking Firebase sign in
      await Future.delayed(const Duration(seconds: 1));
      
      if (trimmedEmail == 'user@dummy.com' && password == 'password') {
        Get.offAllNamed(PagesRoutes.RUTE_HOME);
        MyHelperFunction.suksesToast('Login berhasil (Dummy Mode)');
      } else {
        // For development convenience, let's allow any login in dummy mode
        Get.offAllNamed(PagesRoutes.RUTE_HOME);
        MyHelperFunction.suksesToast('Login berhasil (Dummy Mode)');
      }
    } catch (e) {
      MyHelperFunction.errorToast('Terjadi kesalahan sistem. Silakan coba lagi.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    try {
      // Mocking Google Sign In
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(PagesRoutes.RUTE_HOME);
      MyHelperFunction.suksesToast('Login Google berhasil (Dummy Mode)');
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      MyHelperFunction.errorToast('Gagal melakukan login Google');
    } finally {
      isLoading.value = false;
    }
  }
}
