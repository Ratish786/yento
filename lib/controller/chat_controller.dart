import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ⭐ Send Message (FULLY WORKING)
  Future<void> sendMessage(String receiverId, String message) async {
    try {
      // Check if user is authenticated
      if (_auth.currentUser == null) {
        print("❌ ERROR: User not authenticated");
        Get.snackbar("Error", "Please login first");
        return;
      }

      final String senderId = _auth.currentUser!.uid;
      final String senderEmail = _auth.currentUser!.email ?? "";
      final Timestamp timestamp = Timestamp.now();

      // Validate inputs
      if (receiverId.isEmpty || message.trim().isEmpty) {
        print("❌ ERROR: Invalid receiverId or message");
        return;
      }

      // Sort IDs → unique chat room ID
      List<String> ids = [senderId, receiverId];
      ids.sort();
      final String chatRoomId = ids.join("_");

      print("📤 SENDING MESSAGE...");
      print("chatRoomId = $chatRoomId");
      print("senderId = $senderId");
      print("receiverId = $receiverId");
      print("message = $message");

      /// ⭐ STEP 1 → Create / Update Chat Room
      await _firestore.collection("chat_rooms").doc(chatRoomId).set({
        "users": ids,
        "lastMessage": message,
        "updatedAt": timestamp,
      }, SetOptions(merge: true));

      /// ⭐ STEP 2 → Add Message to Subcollection
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .add({
        "senderId": senderId,
        "senderEmail": senderEmail,
        "receiverId": receiverId,
        "message": message,
        "timestamp": timestamp,
      });

      print("✅ MESSAGE SENT");
    } catch (e) {
      print("❌ ERROR SENDING MESSAGE: $e");
      Get.snackbar("Error", "Failed to send message: $e");
    }
  }

  /// ⭐ Get real-time message stream
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    print("📥 Listening to chatRoomId: $chatRoomId");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
