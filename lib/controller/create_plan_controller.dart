import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yento_app/controller/circle_controller.dart';

/// ---------------- PLAN MODEL ----------------
/// This represents ONE plan created by ONE owner
class PlanModel {
  final String id;
  final String ownerId;
  final String title;
  final DateTime startDateTime;

  final bool isRecurring;
  final String repeatType;
  final int repeatInterval;
  final List<int> repeatDays;

  final String? location;
  final String? notes;

  /// Owner-only tracking
  final List<InvitedUser> invitedUsers;

  final DateTime createdAt;
  final DateTime updatedAt;

  PlanModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.startDateTime,
    required this.isRecurring,
    required this.repeatType,
    required this.repeatInterval,
    required this.repeatDays,
    required this.location,
    required this.notes,
    required this.invitedUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "ownerId": ownerId,
      "title": title,
      "startDateTime": Timestamp.fromDate(startDateTime),
      "isRecurring": isRecurring,
      "repeatType": repeatType,
      "repeatInterval": repeatInterval,
      "repeatDays": repeatDays,
      "location": location,
      "notes": notes,
      "invitedUsers": invitedUsers.map((e) => e.toJson()).toList(),
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
    };
  }

  factory PlanModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PlanModel(
      id: data["id"],
      ownerId: data["ownerId"],
      title: data["title"],
      startDateTime: (data["startDateTime"] as Timestamp).toDate(),
      isRecurring: data["isRecurring"],
      repeatType: data["repeatType"],
      repeatInterval: data["repeatInterval"],
      repeatDays: List<int>.from(data["repeatDays"]),
      location: data["location"],
      notes: data["notes"],
      invitedUsers: (data["invitedUsers"] as List)
          .map((e) => InvitedUser.fromMap(e))
          .toList(),
      createdAt: (data["createdAt"] as Timestamp).toDate(),
      updatedAt: (data["updatedAt"] as Timestamp).toDate(),
    );
  }
}

class InvitedUser {
  final String userId;
  final String status; // pending | accepted | rejected
  final DateTime? respondedAt;

  InvitedUser({required this.userId, required this.status, this.respondedAt});

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "status": status,
      "respondedAt": respondedAt != null
          ? Timestamp.fromDate(respondedAt!)
          : null,
    };
  }

  factory InvitedUser.fromMap(Map<String, dynamic> map) {
    return InvitedUser(
      userId: map["userId"],
      status: map["status"],
      respondedAt: map["respondedAt"] != null
          ? (map["respondedAt"] as Timestamp).toDate()
          : null,
    );
  }
}

class InvitationModel {
  final String planId;
  final String ownerId;
  final String status; // pending | accepted | rejected
  final DateTime createdAt;
  final DateTime? respondedAt;

  InvitationModel({
    required this.planId,
    required this.ownerId,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "planId": planId,
      "ownerId": ownerId,
      "status": status,
      "createdAt": Timestamp.fromDate(createdAt),
      "respondedAt": respondedAt != null
          ? Timestamp.fromDate(respondedAt!)
          : null,
    };
  }

  factory InvitationModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InvitationModel(
      planId: data["planId"],
      ownerId: data["ownerId"],
      status: data["status"],
      createdAt: (data["createdAt"] as Timestamp).toDate(),
      respondedAt: data["respondedAt"] != null
          ? (data["respondedAt"] as Timestamp).toDate()
          : null,
    );
  }
}

/// ---------------- INVITED USER ----------------
/// This object tracks invitation status
// class InvitedUser {
//   final String userId;
//   final String status; // pending | accepted | rejected
//   final DateTime? respondedAt;

//   InvitedUser({
//     required this.userId,
//     required this.status,
//     this.respondedAt,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "userId": userId,
//       "status": status,
//       "respondedAt":
//           respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
//     };
//   }

//   factory InvitedUser.fromMap(Map<String, dynamic> map) {
//     return InvitedUser(
//       userId: map["userId"],
//       status: map["status"],
//       respondedAt: map["respondedAt"] != null
//           ? (map["respondedAt"] as Timestamp).toDate()
//           : null,
//     );
//   }
// }

class CreatePlanController extends GetxController {
  // ---------------- INPUT ----------------
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final notesController = TextEditingController();

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  // ---------------- RECURRING ----------------
  RxBool isRecurring = false.obs;
  RxString repeatType = "weekly".obs;
  RxInt repeatInterval = 1.obs;
  RxList<int> repeatDays = <int>[].obs;

  // ---------------- SELECTED USERS ----------------
  /// FINAL users after circle + individual selection
  RxSet<String> selectedUserIds = <String>{}.obs;

  // Sync users from circle controller
  void syncUsersFromCircles(List<Map<String, dynamic>> circleUsers) {
    selectedUserIds.clear();
    for (final user in circleUsers) {
      selectedUserIds.add(user["id"]);
    }
  }

  // ---------------- CREATE PLAN ----------------
  Future<void> createPlan() async {
    final owner = FirebaseAuth.instance.currentUser;
    if (owner == null) return;

    final start = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    final planRef = FirebaseFirestore.instance
        .collection("users")
        .doc(owner.uid)
        .collection("plans")
        .doc();

    final now = DateTime.now();

    // 🔹 Build invitedUsers list for OWNER view
    final invitedUsers = selectedUserIds.map((uid) {
      return {"userId": uid, "status": "pending", "respondedAt": null};
    }).toList();

    // ---------------- SAVE PLAN (ONCE) ----------------
    await planRef.set({
      "id": planRef.id,
      "ownerId": owner.uid,
      "title": titleController.text.trim(),
      "startDateTime": Timestamp.fromDate(start),
      "isRecurring": isRecurring.value,
      "repeatType": isRecurring.value ? repeatType.value : "none",
      "repeatInterval": isRecurring.value ? repeatInterval.value : 0,
      "repeatDays": isRecurring.value ? repeatDays.toList() : [],
      "location": locationController.text.trim(),
      "notes": notesController.text.trim(),
      "invitedUsers": invitedUsers,
      "createdAt": Timestamp.fromDate(now),
      "updatedAt": Timestamp.fromDate(now),
    });

    // ---------------- CREATE INVITATIONS ----------------
    for (final uid in selectedUserIds) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("invitations")
          .doc(planRef.id)
          .set({
            "planId": planRef.id,
            "ownerId": owner.uid,
            "status": "pending",
            "createdAt": Timestamp.fromDate(now),
          });
    }

    clearForm();
  }

  // ---------------- RESPOND TO INVITE ----------------
  Future<void> respondToInvite({
    required String ownerId,
    required String planId,
    required String response, // accepted | rejected
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 1️⃣ Update invitee inbox
    final inviteRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("invitations")
        .doc(planId);

    await inviteRef.update({
      "status": response,
      "respondedAt": Timestamp.now(),
    });

    // 2️⃣ Update owner plan invitedUsers
    final planRef = FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId);

    final snap = await planRef.get();
    if (!snap.exists) return;

    final data = snap.data()!;
    final updatedUsers = (data["invitedUsers"] as List).map((u) {
      if (u["userId"] == user.uid) {
        return {...u, "status": response, "respondedAt": Timestamp.now()};
      }
      return u;
    }).toList();

    await planRef.update({"invitedUsers": updatedUsers});
  }

  // ---------------- INVITEE PLANS (ONLY ACCEPTED) ----------------
  Stream<List<Map<String, dynamic>>> getAcceptedPlansForUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("invitations")
        .where("status", isEqualTo: "accepted")
        .snapshots()
        .asyncMap((snap) async {
          final List<Map<String, dynamic>> plans = [];

          for (final doc in snap.docs) {
            final ownerId = doc["ownerId"];
            final planId = doc.id;

            final planSnap = await FirebaseFirestore.instance
                .collection("users")
                .doc(ownerId)
                .collection("plans")
                .doc(planId)
                .get();

            if (planSnap.exists) {
              plans.add(planSnap.data()!);
            }
          }
          return plans;
        });
  }

  void clearForm() {
    titleController.clear();
    locationController.clear();
    notesController.clear();
    selectedUserIds.clear();
    repeatDays.clear();
    isRecurring.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to circle controller changes
    ever(Get.find<CircleController>().selectedCircleUsers, (users) {
      syncUsersFromCircles(users);
    });
  }
}
