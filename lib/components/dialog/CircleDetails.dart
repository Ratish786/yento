import 'package:flutter/material.dart';
import 'package:yento_app/components/Tabs/CircleBroadcast.dart';
import 'package:yento_app/components/Tabs/CircleChat.dart';
import 'package:yento_app/components/Tabs/CircleMoment.dart';
import 'package:yento_app/components/Tabs/CirclePlan.dart';

void CircleDetails(BuildContext context, String name) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: _CircleDetailsCard(name: name),
      );
    },
  );
}

/// FULL SCREEN CARD INSIDE DIALOG
class _CircleDetailsCard extends StatefulWidget {
  final String name;

  const _CircleDetailsCard({required this.name});

  @override
  State<_CircleDetailsCard> createState() => _CircleDetailsCardState();
}

class _CircleDetailsCardState extends State<_CircleDetailsCard> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.90,
      height: size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // ------------------- HEADER -------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // IconButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   icon: const Icon(Icons.arrow_back, size: 26),
                  // ),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Start Hangout Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffdbeafe),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.videocam_outlined,
                          size: 18,
                          color: Color(0xff1e40af),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Start Hangout",
                          style: TextStyle(
                            color: Color(0xff1e40af),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    onPressed: () {
                      InviteMembers(context, widget.name);
                    },
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      ManageCircle(context, widget.name);
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ------------------- TAB CHIPS -------------------
          SizedBox(
            height: 46,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _tabChip(0, Icons.chat, "Chat"),
                  _tabChip(1, Icons.image_outlined, "Moments"),
                  _tabChip(2, Icons.calendar_month_outlined, "Plans"),
                  _tabChip(3, Icons.wifi, "Broadcast"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),
          Divider(height: 1, color: Colors.grey.shade300),

          // ------------------- TAB CONTENT -------------------
          Expanded(
            child: IndexedStack(
              index: selectedTab,
              children: [
                Circlechat(name: widget.name),
                Circlemoment(),
                Circleplan(),
                Circlebroadcast(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- CUSTOM CHIP BUTTON -------------------
  Widget _tabChip(int index, IconData icon, String label) {
    final bool active = index == selectedTab;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xffdbeafe) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? const Color(0xff1e40af) : Colors.grey.shade300,
            width: 1.4,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? const Color(0xff1e40af) : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? const Color(0xff1e40af) : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------Invite--Members---------
void InviteMembers(BuildContext context, String name) {
  showDialog(
    context: context,
    builder: (context) {
      final size = MediaQuery.of(context).size;

      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              // ------------------- HEADER -------------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Invite Members',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            const Text('to '),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey.shade300),

              // ------------------- MAIN CONTENT (SCROLLABLE) -------------------
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Search Members ----
                      const Text(
                        'Add existing members',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search by name, email or phone...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ---- Invite New Members ----
                      const Text(
                        'Invite new members by email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Separate emails with commas, spaces or press Enter.',
                        style: TextStyle(fontSize: 12),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Add more people...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(height: 1, color: Colors.grey.shade300),

              // ------------------- FOOTER -------------------
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xffbfdbfe),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Send Invites',
                        style: TextStyle(
                          color: Color(0xff1e40af),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ----------------- IMPROVED MANAGE CIRCLE (FULL WORKING) -----------------
void ManageCircle(BuildContext context, String name) {
  bool isLocked = false;
  final pinController = TextEditingController();
  final nameController = TextEditingController(text: name);

  // Dummy Members List
  List<Map<String, dynamic>> members = [
    {"name": "Alex Young", "role": "Member"},
    {"name": "Daniel Cruz", "role": "Admin"},
    {"name": "Emily Woods", "role": "Member"},
    {"name": "Zara Blake", "role": "Member"},
    {"name": "John Doe", "role": "Member"},
  ];

  showDialog(
    context: context,
    builder: (context) {
      final size = MediaQuery.of(context).size;

      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Container(
              width: size.width * 0.9,
              height: size.height * 0.78,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- HEADER ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Manage Circle',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 24),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ---------------- EDIT NAME ----------------
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Circle Name",
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.deepOrange,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),
                  const Divider(),

                  const SizedBox(height: 10),

                  // ---------------- MEMBERS HEADER ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Members (${members.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          InviteMembers(context, name);
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.person_add_alt_1_rounded,
                              color: Color(0xff2563eb),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Invite',
                              style: TextStyle(
                                color: Color(0xff2563eb),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ---------------- MEMBERS LIST (SCROLLABLE) ----------------
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            final user = members[index];

                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.grey,
                              ),
                              title: Text(
                                user["name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(user["role"]),
                              trailing: IconButton(
                                onPressed: () {
                                  setStateDialog(() {
                                    members.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ---------------- LOCK CIRCLE ----------------
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Lock this Circle",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              "Requires a PIN to view this circle.",
                            ),
                            value: isLocked,
                            onChanged: (value) {
                              setStateDialog(() => isLocked = value);
                            },
                          ),

                          // Animated expanding PIN section
                          if (isLocked)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Set a 4-digit PIN",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: pinController,
                                    maxLength: 4,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.deepOrange,
                                        ),
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

                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),

                  // ---------------- FOOTER BUTTONS ----------------
                  Column(
                    children: [
                      // ---------- DELETE + SAVE (HALF WIDTH EACH) ----------
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xfffee2e2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xffb91c1c),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  foregroundColor: const Color(0xffb91c1c),
                                ),
                                child: const Text(
                                  "Delete Circle",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffbfdbfe),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xff1e40af),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  foregroundColor: const Color(0xff1e40af),
                                ),
                                child: const Text(
                                  "Save Changes",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ---------- CANCEL (CENTERED) ----------
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 12,
                              ),
                              foregroundColor: Colors.black87,
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
