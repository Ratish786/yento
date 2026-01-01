import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CircleChatMessage {
  final String senderId;
  final String senderName;
  final String senderImage;
  final String message;
  final Timestamp timestamp;

  CircleChatMessage({
    required this.senderId,
    required this.senderName,
    required this.senderImage,
    required this.message,
    required this.timestamp,
  });

  String get formattedTime {
    final dateTime = timestamp.toDate();
    return DateFormat('HH:mm').format(dateTime);
  }

  // Dart → Firebase
  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "senderName": senderName,
      "senderImage": senderImage,
      "message": message,
      "timestamp": timestamp,
    };
  }

  // Firebase → Dart
  factory CircleChatMessage.fromJson(Map<String, dynamic> data) {
    return CircleChatMessage(
      senderId: data["senderId"],
      senderName: data["senderName"],
      senderImage: data["senderImage"],
      message: data["message"],
      timestamp: data["timestamp"],
    );
  }
}

class CircleListModel {
  final String id;
  final String title;
  final String createdBy;
  final Timestamp createdAt;

  CircleListModel({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.createdAt,
  });

  factory CircleListModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CircleListModel(
      id: doc.id,
      title: data['title'],
      createdBy: data['createdBy'],
      createdAt: data['createdAt'],
    );
  }
}

class CircleListItemModel {
  final String id;
  final String text;
  final bool isDone;
  final Timestamp createdAt;

  CircleListItemModel({
    required this.id,
    required this.text,
    required this.isDone,
    required this.createdAt,
  });

  factory CircleListItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CircleListItemModel(
      id: doc.id,
      text: data['text'],
      isDone: data['isDone'],
      createdAt: data['createdAt'],
    );
  }
}

class CircleChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // User info
  String? _currentUserId;
  String? _currentUserName;
  String? _currentUserImage;
  
  // Getters
  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;
  String? get currentUserImage => _currentUserImage;
  bool get isUserInfoLoaded => _currentUserId != null;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserInfo();
  }

  /// Load current user information
  Future<void> _loadCurrentUserInfo() async {
    final user = _auth.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
      
      try {
        final userDoc = await _firestore
            .collection('SingupUsers')
            .doc(user.uid)
            .get();
        
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          _currentUserName = userData['name'] ?? 'Unknown';
          _currentUserImage = userData['ImageUrl'] ?? '';
        }
      } catch (e) {
        print('Error loading user info: $e');
        _currentUserName = 'Unknown';
        _currentUserImage = '';
      }
    }
  }

  /// Send message to circle
  Future<bool> sendMessage(String circleId, String message) async {
    if (_currentUserId == null || message.trim().isEmpty) return false;
    
    try {
      final chat = CircleChatMessage(
        senderId: _currentUserId!,
        senderName: _currentUserName ?? 'Unknown',
        senderImage: _currentUserImage ?? '',
        message: message.trim(),
        timestamp: Timestamp.now(),
      );

      await _firestore
          .collection("circles")
          .doc(circleId)
          .collection("chats")
          .add(chat.toJson());
      
      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  /// Listen to circle messages (real time)
  Stream<List<CircleChatMessage>> getCircleMessages(String circleId) {
    return _firestore
        .collection("circles")
        .doc(circleId)
        .collection("chats")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CircleChatMessage.fromJson(doc.data()))
            .toList());
  }

  /// Check if message is from current user
  bool isMyMessage(CircleChatMessage message) {
    return message.senderId == _currentUserId;
  }
    //  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String circleId;

  final TextEditingController newListController = TextEditingController();

  /// CREATE NEW LIST
  Future<void> createList() async {
    final title = newListController.text.trim();
    if (title.isEmpty) return;

    await _firestore
        .collection("circles")
        .doc(circleId)
        .collection("lists")
        .add({
      "title": title,
      "createdBy": FirebaseAuth.instance.currentUser!.uid,
      "createdAt": Timestamp.now(),
    });

    newListController.clear();
  }

  /// STREAM LISTS
  Stream<QuerySnapshot> getLists() {
    return _firestore
        .collection("circles")
        .doc(circleId)
        .collection("lists")
        .orderBy("createdAt")
        .snapshots();
  }

  /// STREAM ITEMS
  Stream<QuerySnapshot> getItems(String listId) {
    return _firestore
        .collection("circles")
        .doc(circleId)
        .collection("lists")
        .doc(listId)
        .collection("items")
        .orderBy("createdAt")
        .snapshots();
  }

  /// ADD ITEM
  Future<void> addItem({
    required String listId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    await _firestore
        .collection("circles")
        .doc(circleId)
        .collection("lists")
        .doc(listId)
        .collection("items")
        .add({
      "text": text,
      "isDone": false,
      "createdAt": Timestamp.now(),
    });
  }

  /// TOGGLE CHECKBOX
  Future<void> toggleItem({
    required String listId,
    required String itemId,
    required bool currentValue,
  }) async {
    await _firestore
        .collection("circles")
        .doc(circleId)
        .collection("lists")
        .doc(listId)
        .collection("items")
        .doc(itemId)
        .update({
      "isDone": !currentValue,
    });
  }

}