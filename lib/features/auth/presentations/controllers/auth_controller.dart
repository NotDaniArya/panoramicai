import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image/image.dart';
import 'package:panoramicai/utils/constant/pages_routes.dart';
import 'package:panoramicai/utils/helper_functions/helper.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
      return;
    }
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        await syncUserProfileEmail(
          firebaseUser: user,
          email: trimmedEmail,
          fullName: trimmedName,
        );

        Get.offAllNamed(PagesRoutes.RUTE_HOME);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        MyHelperFunction.errorToast('Password terlalu lemah');
      } else if (e.code == 'email-already-in-use') {
        MyHelperFunction.errorToast('Email sudah digunakan');
      } else {
        MyHelperFunction.errorToast('Terjadi kesalahan: $e');
      }
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
      return;
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        await syncUserProfileEmail(
          firebaseUser: user,
          email: trimmedEmail,
          fullName: '',
        );

        Get.offAllNamed(PagesRoutes.RUTE_HOME);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') {
        MyHelperFunction.errorToast(
          'Email atau password kamu salah atau belum terdaftar.',
        );
      } else {
        debugPrint('Error signing in with email: $e');
        MyHelperFunction.errorToast(
          'Terjadi kesalahan sistem. Silakan coba lagi.',
        );
      }
    } catch (e) {
      MyHelperFunction.errorToast('Terjadi kesalahan yang tidak terduga.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      if (user != null) {
        await syncUserProfileGoogle(user);

        Get.offAllNamed(PagesRoutes.RUTE_HOME);
      }
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      MyHelperFunction.errorToast('Gagal melakukan login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncUserProfileEmail({
    required User firebaseUser,
    required String email,
    required String fullName,
  }) async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': firebaseUser.uid,
        'email': email,
        'userName': fullName,
        'photoUrl': '',
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      await userDoc.update({'lastLogin': FieldValue.serverTimestamp()});
    }
  }

  Future<void> syncUserProfileGoogle(User firebaseUser) async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': firebaseUser.uid,
        'email': firebaseUser.email ?? '',
        'userName': firebaseUser.displayName ?? 'User',
        'photoUrl': firebaseUser.photoURL ?? '',
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      await userDoc.update({'lastLogin': FieldValue.serverTimestamp()});
    }
  }
}
