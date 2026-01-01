import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/circle_chat_controller.dart';

class Circlechat extends StatefulWidget {
  final String name;

  const Circlechat({super.key, required this.name});

  @override
  State<Circlechat> createState() => _CirclechatState();
}

class _CirclechatState extends State<Circlechat> {
  final CircleChatController chatController = Get.put(CircleChatController());
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void _sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final success = await chatController.sendMessage(
      widget.name, // Using circle name as ID
      messageController.text.trim(),
    );

    if (success) {
      messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --------------- CHAT MESSAGES ---------------
        Expanded(
          child: StreamBuilder<List<CircleChatMessage>>(
            stream: chatController.getCircleMessages(widget.name),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet. Start the conversation!',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                );
              }

              final messages = snapshot.data!;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe = chatController.isMyMessage(message);
                  return _buildMessageBubble(message, isMe);
                },
              );
            },
          ),
        ),

        // --------------- DIVIDER ---------------
        Divider(height: 1, color: Colors.grey.shade300),

        // --------------- BOTTOM INPUT BAR ---------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.attach_file_rounded,
                  size: 22,
                  color: Colors.grey,
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bar_chart, size: 22, color: Colors.grey),
              ),

              // ---------- INPUT FIELD BOX ----------
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 22,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Message #${widget.name}",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),

                      Icon(
                        Icons.emoji_emotions_outlined,
                        size: 22,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Send button
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff1e40af),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(CircleChatMessage message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: message.senderImage.isNotEmpty
                  ? NetworkImage(message.senderImage)
                  : null,
              child: message.senderImage.isEmpty
                  ? Text(message.senderName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xff1e40af) : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.formattedTime,
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe ? Colors.white70 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  chatController.currentUserImage?.isNotEmpty == true
                  ? NetworkImage(chatController.currentUserImage!)
                  : null,
              child: chatController.currentUserImage?.isEmpty != false
                  ? Text(
                      (chatController.currentUserName ?? 'U')[0].toUpperCase(),
                    )
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
