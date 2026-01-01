import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/app_shell.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/screens/Single_chat_screen.dart';
import '../controller/chat_controller.dart';
import '../controller/theme_controller.dart';

class Messagesscreen extends StatefulWidget {
  const Messagesscreen({super.key});

  @override
  State<Messagesscreen> createState() => _MessagesscreenState();
}

class _MessagesscreenState extends State<Messagesscreen> {
  final chatC = Get.find<ChatController>();
  final ThemeController themeC = Get.find<ThemeController>();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  String get myId => FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeC.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.grey[50],

        // ---------------- APP BAR ----------------
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          foregroundColor: isDark ? Colors.white : Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
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
          title: Text(
            "Messages",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const CustomNotificationsBox(),
                );
              },
              icon: Icon(
                Icons.notifications_none,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),

        // ---------------- BODY ----------------
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              // -------- MESSAGE CONTAINER --------
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -------- HEADER ROW --------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Messages",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showNewMessageDialog(context),
                              child: Icon(
                                Icons.edit,
                                size: 24,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // -------- SEARCH BAR --------
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.toLowerCase();
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.search,
                                  color: isDark
                                      ? const Color(0xFF64748B)
                                      : Colors.grey[600],
                                  size: 18,
                                ),
                              ),
                              hintText: "Search messages",
                              hintStyle: TextStyle(
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : Colors.grey[600],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // -------- MESSAGE LIST --------
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("SingupUsers")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: isDark
                                        ? const Color(0xFF60A5FA)
                                        : const Color(0xFF3B82F6),
                                  ),
                                );
                              }

                              final users = snapshot.data!.docs;
                              final filtered = users
                                  .where((u) => u.id != myId)
                                  .where((u) {
                                    if (searchQuery.isEmpty) return true;
                                    final data =
                                        u.data() as Map<String, dynamic>;
                                    final userName = (data['name'] ?? '')
                                        .toString()
                                        .toLowerCase();
                                    return userName.contains(searchQuery);
                                  })
                                  .toList();

                              if (filtered.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No users yet",
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFF64748B)
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final user = filtered[index];
                                  final data =
                                      user.data() as Map<String, dynamic>;
                                  final userName = data['name'] ?? 'Unknown';
                                  final userImage = data['ImageUrl'] ?? '';

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SingleChat(
                                              name: userName,
                                              image: userImage,
                                              receiverId: user.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          // -------- AVATAR --------
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundColor: isDark
                                                ? const Color(0xFF334155)
                                                : Colors.grey[300],
                                            backgroundImage:
                                                userImage.isNotEmpty
                                                ? (userImage.startsWith(
                                                        'assets/',
                                                      )
                                                      ? AssetImage(userImage)
                                                            as ImageProvider
                                                      : NetworkImage(userImage))
                                                : null,
                                            child: userImage.isEmpty
                                                ? Text(
                                                    userName.isNotEmpty
                                                        ? userName[0]
                                                              .toUpperCase()
                                                        : "?",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  )
                                                : null,
                                          ),

                                          const SizedBox(width: 12),

                                          // -------- NAME & MESSAGE --------
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userName,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                const SizedBox(height: 16),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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

              const SizedBox(height: 16),
            ],
          ),
        ),

        bottomNavigationBar: const Custombottombar(currentIndex: 3),
      );
    });
  }

  void _showNewMessageDialog(BuildContext context) {
    final isDark = themeC.isDarkMode.value;
    final TextEditingController dialogSearchController =
        TextEditingController();
    String dialogSearchQuery = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Message",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
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

                const SizedBox(height: 16),

                // Search Bar
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: dialogSearchController,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        dialogSearchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.search,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : Colors.grey[600],
                          size: 18,
                        ),
                      ),
                      hintText: "Search for a friend...",
                      hintStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF64748B)
                            : Colors.grey[600],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // User List
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("SingupUsers")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: isDark
                                ? const Color(0xFF60A5FA)
                                : const Color(0xFF3B82F6),
                          ),
                        );
                      }

                      final users = snapshot.data!.docs;
                      final filtered = users.where((u) => u.id != myId).where((
                        u,
                      ) {
                        if (dialogSearchQuery.isEmpty) return true;
                        final data = u.data() as Map<String, dynamic>;
                        final userName = (data['name'] ?? '')
                            .toString()
                            .toLowerCase();
                        return userName.contains(dialogSearchQuery);
                      }).toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Text(
                            "No users found",
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF64748B)
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final user = filtered[index];
                          final data = user.data() as Map<String, dynamic>;
                          final userName = data['name'] ?? 'Unknown';
                          final userImage = data['ImageUrl'] ?? '';

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: isDark
                                  ? const Color(0xFF334155)
                                  : Colors.grey[300],
                              backgroundImage: userImage.isNotEmpty
                                  ? (userImage.startsWith('assets/')
                                        ? AssetImage(userImage) as ImageProvider
                                        : NetworkImage(userImage))
                                  : null,
                              child: userImage.isEmpty
                                  ? Text(
                                      userName.isNotEmpty
                                          ? userName[0].toUpperCase()
                                          : "?",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    )
                                  : null,
                            ),
                            title: Text(
                              userName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SingleChat(
                                    name: userName,
                                    image: userImage,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
