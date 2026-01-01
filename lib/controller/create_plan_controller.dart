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
  final List<PlanCircle> circles;

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
    required this.circles, // ✅
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
      "circles": circles.map((c) => c.toJson()).toList(),

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
      circles: (data["circles"] as List? ?? [])
          .map((e) => PlanCircle.fromMap(e))
          .toList(),
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
  final String name;
  final String? image;
  final String status; // pending | accepted | rejected
  final DateTime? respondedAt;

  InvitedUser({
    required this.userId,
    required this.name,
    this.image,
    required this.status,
    this.respondedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "image": image,
      "status": status,
      "respondedAt": respondedAt != null
          ? Timestamp.fromDate(respondedAt!)
          : null,
    };
  }

  factory InvitedUser.fromMap(Map<String, dynamic> map) {
    return InvitedUser(
      userId: map["userId"] ?? '',
      name: map["name"] ?? map["displayName"] ?? 'Unknown User',
      image: map["image"] ?? map["photoURL"] ?? map["profileImage"],
      status: map["status"] ?? 'pending',
      respondedAt: map["respondedAt"] != null
          ? (map["respondedAt"] as Timestamp).toDate()
          : null,
    );
  }
}

class InvitationModel {
  final String planId;
  final String ownerId;
  final String ownerName;
  final String? ownerImage;
  final String planTitle;

  final String status; // pending | accepted | rejected
  final DateTime createdAt;
  final DateTime? respondedAt;

  InvitationModel({
    required this.planId,
    required this.ownerId,
    required this.ownerName,
    this.ownerImage,
    required this.planTitle,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "planId": planId,
      "ownerId": ownerId,
      "ownerName": ownerName,
      "ownerImage": ownerImage,
      "planTitle": planTitle,
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
      ownerName: data["ownerName"] ?? data["name"] ?? 'Unknown',
      ownerImage: data["ownerImage"] ?? data["image"],
      planTitle: data["planTitle"] ?? 'Plan Invitation',
      status: data["status"],
      createdAt: (data["createdAt"] as Timestamp).toDate(),
      respondedAt: data["respondedAt"] != null
          ? (data["respondedAt"] as Timestamp).toDate()
          : null,
    );
  }
}

class PlanCircle {
  final String id;
  final String name;
  final String color;

  PlanCircle({required this.id, required this.name, required this.color});

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "color": color};
  }

  factory PlanCircle.fromMap(Map<String, dynamic> map) {
    return PlanCircle(id: map["id"], name: map["name"], color: map["color"]);
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
  // Selected circles for this plan
  RxList<PlanCircle> selectedCircles = <PlanCircle>[].obs;

  // Sync users from circle controller
  void syncUsersFromCircles(List<Map<String, dynamic>> circleUsers) {
    selectedUserIds.clear();
    for (final user in circleUsers) {
      selectedUserIds.add(user["id"]);
    }
  }

  void syncCirclesFromController() {
    final circleC = Get.find<CircleController>();
    selectedCircles.clear();

    for (final circle in circleC.allCircles) {
      if (circleC.selectedCircleIds.contains(circle.id)) {
        selectedCircles.add(
          PlanCircle(id: circle.id, name: circle.name, color: circle.color),
        );
      }
    }
  }

  // ---------------- VALIDATION ----------------
  bool validatePlan() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Required Fields',
        'Please enter a plan title.',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (locationController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Required Fields',
        'Please enter a location.',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (selectedUserIds.isEmpty) {
      Get.snackbar(
        'Missing Required Fields',
        'Please select at least one user.',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  // ---------------- CREATE PLAN ----------------
  Future<void> createPlan() async {
    final owner = FirebaseAuth.instance.currentUser;
    if (owner == null) return;

    // Validate before creating
    if (!validatePlan()) return;

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

    // 🔹 Build invitedUsers list for OWNER view with names and images
    final circleC = Get.find<CircleController>();
    final List<Map<String, dynamic>> invitedUsers = [];

    for (final uid in selectedUserIds) {
      // Skip the owner - they don't need an invitation
      if (uid == owner.uid) {
        invitedUsers.add({
          "userId": uid,
          "name": "You", // Or get owner's actual name
          "image": null,
          "status": "accepted", // Owner is automatically accepted
          "respondedAt": Timestamp.fromDate(now),
        });
        continue;
      }

      // First try to get data from selected circle users
      final userData = circleC.selectedCircleUsers.firstWhere(
        (user) => user["id"] == uid,
        orElse: () => {},
      );

      String userName = userData["name"] ?? "Unknown";
      String? userImage = userData["image"];

      // If we don't have complete data, try to fetch from Firestore
      if (userName == "Unknown" || userName.isEmpty) {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

          if (userDoc.exists) {
            final data = userDoc.data()!;
            userName = data['name'] ?? data['displayName'] ?? "Unknown";
            userImage =
                userImage ??
                data['photoURL'] ??
                data['image'] ??
                data['profileImage'];
          }
        } catch (e) {
          print('Error fetching user data for $uid: $e');
        }
      }

      invitedUsers.add({
        "userId": uid,
        "name": userName,
        "image": userImage,
        "status": "pending",
        "respondedAt": null,
      });
    }

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

      // ✅ STORE CIRCLES
      "circles": selectedCircles.map((c) => c.toJson()).toList(),

      // existing
      "invitedUsers": invitedUsers,
      "createdAt": Timestamp.fromDate(now),
      "updatedAt": Timestamp.fromDate(now),
    });

    // ---------------- CREATE INVITATIONS ----------------
    // Get owner's details for invitations
    String ownerName = "Unknown";
    String? ownerImage;
    
    try {
      final ownerDoc = await FirebaseFirestore.instance
          .collection('SingupUsers')
          .doc(owner.uid)
          .get();
      
      if (ownerDoc.exists) {
        final ownerData = ownerDoc.data() as Map<String, dynamic>;
        ownerName = ownerData['name'] ?? "Unknown";
        ownerImage = ownerData['ImageUrl'];
      }
    } catch (e) {
      print('Error fetching owner data: $e');
    }
    
    for (final invitedUser in invitedUsers) {
      final uid = invitedUser["userId"];
      
      // Skip creating invitation for the owner
      if (uid == owner.uid) continue;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("invitations")
          .doc(planRef.id)
          .set({
            "planId": planRef.id,
            "ownerId": owner.uid,
            "ownerName": ownerName,
            "ownerImage": ownerImage,
            "planTitle": titleController.text.trim(),
            "status": "pending",
            "createdAt": Timestamp.fromDate(now),
          });
    }

    clearForm();

    // Show success message
    Get.snackbar(
      'Success',
      'Plan created successfully!',
      snackPosition: SnackPosition.TOP,
    );
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

    // Get current user data to ensure we have complete information
    String userName = "Unknown";
    String? userImage;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        userName = userData['name'] ?? userData['displayName'] ?? "Unknown";
        userImage =
            userData['photoURL'] ??
            userData['image'] ??
            userData['profileImage'];
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    final data = snap.data()!;
    final updatedUsers = (data["invitedUsers"] as List).map((u) {
      if (u["userId"] == user.uid) {
        return {
          ...u,
          "status": response,
          "respondedAt": Timestamp.now(),
          "name": userName.isNotEmpty ? userName : u["name"],
          "image": userImage ?? u["image"],
        };
      }
      return u;
    }).toList();

    await planRef.update({"invitedUsers": updatedUsers});
  }

  // ---------------- INVITEE PLANS (ONLY ACCEPTED) ----------------
  Stream<List<PlanModel>> getInvitedPlans() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("invitations")
        .where("status", isEqualTo: "accepted")
        .snapshots()
        .asyncMap((snap) async {
          final List<PlanModel> plans = [];

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
              final planData = planSnap.data() as Map<String, dynamic>;
              final invitedUsers = planData["invitedUsers"] as List? ?? [];

              // Fetch complete user data for each invited user
              final List<InvitedUser> updatedInvitedUsers = [];
              for (final invitedUser in invitedUsers) {
                final userId = invitedUser["userId"];
                String userName = invitedUser["name"] ?? "";
                String? userImage = invitedUser["image"];

                if (userName.isEmpty ||
                    userName == "Unknown" ||
                    userName == "Unknown User") {
                  try {
                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get();

                    if (userDoc.exists) {
                      final userData = userDoc.data()!;
                      userName =
                          userData['name'] ??
                          userData['displayName'] ??
                          "Unknown User";
                      userImage =
                          userImage ??
                          userData['photoURL'] ??
                          userData['image'] ??
                          userData['profileImage'];
                    }
                  } catch (e) {
                    print('Error fetching user data: $e');
                  }
                }

                updatedInvitedUsers.add(
                  InvitedUser(
                    userId: userId,
                    name: userName,
                    image: userImage,
                    status: invitedUser["status"] ?? "pending",
                    respondedAt: invitedUser["respondedAt"] != null
                        ? (invitedUser["respondedAt"] as Timestamp).toDate()
                        : null,
                  ),
                );
              }

              // Create PlanModel with updated user data
              plans.add(
                PlanModel(
                  id: planData["id"],
                  ownerId: planData["ownerId"],
                  title: planData["title"],
                  startDateTime: (planData["startDateTime"] as Timestamp)
                      .toDate(),
                  isRecurring: planData["isRecurring"],
                  repeatType: planData["repeatType"],
                  repeatInterval: planData["repeatInterval"],
                  repeatDays: List<int>.from(planData["repeatDays"]),
                  location: planData["location"],
                  notes: planData["notes"],
                  circles: (planData["circles"] as List? ?? [])
                      .map((e) => PlanCircle.fromMap(e))
                      .toList(),
                  invitedUsers: updatedInvitedUsers,
                  createdAt: (planData["createdAt"] as Timestamp).toDate(),
                  updatedAt: (planData["updatedAt"] as Timestamp).toDate(),
                ),
              );
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
    selectedCircles.clear(); // ✅ IMPORTANT
    repeatDays.clear();
    isRecurring.value = false;
  }

  Stream<List<InvitationModel>> getPendingInvitations() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("invitations")
        .where("status", isEqualTo: "pending")
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => InvitationModel.fromDoc(d)).toList(),
        );
  }

  // show plan    .....

  Stream<List<PlanModel>> getOwnerPlans() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("plans")
        .orderBy("startDateTime")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => PlanModel.fromDoc(doc)).toList();
        });
  }

  // fight details

  Future<void> addFlightDetail({
    required String ownerId,
    required String planId,
    required String airline,
    required String flightNumber,
    required String confirmationCode,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId)
        .collection("flightDetails")
        .add({
          "airline": airline,
          "flightNumber": flightNumber,
          "confirmationCode": confirmationCode,
          "addedBy": user.uid,
          "createdAt": Timestamp.now(),
        });
  }

  Future<void> updateFlightDetail({
    required String ownerId,
    required String planId,
    required String flightId,
    required String airline,
    required String flightNumber,
    required String confirmationCode,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId)
        .collection("flightDetails")
        .doc(flightId)
        .update({
          "airline": airline,
          "flightNumber": flightNumber,
          "confirmationCode": confirmationCode,
          "updatedAt": Timestamp.now(),
        });
  }

  // get fight details data

  Stream<List<Map<String, dynamic>>> getFlightDetails({
    required String ownerId,
    required String planId,
  }) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId)
        .collection("flightDetails")
        .orderBy("createdAt")
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => {"id": d.id, ...d.data()}).toList(),
        );
  }

  // travel details
  Future<void> addChecklistItem({
    required String ownerId,
    required String planId,
    required String title,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId)
        .collection("checklist")
        .add({
          "title": title,
          "completed": false,
          "addedBy": user.uid,
          "createdAt": Timestamp.now(),
        });
  }

  Future<void> deleteChecklistItem({
    required String ownerId,
    required String planId,
    required String itemId,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId)
        .collection("checklist")
        .doc(itemId)
        .delete();
  }

  Future<void> toggleChecklistItem({
    required String ownerId,
    required String planId,
    required String itemId,
    required bool completed,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId)
        .collection("checklist")
        .doc(itemId)
        .update({"completed": completed});
  }

  // get travel details data
  Stream<List<Map<String, dynamic>>> getChecklist({
    required String ownerId,
    required String planId,
  }) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId)
        .collection("checklist")
        .orderBy("createdAt")
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => {"id": d.id, ...d.data()}).toList(),
        );
  }

  //Shared Album / URLs
  Future<void> addSharedMedia({
    required String ownerId,
    required String planId,
    required String type, // image | url
    required String value,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId)
        .collection("sharedMedia")
        .add({
          "type": type,
          "value": value,
          "addedBy": user.uid,
          "createdAt": Timestamp.now(),
        });
  }

  // get shared media data
  Stream<List<Map<String, dynamic>>> getSharedMedia({
    required String ownerId,
    required String planId,
  }) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(ownerId)
        .collection("plans")
        .doc(planId)
        .collection("sharedMedia")
        .orderBy("createdAt")
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  Stream<List<PlanModel>> getCalendarPlans() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return getOwnerPlans().asyncMap((ownerPlans) async {
      final invitedPlans = await getInvitedPlans().first;
      return [...ownerPlans, ...invitedPlans];
    });
  }

  // List<PlanModel> plansForDate(DateTime date, List<PlanModel> plans) {
  //   return plans.where((p) =>
  //     p.startDateTime.year == date.year &&
  //     p.startDateTime.month == date.month &&
  //     p.startDateTime.day == date.day
  //   ).toList();
  // }

  // ---------------- UPDATE PLAN ----------------
  Future<bool> updatePlan({
    required String ownerId,
    required String planId,
    required String title,
    required DateTime startDateTime,
    required bool isRecurring,
    required String repeatType,
    required int repeatInterval,
    required List<int> repeatDays,
    required String location,
    required String notes,
    required List<InvitedUser> invitedUsers,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(ownerId)
          .collection("plans")
          .doc(planId)
          .update({
            "title": title,
            "startDateTime": Timestamp.fromDate(startDateTime),
            "isRecurring": isRecurring,
            "repeatType": isRecurring ? repeatType : "none",
            "repeatInterval": isRecurring ? repeatInterval : 0,
            "repeatDays": isRecurring ? repeatDays : [],
            "location": location,
            "notes": notes,
            "invitedUsers": invitedUsers.map((e) => e.toJson()).toList(),
            "updatedAt": Timestamp.fromDate(DateTime.now()),
          });
      
      Get.snackbar(
        'Success',
        'Plan updated successfully!',
        snackPosition: SnackPosition.TOP,
      );
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update plan: $e',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }

  // ---------------- DELETE PLAN ----------------
  Future<bool> deletePlan({
    required String ownerId,
    required String planId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(ownerId)
          .collection("plans")
          .doc(planId)
          .delete();

      Get.snackbar(
        'Success',
        'Plan deleted successfully!',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete plan: $e',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    final circleC = Get.find<CircleController>();

    ever(circleC.selectedCircleUsers, (users) {
      syncCirclesFromController();
      syncUsersFromCircles(users);
    });
  }
}
