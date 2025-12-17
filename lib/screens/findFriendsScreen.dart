import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          "Find Friends",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),

        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              AppShell.shellScaffoldKey.currentState!.openDrawer();
            },
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const CustomNotificationsBox(),
              );
            },
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              width: width * 0.9,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Find Friends",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      elevation: 0,
                    ),
                    child: const Text(
                      "Re-sync",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            contactsSection(context),
          ],
        ),
      ),

      bottomNavigationBar: const Custombottombar(),
    );
  }
}

//
// ---------------- CONTACTS SECTION ----------------
//
Widget contactsSection(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 12),
        child: Text(
          "Contacts on YenTo (3)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

      const SizedBox(height: 20),

      _connectTile(context, "Abc", Colors.black),
      const SizedBox(height: 20),
      _connectTile(context, "Pqr", Colors.purple),
      const SizedBox(height: 20),
      _connectTile(context, "Xyz", Colors.blue),

      const SizedBox(height: 20),

      const Padding(
        padding: EdgeInsets.only(left: 12),
        child: Text(
          "Invite to Yento (3)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

      const SizedBox(height: 20),

      Center(
        child: Container(
          width: width * 0.9,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),

          child: Column(
            children: [
              inviteTile(context, "Abc"),
              const SizedBox(height: 12),
              inviteTile(context, "Pqr"),
              const SizedBox(height: 12),
              inviteTile(context, "Xyz"),
            ],
          ),
        ),
      ),

      const SizedBox(height: 20),
    ],
  );
}

//
// ------------- TILE FOR CONTACTS USING APP -------------
//
Widget _connectTile(BuildContext context, String name, Color avatarColor) {
  final width = MediaQuery.of(context).size.width;

  return Container(
    width: width * 0.9,
    height: 180,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(radius: 34, backgroundColor: avatarColor),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),

        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            elevation: 0,
          ),
          child: const Text("Connect", style: TextStyle(color: Colors.black)),
        ),
      ],
    ),
  );
}

//
// ------------------ INVITE TILE ------------------------
//
Widget inviteTile(BuildContext context, String name) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text("Not on YenTo yet", style: TextStyle(color: Colors.grey)),
        ],
      ),

      ElevatedButton(
        onPressed: () {
          openInviteDialog(context); // <-- FIXED
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffbfdbfe),
          elevation: 0,
        ),
        child: const Text("Invite", style: TextStyle(color: Color(0xff1e40af))),
      ),
    ],
  );
}

//
// ------------------ INVITE DIALOG ----------------------
//
void openInviteDialog(BuildContext context) {
  final emailC = TextEditingController(); // Friend email
  final msgC = TextEditingController(); // Message text

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Invite Friend"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Friend's Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: msgC,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Message",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),

        TextButton(
          onPressed: () async {
            final receiver = emailC.text.trim();
            final message = msgC.text.trim();

            await sendInviteEmail(receiver, message);

            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Invite sent to $receiver")),
              );
            }
          },
          child: const Text("Send"),
        ),
      ],
    ),
  );
}
