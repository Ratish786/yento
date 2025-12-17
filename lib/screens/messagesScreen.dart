import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/screens/Single_chat_screen.dart';
import '../components/dialog/SingleChat.dart';
import '../controller/chat_controller.dart';

class Messagesscreen extends StatelessWidget {
  Messagesscreen({super.key});

 final chatC = Get.find<ChatController>();
  String get myId => FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("actual_users")   // 🔥 NEW COLLECTION
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          final filtered =
              users.where((u) => u.id != myId).toList();  // skip myself

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final user = filtered[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user['imageUrl'] != ""
                      ? NetworkImage(user['imageUrl'])
                      : null,
                  child: user['imageUrl'] == "" ? Icon(Icons.person) : null,
                ),
                title: Text(
                  user['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Tap to chat"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SingleChat(
                        name: user['name'],
                        image: user['imageUrl'],
                        receiverId: user.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
