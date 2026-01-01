import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/components/dialog/momemt_dialog.dart';
import 'package:yento_app/controller/brodcast_controller_y.dart';
import 'package:yento_app/controller/theme_controller.dart';
import '../components/custom/app_shell.dart';

class Momentsscreen extends StatefulWidget {
  Momentsscreen({super.key});

  final MomentServices momentServices = MomentServices();

  @override
  State<Momentsscreen> createState() => _MomentsscreenState();
}

void Notifications(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CustomNotificationsBox(),
  );
}

class _MomentsscreenState extends State<Momentsscreen> {
  final ThemeController themeC = Get.find<ThemeController>();
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (_uid == null) {
      return Scaffold(
        body: const Center(child: Text('Please log in to view moments.')),
      );
    }

    return Obx(() {
      final isDark = themeC.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.grey[100],
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          foregroundColor: isDark ? Colors.white : Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            'Moments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Notifications(context);
              },
              icon: Icon(
                Icons.notifications_none,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                AppShell.shellScaffoldKey.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Container(
              height: height * 0.8,
              width: width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Moments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.dialog(
                            const CreateMomentDialog(),
                            barrierDismissible: false,
                          );
                        },
                        icon: const Icon(
                          Icons.image_outlined,
                          color: Color(0xff1e40af),
                        ),
                        label: const Text(
                          'Add Moment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e40af),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffbfdbfe),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Moment Cards
                  Expanded(
                    child: StreamBuilder(
                      stream: MomentServices().getMoments(_uid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: isDark
                                  ? const Color(0xFF60A5FA)
                                  : const Color(0xFF3B82F6),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return NoMoment(isDark: isDark);
                        }

                        final docs = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final moment =
                            docs[index].data() as Map<String, dynamic>;
                            final imgUrl = moment['ImgURL'] ?? '';
                            final caption = moment['caption'] ?? '';
                            final docId = docs[index].id;

                            return MomentCard(
                              imgUrl: imgUrl,
                              caption: caption,
                              docId: docId,
                              isDark: isDark,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const Custombottombar(),
      );
    });
  }
}

// ---------- MOMENT CARD ---------
class MomentCard extends StatefulWidget {
  final String imgUrl;
  final String caption;
  final String docId;
  final bool isDark;

  const MomentCard({
    super.key,
    required this.imgUrl,
    required this.caption,
    required this.docId,
    required this.isDark,
  });

  @override
  State<MomentCard> createState() => _MomentCardState();
}

class _MomentCardState extends State<MomentCard> {
  bool showCommentBox = false;
  bool showDeleteButton = false;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: widget.isDark
              ? const Color(0xFF334155)
              : Colors.transparent,
        ),
        boxShadow: widget.isDark
            ? []
            : const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= IMAGE WITH DELETE BUTTON ==================
          GestureDetector(
            onTap: () {
              setState(() {
                showDeleteButton = !showDeleteButton;
              });
            },
            child: Stack(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.imgUrl,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),

                // DELETE BUTTON
                if (showDeleteButton)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () async {
                        if (_uid == null) return;
                        await MomentServices().deleteMoment(
                          _uid!,
                          widget.docId,
                        );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Moment deleted")),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.isDark
                              ? const Color(0xFF1E293B)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.delete,
                          size: 20,
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ================== CAPTION ==================
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.caption,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Divider(
              color: widget.isDark
                  ? const Color(0xFF334155)
                  : Colors.grey.shade300,
            ),
          ),

          // ================== LIKE + COMMENT ==================
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  size: 22,
                  color: widget.isDark ? Colors.white70 : Colors.black,
                ),
              ),
              Text(
                "0",
                style: TextStyle(
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  setState(() => showCommentBox = !showCommentBox);
                },
                icon: Icon(
                  Icons.comment_outlined,
                  size: 22,
                  color: widget.isDark ? Colors.white70 : Colors.black,
                ),
              ),
              Text(
                "0",
                style: TextStyle(
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),

          // ================== COMMENT BOX ==================
          if (showCommentBox)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Add a comment...",
                          hintStyle: TextStyle(
                            color: widget.isDark
                                ? const Color(0xFF64748B)
                                : Colors.grey,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          filled: true,
                          fillColor: widget.isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: widget.isDark
                                  ? const Color(0xFF334155)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: widget.isDark
                                  ? const Color(0xFF334155)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Color(0xff1e40af)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------- NO MOMENT WIDGET ---------
Widget NoMoment({required bool isDark}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'No moments to see here.',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Share a photo to create a timeline of your memories with friends and circles.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? const Color(0xFF94A3B8) : Colors.black54,
        ),
      ),
      const SizedBox(height: 30),
    ],
  );
}

final List<String> plans = [
  "Morning Workout",
  "Study Schedule",
  "Daily Meditation",
  "Weekend Trip",
  "No Plan",
];