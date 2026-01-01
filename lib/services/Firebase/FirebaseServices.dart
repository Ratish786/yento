import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/models/groupPlanModel.dart';

// ---------------Broadcast Services--------------
class BroadcastServices {
  final CollectionReference broadcasts = FirebaseFirestore.instance.collection(
    'Broadcasts',
  );

  Future<void> addBroadcast(String title, String message, String imgUrl) {
    return broadcasts.add({
      "Title": title,
      "Message": message,
      "UserName": "YenTo User",
      "Date": DateTime.now().toString().substring(0, 10),
      "ImgURL": imgUrl,
      "timestamp": Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getBroadcastsStream() {
    return broadcasts.orderBy("timestamp", descending: true).snapshots();
  }

  Future<void> updateBroadcast(
    String id,
    String title,
    String message,
    String imgUrl,
  ) {
    return broadcasts.doc(id).update({
      "Title": title,
      "Message": message,
      "ImgURL": imgUrl,
      "timestamp": Timestamp.now(),
    });
  }

  Future<void> deleteBroadcast(String id) {
    return broadcasts.doc(id).delete();
  }
}

// ---------------Moments Services--------------
class MomentServices {
  // Helper to get user's moments subcollection
  CollectionReference getUserMoments(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('moments');
  }

  Future<void> addMoment(String uid, String? imgUrl, String caption) {
    return getUserMoments(uid).add({
      'ImgURL':
          imgUrl ??
          'https://fastly.picsum.photos/id/570/1200/400.jpg?hmac=yJRcaq6hiuStbSfeYJ-2ADujgsZNvzxXR1yIdwo_6nM',
      'caption': caption,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getMoments(String uid) {
    return getUserMoments(
      uid,
    ).orderBy("timestamp", descending: true).snapshots();
  }

  Future<void> deleteMoment(String uid, String momentId) {
    return getUserMoments(uid).doc(momentId).delete();
  }
}

// ---------------PlanServices Services--------------
class PlansServices {
  final CollectionReference plans = FirebaseFirestore.instance.collection(
    'Plans',
  );

  Future<void> addPlan(
    String title,
    String destination,
    Timestamp StartDate,
    Timestamp EndDate,
    String description,
  ) {
    return plans.add({
      'Title': title,
      'destination': destination,
      'StartDate': StartDate,
      'EndDate': EndDate,
      'description': description,
    });
  }
}

// ---------------GroupPlanServices Services--------------
class GroupPlanService {
  CollectionReference<GroupPlan> _userPlansRef(String uid) => FirebaseFirestore
      .instance
      .collection('users')
      .doc(uid)
      .collection('groupPlans')
      .withConverter<GroupPlan>(
        fromFirestore: (snap, _) => GroupPlan.fromFirestore(snap),
        toFirestore: (plan, _) => plan.toFirestore(),
      );

  /// Stream all user plans
  Stream<List<GroupPlan>> streamGroupPlans(String uid) {
    return _userPlansRef(uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  /// Stream a single plan by ID
  Stream<GroupPlan?> streamGroupPlanById(String uid, String planId) {
    return _userPlansRef(uid).doc(planId).snapshots().map((snap) {
      if (!snap.exists) return null;
      return snap.data();
    });
  }

  Future<void> createGroupPlan(String uid, GroupPlan plan) async {
    await _userPlansRef(uid).add(plan);
  }

  Future<void> deleteGroupPlan(String uid, String id) async {
    await _userPlansRef(uid).doc(id).delete();
  }
}
