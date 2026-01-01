import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/app_shell.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import '../controller/chat_controller.dart';
import '../controller/theme_controller.dart';

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
  final themeC = Get.find<ThemeController>();
  final msgController = TextEditingController();

  String get myId => FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: themeC.isDarkMode.value
          ? const Color(0xFF0F172A)
          : const Color(0xFFF9FAFB),

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: themeC.isDarkMode.value
            ? const Color(0xFF1E293B)
            : Colors.white,
        foregroundColor: themeC.isDarkMode.value
            ? Colors.white
            : const Color(0xFF1F2937),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Messages",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              AppShell.shellScaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Single chat container with user info, messages, and input
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeC.isDarkMode.value
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        themeC.isDarkMode.value ? 0.3 : 0.05,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // User info header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: themeC.isDarkMode.value
                                ? const Color(0xFF334155)
                                : Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back,
                              color: themeC.isDarkMode.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: themeC.isDarkMode.value
                                ? const Color(0xFF334155)
                                : Colors.grey[300],
                            backgroundImage: widget.image.isNotEmpty
                                ? (widget.image.startsWith('assets/')
                                ? AssetImage(widget.image)
                            as ImageProvider
                                : NetworkImage(widget.image))
                                : null,
                            child: widget.image.isEmpty
                                ? Text(
                              widget.name.isNotEmpty
                                  ? widget.name[0].toUpperCase()
                                  : "?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: themeC.isDarkMode.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: themeC.isDarkMode.value
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  "Active now",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: themeC.isDarkMode.value
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_vert,
                              color: themeC.isDarkMode.value
                                  ? Colors.white70
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Messages area
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: chatC.getMessages(myId, widget.receiverId),
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: themeC.isDarkMode.value
                                    ? const Color(0xFF60A5FA)
                                    : const Color(0xFF3B82F6),
                              ),
                            );
                          }

                          final msgs = snapshot.data!.docs;

                          if (msgs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 64,
                                    color: themeC.isDarkMode.value
                                        ? const Color(0xFF475569)
                                        : Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No messages yet",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeC.isDarkMode.value
                                          ? const Color(0xFF94A3B8)
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Send a message to start the conversation",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeC.isDarkMode.value
                                          ? const Color(0xFF64748B)
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            itemCount: msgs.length,
                            itemBuilder: (_, i) {
                              final m =
                              msgs[i].data() as Map<String, dynamic>;
                              final isMe = m["senderId"] == myId;

                              return Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                    MediaQuery.of(context).size.width *
                                        0.75,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? const Color(0xFF3B82F6)
                                        : (themeC.isDarkMode.value
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFF1F5F9)),
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(18),
                                      topRight: const Radius.circular(18),
                                      bottomLeft: Radius.circular(
                                        isMe ? 18 : 4,
                                      ),
                                      bottomRight: Radius.circular(
                                        isMe ? 4 : 18,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    m["message"],
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          : (themeC.isDarkMode.value
                                          ? Colors.white
                                          : const Color(0xFF1F2937)),
                                      fontSize: 15,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Message input area at bottom of same container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeC.isDarkMode.value
                            ? const Color(0xFF0F172A)
                            : Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: themeC.isDarkMode.value
                                ? const Color(0xFF334155)
                                : Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Attachment icon
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.attach_file,
                              color: themeC.isDarkMode.value
                                  ? const Color(0xFF94A3B8)
                                  : Colors.grey[600],
                              size: 22,
                            ),
                          ),

                          // Voice icon
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.mic,
                              color: themeC.isDarkMode.value
                                  ? const Color(0xFF94A3B8)
                                  : Colors.grey[600],
                              size: 22,
                            ),
                          ),

                          // Camera icon
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt,
                              color: themeC.isDarkMode.value
                                  ? const Color(0xFF94A3B8)
                                  : Colors.grey[600],
                              size: 22,
                            ),
                          ),

                          // Emoji icon
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: themeC.isDarkMode.value
                                  ? const Color(0xFF94A3B8)
                                  : Colors.grey[600],
                              size: 22,
                            ),
                          ),

                          // Text input
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeC.isDarkMode.value
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextField(
                                controller: msgController,
                                style: TextStyle(
                                  color: themeC.isDarkMode.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Send a message...",
                                  hintStyle: TextStyle(
                                    color: themeC.isDarkMode.value
                                        ? const Color(0xFF64748B)
                                        : Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Send button
                          GestureDetector(
                            onTap: () async {
                              if (msgController.text.trim().isEmpty) {
                                return;
                              }

                              await chatC.sendMessage(
                                widget.receiverId,
                                msgController.text.trim(),
                              );
                              msgController.clear();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF2563EB),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const Custombottombar(currentIndex: 3),
    ));
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }
}