import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/controller/brodcast_controller_y.dart';
import '../components/custom/app_shell.dart';

class BroadcastScreen extends StatefulWidget {
  BroadcastScreen({super.key});

  final BroadcastServices broadcastServices = BroadcastServices();

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

void Notifications(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CustomNotificationsBox(),
  );
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  get width => MediaQuery.of(context).size.width;
  get height => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'BroadCast',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              AppShell.shellScaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Notifications(context);
            },
            icon: Icon(
              Icons.notifications_none,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
          child: Column(
            children: [
              // HEADER CONTAINER
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isDark
                      ? null
                      : const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 0.5,
                      offset: Offset(0, 0.5),
                    ),
                  ],
                ),
                height: 60,
                width: width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Broadcast',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          NewBroadcast(context);
                        },
                        icon: Icon(
                          Icons.add,
                          color: isDark ? Colors.white : const Color(0xff1e40af),
                        ),
                        label: Text(
                          'New Broadcast',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xff1e40af),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: isDark
                              ? const Color(0xff2563eb)
                              : const Color(0xffbfdbfe),
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

              // Broadcast from firebase
              StreamBuilder(
                stream: BroadcastServices().getBroadcastsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No broadcasts found",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    );
                  }

                  List<QueryDocumentSnapshot> broadcastList = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: broadcastList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = broadcastList[index];
                      Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                      String broadcastTitle = data['Title'] ?? 'No Title';
                      String broadcastImgurl = data['ImgURL'] ?? '';
                      String broadcastMessage = data['Message'] ?? '';
                      String broadcastUser = data['UserName'] ?? 'Unknown User';
                      String broadcastDate = data['Date'] ?? '---';

                      return BroadcastCard(
                        id: document.id,
                        title: broadcastTitle,
                        userName: broadcastUser,
                        date: broadcastDate,
                        message: broadcastMessage,
                        comments: 0,
                        imageUrl: broadcastImgurl.isEmpty ? null : broadcastImgurl,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const Custombottombar(),
    );
  }
}

// ======================== BROADCAST CARD ============================
class BroadcastCard extends StatefulWidget {
  final dynamic id;
  final String title;
  final String userName;
  final String date;
  final String message;
  final int comments;
  final String? imageUrl;

  const BroadcastCard({
    super.key,
    required this.id,
    required this.title,
    required this.userName,
    required this.date,
    required this.message,
    required this.comments,
    this.imageUrl,
  });

  @override
  State<BroadcastCard> createState() => _BroadcastCardState();
}

class _BroadcastCardState extends State<BroadcastCard> {
  bool showCommentBox = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? null
            : const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.history_outlined,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        UpdateBroadcast(
                          context,
                          docID: widget.id,
                          oldTitle: widget.title,
                          oldMessage: widget.message,
                          oldGifUrl: widget.imageUrl,
                        );
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        BroadcastServices().deleteBroadcast(widget.id);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
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
                      widget.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      widget.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.black54,
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
              widget.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: isDark ? Colors.grey[300] : const Color(0xFF1F2937),
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (widget.imageUrl != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: InkWell(
              onTap: () {
                setState(() => showCommentBox = !showCommentBox);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 18,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${widget.comments} Comments",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (showCommentBox)
            Column(
              children: [
                Divider(color: isDark ? Colors.grey[600] : Colors.grey[300]),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 35,
                          child: TextField(
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF1F2937),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.image_outlined,
                                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                                ),
                              ),
                              hintText: "Add a comment...",
                              hintStyle: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Color(0xff3B82F6),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send, color: Color(0xff3B82F6)),
                      ),
                    ],
                  ),
                ),
              ],
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
      required VoidCallback onGifPick,
      String? selectedGifUrl,
      bool isEditing = false,
    }) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      TextField(
        controller: titleController,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1F2937),
        ),
        decoration: InputDecoration(
          hintText: 'Broadcast Title',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.grey[600]! : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xff3B82F6), width: 2),
          ),
        ),
      ),

      const SizedBox(height: 15),
      Divider(color: isDark ? Colors.grey[600] : Colors.grey[300]),
      const SizedBox(height: 15),

      SizedBox(
        height: 88,
        child: TextField(
          controller: messageController,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
          textAlignVertical: TextAlignVertical.top,
          maxLines: null,
          expands: true,
          decoration: InputDecoration(
            hintText: 'Share Your Thoughts...',
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[600]! : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff3B82F6), width: 2),
            ),
          ),
        ),
      ),

      const SizedBox(height: 25),
      if (selectedGifUrl != null && selectedGifUrl.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              selectedGifUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      const SizedBox(height: 25),
      Text(
        'Attachments (Optional)',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF1F2937),
        ),
      ),
      const SizedBox(height: 10),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: isDark ? const Color(0xFF475569) : Colors.grey[200],
            ),
            icon: Icon(
              Icons.mic_none,
              color: isDark ? Colors.white : Colors.black,
            ),
            label: Text(
              'Record Voice Note',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: onGifPick,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: isDark ? const Color(0xFF475569) : Colors.grey[200],
            ),
            icon: Icon(
              Icons.image_outlined,
              color: isDark ? Colors.white : Colors.black,
            ),
            label: Text(
              (selectedGifUrl != null && selectedGifUrl.isNotEmpty)
                  ? 'Change\n GIF'
                  : 'Add GIF',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 20),
      Divider(color: isDark ? Colors.grey[600] : Colors.grey[300]),
      const SizedBox(height: 20),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Visible to:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              Text(
                'Everyone',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ],
          ),

          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isDark ? const Color(0xFF475569) : Colors.grey[200],
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xff3B82F6),
                ),
                onPressed: onPublish,
                child: Text(
                  isEditing ? 'Save Changes' : 'Publish\n Broadcast',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
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
  String? selectedGifUrl;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: isDark ? const Color(0xFF334155) : Colors.white,
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New Broadcast',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: isDark ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    BroadcastComposer(
                      context,
                      titleController: titleController,
                      messageController: messageController,
                      selectedGifUrl: selectedGifUrl,

                      onGifPick: () async {
                        final gif = await GifDialog(context);
                        if (gif != null) {
                          setState(() => selectedGifUrl = gif);
                        }
                      },

                      onPublish: () async {
                        await BroadcastServices().addBroadcast(
                          titleController.text.trim(),
                          messageController.text.trim(),
                          selectedGifUrl ?? "",
                        );

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

//---------Update--code---------------
void UpdateBroadcast(
    BuildContext context, {
      required String docID,
      required String oldTitle,
      required String oldMessage,
      String? oldGifUrl,
    }) {
  final titleController = TextEditingController(text: oldTitle);
  final messageController = TextEditingController(text: oldMessage);
  String? selectedGifUrl = oldGifUrl;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: isDark ? const Color(0xFF334155) : Colors.white,
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Broadcast',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: BroadcastComposer(
                      context,
                      titleController: titleController,
                      messageController: messageController,
                      selectedGifUrl: selectedGifUrl,
                      isEditing: true,

                      onGifPick: () async {
                        final gif = await GifDialog(context);
                        if (gif != null) {
                          setState(() => selectedGifUrl = gif);
                        }
                      },

                      onPublish: () async {
                        await FirebaseFirestore.instance
                            .collection('Broadcasts')
                            .doc(docID)
                            .update({
                          "Title": titleController.text.trim(),
                          "Message": messageController.text.trim(),
                          "ImgURL": selectedGifUrl ?? "",
                          "timestamp": Timestamp.now(),
                        });

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// -------------GIF Dialog-----------------
Future<String?> GifDialog(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: isDark ? const Color(0xFF334155) : Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.95,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose a GIF',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Divider(color: isDark ? Colors.grey[600] : Colors.grey[300]),
            const SizedBox(height: 8),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: gifUrls.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, gifUrls[index]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(gifUrls[index], fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

final List<String> gifUrls = [
  "https://media.giphy.com/media/xT5LMHxhOfscxPfIfm/giphy.gif",
  "https://media.giphy.com/media/3o7TKtnuHOHHUjR38Y/giphy.gif",
  "https://media.giphy.com/media/d3mlE7uhX8KFgEmY/giphy.gif",
  "https://media.giphy.com/media/3o85xGocUH8RYoDKKs/giphy.gif",
  "https://media.giphy.com/media/l4Jz3a8jO92crUlWM/giphy.gif",
  "https://media.giphy.com/media/l0HlBO7eyXzSZkJri/giphy.gif",
  "https://media.giphy.com/media/26BkNrGhy4DKnbD9u/giphy.gif",
  "https://media.giphy.com/media/3o7aD2saalBwwftBIY/giphy.gif",
  "https://media.giphy.com/media/l46Cy1rHbQ92uuLXa/giphy.gif",
  "https://media.giphy.com/media/l1J9EdzfOSgfyueLm/giphy.gif",
  "https://media.giphy.com/media/3o6Zt6ML6BklcajjsA/giphy.gif",
  "https://media.giphy.com/media/3oEduHHqNchG6Rb5p2/giphy.gif",
  "https://media.giphy.com/media/l3q2K5jinAlChoCLS/giphy.gif",
];