import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PassController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxBool hasPinSetValue = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkPinStatus();
  }

  Future<void> _checkPinStatus() async {
    hasPinSetValue.value = await hasPinSet();
  }

  // Set PIN for current user
  Future<bool> setPin(String pin) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      isLoading.value = true;
      
      await _firestore
          .collection('password')
          .doc(user.uid)
          .set({
            'pin': pin,
            'createdAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
          });

      hasPinSetValue.value = true; // Update reactive variable
      
      Get.snackbar(
        'Success',
        'PIN set successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to set PIN: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Verify PIN for current user
  Future<bool> verifyPin(String enteredPin) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final doc = await _firestore
          .collection('password')
          .doc(user.uid)
          .get();

      if (!doc.exists) return false;

      final savedPin = doc.data()?['pin'];
      return savedPin == enteredPin;
    } catch (e) {
      print('Error verifying PIN: $e');
      return false;
    }
  }

  // Check if user has set a PIN
  Future<bool> hasPinSet() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final doc = await _firestore
          .collection('password')
          .doc(user.uid)
          .get();

      return doc.exists && doc.data()?['pin'] != null;
    } catch (e) {
      print('Error checking PIN: $e');
      return false;
    }
  }

  // Update existing PIN
  Future<bool> updatePin(String newPin) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      isLoading.value = true;
      
      await _firestore
          .collection('password')
          .doc(user.uid)
          .update({
            'pin': newPin,
            'updatedAt': Timestamp.now(),
          });

      Get.snackbar(
        'Success',
        'PIN updated successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update PIN: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}