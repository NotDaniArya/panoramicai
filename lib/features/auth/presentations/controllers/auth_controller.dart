import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:panoramicai/utils/constant/pages_routes.dart';
import 'package:panoramicai/utils/helper_functions/helper.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      if (user != null) {
        await syncUserProfile(user);

        Get.offAllNamed(PagesRoutes.RUTE_HOME);
      }
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      MyHelperFunction.errorToast('Gagal melakukan login: $e');
    }
  }

  Future<void> syncUserProfile(User firebaseUser) async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid);

    await userDoc.set({
      'uid': firebaseUser.uid,
      'email': firebaseUser.email,
      'userName': firebaseUser.displayName,
      'photoUrl': firebaseUser.photoURL,
      'lastLogin': FieldValue.serverTimestamp(),
      'tanggalLahir': '',
      'institusi': '',
      'npa': '',
    }, SetOptions(merge: true));
  }
}
