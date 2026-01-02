import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/app_shell.dart';
import 'package:yento_app/screens/login_screen.dart';
import 'package:yento_app/screens/password_screen.dart';
import 'package:yento_app/controller/pass_controller.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  // Reactive user
  Rx<User?> user = Rx<User?>(FirebaseAuth.instance.currentUser);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    // Bind the user stream to keep it updated
    user.bindStream(auth.userChanges());
    // Listen for changes and set initial screen
    ever(user, _setInitialScreen);
  }

  void _setInitialScreen(User? currentUser) async {
    // Optional delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 2));

    if (currentUser == null) {
      Get.offAll(() => const SimpleLoginScreen());
    } else {
      // Check if PIN is set before navigating to main app
      try {
        final passC = Get.put(PassController());
        final hasPinSet = await passC.hasPinSet();
        
        if (hasPinSet) {
          Get.offAll(() => const LockScreen());
        } else {
          Get.offAll(() => AppShell());
        }
      } catch (e) {
        // If PIN check fails, go to main app
        Get.offAll(() => AppShell());
      }
    }
  }

  // --- LOGIN ---
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- SIGN UP ---
  Future<void> signup(String name, String email, String phone, String password) async {
    try {
      isLoading.value = true;

      // 1. Create User in Auth
      UserCredential cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Save User Data to Firestore
      String uid = cred.user!.uid;
      await firestore.collection("SingupUsers").doc(uid).set({
        "name": name,
        "email": email,
        "phone": phone,
        "ImageUrl": null,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        "Success",
        "Account created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Signup Failed",
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    await auth.signOut();
  }

  // --- HELPER: Get current user ID safely ---
  String? get userId => user.value?.uid;
  
  // --- HELPER: Check if user is logged in ---
  bool get isLoggedIn => user.value != null;
}
