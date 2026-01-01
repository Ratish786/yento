import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yento_app/components/models/groupPlanModel.dart';

import '../screens/groupPlansScreen.dart';

// ---------------Broadcast Services--------------
class BroadcastServices {
  final CollectionReference broadcasts = FirebaseFirestore.instance.collection(
    'Broadcasts',
  );

  Future<void> addBroadcast(String title, String message, String imgUrl) {
    return broadcasts.add({
      "Title": title,
      "Message": message,
      "UserName": "Venne User",
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
  CollectionReference _getUserMoments(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('moments');
  }

  Future<void> addMoment(String uid, String? imgUrl, String caption) {
    return _getUserMoments(uid).add({
      'ImgURL':
          imgUrl ??
          'https://fastly.picsum.photos/id/570/1200/400.jpg?hmac=yJRcaq6hiuStbSfeYJ-2ADujgsZNvzxXR1yIdwo_6nM',
      'caption': caption,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getMoments(String uid) {
    return _getUserMoments(
      uid,
    ).orderBy("timestamp", descending: true).snapshots();
  }

  Future<void> deleteMoment(String uid, String momentId) {
    return _getUserMoments(uid).doc(momentId).delete();
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
  final _ref = FirebaseFirestore.instance
      .collection('groupPlans')
      .withConverter<GroupPlan>(
        fromFirestore: (snap, _) => GroupPlan.fromFirestore(snap),
        toFirestore: (plan, _) => plan.toFirestore(),
      );

  /// Create
  Future<void> createGroupPlan(GroupPlan plan) async {
    await _ref.add(plan);
  }

  /// Read (Stream)
  Stream<List<GroupPlan>> streamGroupPlans() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()).toList());
  }

  /// Delete (optional)
  Future<void> deleteGroupPlan(String id) async {
    await _ref.doc(id).delete();
  }
}
