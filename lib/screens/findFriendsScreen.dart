import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/controller/send_mail.dart';
import '../components/custom/app_shell.dart';

class Findfriendsscreen extends StatefulWidget {
  const Findfriendsscreen({super.key});

  @override
  State<Findfriendsscreen> createState() => _FindfriendsscreenState();
}

class _FindfriendsscreenState extends State<Findfriendsscreen> {
  bool isSynced = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Find Friends',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
              showDialog(
                context: context,
                builder: (context) => const CustomNotificationsBox(),
              );
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (isSynced)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contacts on Venne',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isSynced = false;
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.cached, color: Color(0xff3B82F6)),
                            SizedBox(width: 4),
                            Text(
                              'Re-sync',
                              style: TextStyle(color: Color(0xff3B82F6)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              isSynced
                  ? _contactsList(context)
                  : _findYourFriends(
                context,
                onSync: () {
                  setState(() {
                    isSynced = true;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Custombottombar(),
    );
  }
}

// ---------------- Sync Contacts Container ----------------
Widget _findYourFriends(BuildContext context, {required VoidCallback onSync}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Center(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.52,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : Colors.white, // 👈 Different from bg
        borderRadius: BorderRadius.circular(15),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor:
              isDark ? const Color(0xff1e40af) : const Color(0xffdbeafe),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Color(0xff3B82F6),
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Find your friend',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Connect with people you already know\nby syncing your contacts. We'll check\nto see who's already on Venne.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 270,
              height: 48,
              child: ElevatedButton(
                onPressed: onSync,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isDark ? const Color(0xff2563eb) : const Color(0xffbfdbfe),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: isDark ? Colors.white : const Color(0xff1e40af),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Sync Contacts',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xff1e40af),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "We respect your privacy. Your contacts are only\nused to find friends and are not stored on our server",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ---------------- Contacts List ----------------
Widget _contactsList(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Column(
    children: [
      _connectTile(context, 'Abc', 'alex@example.com'),
      const SizedBox(height: 20),
      _connectTile(context, 'Abc', 'alex@example.com'),
      const SizedBox(height: 20),
      _connectTile(context, 'Abc', 'alex@example.com'),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 32),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Invite to Venne',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : Colors.white, // 👈 Different from bg
            borderRadius: BorderRadius.circular(15),
            boxShadow: isDark
                ? null
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _inviteTile(context, 'abc', 'testing@test.com'),
              const SizedBox(height: 6),
              Divider(color: isDark ? Colors.grey[600] : Colors.grey[300]),
              const SizedBox(height: 6),
              _inviteTile(context, 'abc', 'testing@test.com'),
              const SizedBox(height: 6),
              Divider(color: isDark ? Colors.grey[600] : Colors.grey[300]),
              const SizedBox(height: 6),
              _inviteTile(context, 'abc', 'testing@test.com'),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}

// ---------------- Custom Tile For Contacts ----------------
Widget _connectTile(BuildContext context, String name, String email) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF334155) : Colors.white, // 👈 Different from bg
      borderRadius: BorderRadius.circular(16),
      boxShadow: isDark
          ? null
          : [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=user-1'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to profile or show details
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor:
              isDark ? const Color(0xff475569) : const Color(0xfff1f5f9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
            ),
            child: Text(
              'View',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xff334155),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// ---------------- Custom Tile For Invites ----------------
Widget _inviteTile(BuildContext context, String name, String email) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Not on Venne yet",
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 12),
      ElevatedButton(
        onPressed: () {
          _openInviteDialog(context, email);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isDark ? const Color(0xff2563eb) : const Color(0xffbfdbfe),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          "Invite",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xff1e40af),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

// ------------------ INVITE DIALOG ----------------------
void _openInviteDialog(BuildContext context, String friendEmail) {
  final emailC = TextEditingController(text: friendEmail);
  final msgC = TextEditingController(
    text: "Hey! I'm using Venne and thought you might like it too. Join me!",
  );
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor:
      isDark ? const Color(0xFF334155) : const Color(0xffffffff), // 👈 Different from bg
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "Invite Friend",
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1F2937),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailC,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              labelText: "Friend's Email",
              labelStyle: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff3B82F6), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: msgC,
            maxLines: 4,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              labelText: "Message",
              alignLabelWithHint: true,
              labelStyle: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff3B82F6), width: 2),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(
            "Cancel",
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final receiver = emailC.text.trim();
            final message = msgC.text.trim();

            if (receiver.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter an email address")),
              );
              return;
            }

            await sendInviteEmail(receiver, message);

            if (dialogContext.mounted) {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Invite sent to $receiver"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff3B82F6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            "Send",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}