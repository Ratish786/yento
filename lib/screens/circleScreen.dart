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
  final circleC = Get.find<CircleController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Circles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
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
                builder: (_) => const CustomNotificationsBox(),
              );
            },
            icon: Icon(
              Icons.notifications_none,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
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
                color: isDark ? const Color(0xFF334155) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Circles',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => showCreateCircleDialog(context),
                    icon: Icon(
                      Icons.add,
                      color: isDark ? Colors.white : const Color(0xff1e40af),
                    ),
                    label: Text(
                      'Create Circle',
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
                    return Center(
                      child: Text(
                        "No circles yet",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    );
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
                            Navigator.of(context).pushNamed(
                              '/circleDetails',
                              arguments: {'name': c.name},
                            );
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
                                boxShadow: isDark
                                    ? null
                                    : [
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
                                                  (i) {
                                                final member = c.members[i];
                                                final imageUrl =
                                                    member["image"] ?? "";
                                                final name =
                                                    member["name"] ?? "?";

                                                return Positioned(
                                                  left: i * 18.0,
                                                  child: CircleAvatar(
                                                    radius: 14,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                      Colors.grey[300],
                                                      backgroundImage:
                                                      imageUrl.isNotEmpty
                                                          ? NetworkImage(
                                                        imageUrl,
                                                      )
                                                          : null,
                                                      child: imageUrl.isEmpty
                                                          ? Text(
                                                        name.isNotEmpty
                                                            ? name[0]
                                                            .toUpperCase()
                                                            : "?",
                                                        style:
                                                        const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .black,
                                                        ),
                                                      )
                                                          : null,
                                                    ),
                                                  ),
                                                );
                                              },
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
  final isDark = Theme.of(context).brightness == Brightness.dark;

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
        backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xffffffff),
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
                    Text(
                      "Create a New Circle",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        circleC.clearForm();
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ---------- NAME ----------
                TextField(
                  controller: circleC.circleNameController,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    hintText: "Circle Name",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xff3B82F6),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ---------- COLOR ----------
                Text(
                  "Circle Color",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
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
                Text(
                  "Members",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF475569) : Colors.white,
                    border: Border.all(
                      color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.35,
                  ),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("SingupUsers")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final users = snapshot.data!.docs;

                      if (users.isEmpty) {
                        return Center(
                          child: Text(
                            "No users found",
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (_, i) {
                          final data = users[i].data();
                          final user = {
                            "id": users[i].id,
                            "name": data["name"] ?? "Unknown",
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
                              title: Text(
                                user["name"] ?? "Unknown",
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1F2937),
                                ),
                              ),
                              secondary: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                backgroundImage: user["image"] != null &&
                                    user["image"].toString().isNotEmpty
                                    ? (user["image"]
                                    .toString()
                                    .startsWith('assets/')
                                    ? AssetImage(user["image"])
                                as ImageProvider
                                    : NetworkImage(user["image"]))
                                    : null,
                                child: user["image"] == null ||
                                    user["image"].toString().isEmpty
                                    ? Text(
                                  user["name"].toString().isNotEmpty
                                      ? user["name"]
                                      .toString()[0]
                                      .toUpperCase()
                                      : "?",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
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
                    title: Text(
                      "Lock this Circle",
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    subtitle: Text(
                      "Require 4-digit PIN",
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    onChanged: (v) => circleC.lockEnabled.value = v,
                  ),
                ),

                Obx(
                      () => circleC.lockEnabled.value
                      ? TextField(
                    controller: circleC.pinController,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color:
                      isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      hintText: "4-digit PIN",
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.grey[600]!
                              : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff3B82F6),
                          width: 2,
                        ),
                      ),
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
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xff3B82F6),
                      ),
                      onPressed: circleC.createCircle,
                      child: const Text(
                        "Create Circle",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

Color hexToColor(String? hex) {
  if (hex == null || hex.isEmpty) return Colors.blue;
  try {
    return Color(int.parse(hex, radix: 16));
  } catch (e) {
    return Colors.blue;
  }
}

void showCircleLockDialog(BuildContext context, dynamic circle) {
  final pinController = TextEditingController();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        backgroundColor: isDark ? const Color(0xFF334155) : Colors.white,
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Enter the 4-digit PIN for "${circle.name}"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.grey[300] : const Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: pinController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                obscureText: true,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
                decoration: InputDecoration(
                  hintText: "Enter PIN",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  counterText: "",
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff3B82F6),
                      width: 2,
                    ),
                  ),
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
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3B82F6),
                    ),
                    onPressed: () {
                      if (pinController.text == circle.pin) {
                        Get.back(); // close lock dialog
                        Navigator.of(context).pushNamed(
                          '/circleDetails',
                          arguments: {'name': circle.name},
                        );
                      } else {
                        Get.snackbar(
                          "Wrong PIN",
                          "The PIN you entered is incorrect",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: isDark
                              ? const Color(0xFF475569)
                              : Colors.red[100],
                          colorText:
                          isDark ? Colors.white : const Color(0xFF1F2937),
                        );
                      }
                    },
                    child: const Text(
                      "Unlock",
                      style: TextStyle(color: Colors.white),
                    ),
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