import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPlan {
  final String id;
  final String ownerId; // 🔹 user UID
  final String title;
  final String destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final String description;
  final List<String> members;

  GroupPlan({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.members,
  });

  /// Firestore → Model
  factory GroupPlan.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return GroupPlan(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      title: data['title'] ?? '',
      destination: data['destination'] ?? '',
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      description: data['description'] ?? '',
      members: List<String>.from(data['members'] ?? []),
    );
  }

  /// Model → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'title': title,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'members': members,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
