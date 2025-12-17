import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CircleModel {
  final String id;
  final String ownerId;
  final String name;
  final String color; // hex string
  final bool locked;
  final String? pin;
  final List<Map<String, dynamic>> members;

  final DateTime createdAt;
  final DateTime updatedAt;

  CircleModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.color,
    required this.locked,
    this.pin,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "ownerId": ownerId,
      "name": name,
      "color": color,
      "locked": locked,
      "pin": pin,
      "members": members,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
    };
  }

  factory CircleModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CircleModel(
      id: data["id"],
      ownerId: data["ownerId"],
      name: data["name"],
      color: data["color"],
      locked: data["locked"],
      pin: data["pin"],
      members: List<Map<String, dynamic>>.from(data["members"]),
      createdAt: (data["createdAt"] as Timestamp).toDate(),
      updatedAt: (data["updatedAt"] as Timestamp).toDate(),
    );
  }
}
class CircleController extends GetxController {

    // ---------------- ALL CIRCLES ----------------
  RxList<CircleModel> allCircles = <CircleModel>[].obs;

  // ---------------- SELECTED CIRCLES ----------------
  RxSet<String> selectedCircleIds = <String>{}.obs;

  // ---------------- USERS FROM SELECTED CIRCLES ----------------
  RxList<Map<String, dynamic>> selectedCircleUsers =
      <Map<String, dynamic>>[].obs;

final RxString selectedCircleId = ''.obs;











  // ---------------- FORM STATE ----------------
  final circleNameController = TextEditingController();
  Rx<Color> selectedColor = Colors.blue.obs;
  RxBool lockEnabled = false.obs;
  final pinController = TextEditingController();

  // ---------------- MEMBERS ----------------
  RxList<Map<String, dynamic>> selectedMembers =
      <Map<String, dynamic>>[].obs;

  // ---------------- UI STATE ----------------
  RxBool isLoading = false.obs;

  
  @override
  void onInit() {
    super.onInit();
    fetchCircles();
  }




  // ---------------- CREATE CIRCLE ----------------
 Future<void> createCircle() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  if (circleNameController.text.trim().isEmpty ||
      selectedMembers.isEmpty) {
    Get.snackbar("Error", "Circle name & members required");
    return;
  }

  final now = DateTime.now();

  final ref = FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .collection('Circles')
      .doc();

  final circle = CircleModel(
    id: ref.id,
    ownerId: user.uid,
    name: circleNameController.text.trim(),
    color: selectedColor.value.value.toRadixString(16),
    locked: lockEnabled.value,
    pin: lockEnabled.value ? pinController.text : null,
    members: selectedMembers.toList(),
    createdAt: now,
    updatedAt: now,
  );

  await ref.set(circle.toJson());

  clearForm();
  Get.back();
}

  // ---------------- STREAM CIRCLES ----------------
 Stream<List<CircleModel>> getCircles() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .collection('Circles')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((d) => CircleModel.fromDoc(d)).toList(),
      );
}

  // ---------------- RESET FORM ----------------
  void clearForm() {
    circleNameController.clear();
    pinController.clear();
    selectedMembers.clear();
    selectedColor.value = Colors.blue;
    lockEnabled.value = false;
  }

 // ---------------- FETCH CIRCLES ----------------
 void fetchCircles() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .collection('Circles')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .listen((snapshot) {
    allCircles.value =
        snapshot.docs.map((e) => CircleModel.fromDoc(e)).toList();
  });
}


 // ---------------- TOGGLE CIRCLE SELECTION ----------------
  void toggleCircle(String circleId) {
    if (selectedCircleIds.contains(circleId)) {
      selectedCircleIds.remove(circleId);
    } else {
      selectedCircleIds.add(circleId);
    }

    _rebuildSelectedUsers();
  }

   // ---------------- BUILD USERS FROM SELECTED CIRCLES ----------------
 void _rebuildSelectedUsers() {
  final Map<String, Map<String, dynamic>> uniqueUsers = {};

  for (final circle in allCircles) {
    if (selectedCircleIds.contains(circle.id)) {
      for (final user in circle.members) {
        uniqueUsers[user["id"]] = user; // avoids duplicates
      }
    }
  }

  selectedCircleUsers.value = uniqueUsers.values.toList();
}

    // ---------------- CLEAR ----------------
  void clearCircleSelection() {
    selectedCircleIds.clear();
    selectedCircleUsers.clear();
  }



}
