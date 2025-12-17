import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/app_shell.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/components/dialog/CircleDetails.dart';
import 'package:yento_app/controller/circle_controller.dart';
import 'package:yento_app/controller/create_plan_controller.dart';

/// ------------------------------------------------------------
/// NOTE:
/// CircleController is already registered in main.dart using:
/// Get.put(CircleController());
/// ------------------------------------------------------------

class Circlescreen extends StatefulWidget {
  const Circlescreen({super.key});

  @override
  State<Circlescreen> createState() => _CirclescreenState();
}

class _CirclescreenState extends State<Circlescreen> {
  final planC = Get.find<CreatePlanController>();
  final circleC = Get.find<CircleController>(); // ✅ use find

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Circles',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const CustomNotificationsBox(),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ---------------- TOP BAR ----------------
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Circles',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => showCreateCircleDialog(context),
                    icon: const Icon(Icons.add, color: Color(0xff1e40af)),
                    label: const Text(
                      'Create Circle',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1e40af),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xffbfdbfe),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- CIRCLES GRID ----------------
            Expanded(
              child: StreamBuilder(
                stream: circleC.getCircles(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final circles = snapshot.data!;
                  if (circles.isEmpty) {
                    return const Center(child: Text("No circles yet"));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: circles.length,
                    itemBuilder: (context, index) {
                      final c = circles[index];

                      return GestureDetector(
                        onTap: () {
                          if (c.locked && c.pin != null && c.pin!.isNotEmpty) {
                            showCircleLockDialog(context, c);
                          } else {
                            CircleDetails(context, c.name);
                          }
                        },
                        child: Stack(
                          children: [
                            // MAIN CIRCLE
                            Container(
                              height: 210,
                              width: 210,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: hexToColor(c.color),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // NAME + LOCK
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          c.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (c.locked) ...[
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.lock,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    // MEMBER COUNT
                                    Text(
                                      "${c.members.length} members",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // MEMBER AVATARS
                                    SizedBox(
                                      height: 28,
                                      width: double.infinity,
                                      child: Center(
                                        child: SizedBox(
                                          width:
                                              c.members.take(3).length * 18.0 +
                                              10,
                                          child: Stack(
                                            children: List.generate(
                                              c.members.take(3).length,
                                              (i) => Positioned(
                                                left: i * 18.0,
                                                child: CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor: Colors.white,
                                                  child: CircleAvatar(
                                                    radius: 12,
                                                    backgroundImage:
                                                        NetworkImage(
                                                          c.members[i]["image"],
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ⭐ FAVORITE ICON
                            Positioned(
                              top: 2,
                              right: 1,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white.withOpacity(0.9),
                                child: const Icon(
                                  Icons.star_border,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
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

      bottomNavigationBar: const Custombottombar(currentIndex: 2),
    );
  }
}

/// ============================================================
/// CREATE CIRCLE DIALOG (UI SAME AS YOUR DESIGN)
/// ============================================================

Future<void> showCreateCircleDialog(BuildContext context) async {
  final circleC = Get.find<CircleController>();

  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
  ];

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- HEADER ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Create a New Circle",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        circleC.clearForm();
                        Get.back();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ---------- NAME ----------
                TextField(
                  controller: circleC.circleNameController,
                  decoration: InputDecoration(
                    hintText: "Circle Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ---------- COLOR ----------
                const Text(
                  "Circle Color",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Obx(
                  () => Wrap(
                    spacing: 10,
                    children: colors.map((c) {
                      final selected = c == circleC.selectedColor.value;
                      return GestureDetector(
                        onTap: () => circleC.selectedColor.value = c,
                        child: CircleAvatar(
                          radius: selected ? 16 : 14,
                          backgroundColor: c,
                          child: selected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // ---------- MEMBERS ----------
                const Text(
                  "Members",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.35,
                  ),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final users = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (_, i) {
                          final data = users[i].data();
                          final user = {
                            "id": users[i].id,
                            "name": data["Name"] ?? "Unknown",
                            "image": data["ImageUrl"] ?? "",
                          };

                          return Obx(() {
                            final selected = circleC.selectedMembers.any(
                              (e) => e["id"] == user["id"],
                            );

                            return CheckboxListTile(
                              value: selected,
                              onChanged: (v) {
                                if (v == true) {
                                  circleC.selectedMembers.add(user);
                                } else {
                                  circleC.selectedMembers.removeWhere(
                                    (e) => e["id"] == user["id"],
                                  );
                                }
                              },
                              title: Text(user["name"]),
                              secondary: CircleAvatar(
                                backgroundImage: user["image"] != ""
                                    ? NetworkImage(user["image"])
                                    : null,
                                child: user["image"] == ""
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ---------- LOCK ----------
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: circleC.lockEnabled.value,
                    title: const Text("Lock this Circle"),
                    subtitle: const Text("Require 4-digit PIN"),
                    onChanged: (v) => circleC.lockEnabled.value = v,
                  ),
                ),

                Obx(
                  () => circleC.lockEnabled.value
                      ? TextField(
                          controller: circleC.pinController,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "4-digit PIN",
                          ),
                        )
                      : const SizedBox(),
                ),

                const SizedBox(height: 16),

                // ---------- ACTION ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        circleC.clearForm();
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: circleC.createCircle, // 🔥 save to Firebase
                      child: const Text("Create Circle"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// ============================================================
/// HELPERS
/// ============================================================

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16));
}

void showCircleLockDialog(BuildContext context, dynamic circle) {
  final pinController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 40, color: Colors.orange),
              const SizedBox(height: 12),

              Text(
                "Circle Locked",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Enter the 4-digit PIN for "${circle.name}"',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              TextField(
                controller: pinController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter PIN",
                  counterText: "",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (pinController.text == circle.pin) {
                        Get.back(); // close lock dialog
                        CircleDetails(context, circle.name); // open circle
                      } else {
                        Get.snackbar(
                          "Wrong PIN",
                          "The PIN you entered is incorrect",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: const Text("Unlock"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
