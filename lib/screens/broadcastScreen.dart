import 'package:flutter/material.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';

import '../components/custom/app_shell.dart';

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

void Notifications(BuildContext context) {
  showDialog(context: context, builder: (context) => CustomNotificationsBox());
}

class _BroadcastScreenState extends State<BroadcastScreen> {

  get width => MediaQuery.of(context).size.width;
  get height => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'BroadCast',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: Builder(builder: (context)=>IconButton(onPressed: (){
          AppShell.shellScaffoldKey.currentState!.openDrawer();
        }, icon: Icon(Icons.menu))),
        actions: [
          IconButton(
            onPressed: () {
              Notifications(context);
            },
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      // drawer: CustomDrawer(),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
          child: Column(
            children: [
              // HEADER CONTAINER
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 60,
                width: width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Broadcast',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: () {
                          NewBroadcast(context);
                        },
                        icon: const Icon(Icons.add, color: Color(0xff1e40af)),
                        label: const Text(
                          'New Broadcast',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e40af),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xffbfdbfe),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // FIRST BROADCAST (NO IMAGE)
              BroadcastCard(
                title: "My trip to the Alps",
                userName: "Alex Young",
                date: "19/11/2025",
                message:
                    "It was an incredible experience, the views were breathtaking...",
                comments: 1,
                imageUrl: null,
              ),

              const SizedBox(height: 20),

              // SECOND BROADCAST (WITH IMAGE)
              BroadcastCard(
                title: "Welcome to Yento!",
                userName: "YenTo Tom",
                date: "18/11/2025",
                message:
                    "Welcome to Yento! Share moments, updates, and plans with your close circle...",
                comments: 0,
                imageUrl: "https://picsum.photos/seed/yento/1200/400",
              ),

            ],
          ),
        ),
      ),

      bottomNavigationBar: Custombottombar(currentIndex: 0),
    );
  }
}

// ======================== BROADCAST CARD ============================

class BroadcastCard extends StatelessWidget {
  final String title;
  final String userName;
  final String date;
  final String message;
  final int comments;
  final String? imageUrl;

  const BroadcastCard({
    super.key,
    required this.title,
    required this.userName,
    required this.date,
    required this.message,
    required this.comments,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          // BoxShadow(
          //   color: Colors.black12,
          //   blurRadius: 10,
          //   offset: Offset(0, 3),
          // ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Image.network(
                imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.delete_outline),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    "https://picsum.photos/seed/profile/200",
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline, size: 18),
                const SizedBox(width: 8),
                Text(
                  "$comments Comments",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =================== REUSABLE BROADCAST COMPOSER ===================

Widget BroadcastComposer(
  BuildContext context, {
  required TextEditingController titleController,
  required TextEditingController messageController,
  required VoidCallback onPublish,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      TextField(
        controller: titleController,
        decoration: InputDecoration(
          hintText: 'Broadcast Title',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepOrange),
          ),
        ),
      ),

      const SizedBox(height: 15),
      const Divider(),
      const SizedBox(height: 15),

      SizedBox(
        height: 88,
        child: TextField(
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          controller: messageController,
          maxLines: null,
          expands: true,
          decoration: InputDecoration(
            hintText: 'Share Your Thoughts...',
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepOrange),
            ),
          ),
        ),
      ),

      const SizedBox(height: 25),

      const Text(
        'Attachments (Optional)',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      const SizedBox(height: 10),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              elevation: 0,
            ),
            icon: const Icon(Icons.mic_none, color: Colors.black),
            label: const Text(
              'Record Voice Note',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              elevation: 0,
            ),
            icon: const Icon(Icons.image_outlined, color: Colors.black),
            label: const Text('Add GIF', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),

      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 20),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Visible to:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Everyone'),
            ],
          ),

          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3b82f6),
                ),
                onPressed: onPublish,
                child: const Text(
                  'Publish',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// ========================== NEW BROADCAST ==========================

void NewBroadcast(BuildContext context) {
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Broadcast',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              BroadcastComposer(
                context,
                titleController: titleController,
                messageController: messageController,
                onPublish: () {
                  print("TITLE: ${titleController.text}");
                  print("MESSAGE: ${messageController.text}");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
