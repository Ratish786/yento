import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';

class SingleChat extends StatefulWidget {
  final String name;
  final String image;
  final String receiverId;

  const SingleChat({
    super.key,
    required this.name,
    required this.image,
    required this.receiverId,
  });

  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {
  final chatC = Get.put(ChatController());
  final msgController = TextEditingController();

  String get myId => FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.image != ""
                  ? NetworkImage(widget.image)
                  : null,
              child: widget.image == "" ? const Icon(Icons.person) : null,
            ),
            SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
        backgroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatC.getMessages(myId, widget.receiverId),
              builder: (_, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                final msgs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final m = msgs[i].data() as Map<String, dynamic>;
                    final isMe = m["senderId"] == myId;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          m["message"],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Message...",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (msgController.text.trim().isEmpty) return;

                    await chatC.sendMessage(
                      widget.receiverId,
                      msgController.text.trim(),
                    );
                    msgController.clear();
                  },
                  icon: Icon(Icons.send, color: Colors.amber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
