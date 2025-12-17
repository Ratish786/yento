import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/custom/app_shell.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/screens/MomentsScreen.dart';
import 'package:yento_app/screens/calenderScreen.dart';
import '../components/dialog/CreatePlan.dart';
import '../controller/create_plan_controller.dart'; // ⭐ contains CreatePlanController + PlanModel

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

void showNotifications(BuildContext context) {
  showDialog(context: context, builder: (_) => const CustomNotificationsBox());
}

class _HomeScreenState extends State<HomeScreen> {
  late final CreatePlanController planC; // ⭐ controller instance
  String user = 'User';

  @override
  void initState() {
    super.initState();
    planC = Get.put(
      CreatePlanController(),
    ); // ⭐ make sure NOT to put again elsewhere
    // planC.loadUsers(); // ⭐ load all users for avatars
  }

  bool isUpNextExpanded = true;
  bool hasDummyPlan = false;

  List<Map<String, String>> dummyPlans = [
    // {
    //   "month": "DEC",
    //   "day": "17",
    //   "title": "fgjhi",
    //   "time": "7:00 PM",
    //   "tag": "Book Club",
    // },
    // {
    //   "month": "DEC",
    //   "day": "17",
    //   "title": "fgjhi",
    //   "time": "7:00 PM",
    //   "tag": "Book Club",
    // },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: _buildBody(width),
      bottomNavigationBar: const Custombottombar(currentIndex: 0),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'Smart Hub',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
          onPressed: () => showNotifications(context),
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // BODY
  // ---------------------------------------------------------------------------
  Widget _buildBody(double width) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            const SizedBox(height: 10),
            TilesGrid(),

            const SizedBox(height: 16),
            _buildUpcomingPlansCard(width), // FIRST: Upcoming plans

            const SizedBox(height: 20),
            _buildLatestBroadcastCard(width), // SECOND: Latest broadcast

            const SizedBox(height: 20),
            _buildRecentMomentsCard(width),

            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // REPLACED: Social Nudges card replaced with the blue "Plan something fun!" card
            // If you want the original Social Nudges back, uncomment the next line:
            // _buildSocialNudgesSection(width),
            // -----------------------------------------------------------------
            _buildPlanSomethingFunCard(width), // ← NEW blue card

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GREETING
  // ---------------------------------------------------------------------------
  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good afternoon, $user!',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TILES GRID
  // ---------------------------------------------------------------------------
  Widget TilesGrid() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined, color: Colors.white),
                      SizedBox(width: 6),
                      Text('New Plan', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 40,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.flash_auto_outlined, color: Colors.white),
                      SizedBox(width: 6),
                      Text('Explore', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 40,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.location_on, color: Colors.black),
                      SizedBox(width: 6),
                      Text(
                        'Share Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera, color: Colors.black),
                      SizedBox(width: 6),
                      Text(
                        'Hangout',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NEW: Blue "Plan something fun!" card — matches screenshot styling
  // ---------------------------------------------------------------------------
  Widget _buildPlanSomethingFunCard(double width) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Crown icon (You can replace this with an image)
            const Icon(Icons.emoji_events, color: Colors.yellow, size: 28),
            const SizedBox(height: 12),

            // Title
            const Text(
              'Plan something fun!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Let AI help you find the perfect\nactivity for this weekend.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 18),

            // CTA Button
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreatePlanDialog(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Brainstorm Ideas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NEW: LATEST BROADCAST CARD
  // ---------------------------------------------------------------------------
  Widget _buildLatestBroadcastCard(double width) {
    final broadcastTitle = "My Trip to the Alps";
    final broadcastAuthor = "by Alex Young";
    final broadcastExcerpt =
        "“It was an incredible experience, the views were breathtaking...”";

    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.rss_feed, color: Color(0xff6b7280)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "LATEST BROADCAST",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff6b7280),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: navigate to broadcast list / detail
                    },
                    child: Row(
                      children: const [
                        Text(
                          "Read More",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.keyboard_arrow_down, color: Colors.blue),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xfff8fafc),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      broadcastTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff111827),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      broadcastAuthor,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff6b7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      broadcastExcerpt,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff6b7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UPCOMING PLANS CARD (scrollable + bottom create text)
  // NOTE: Plan details + ListView UI are commented out and replaced with a simple
  // placeholder UI ("No plans coming up. Plan something!") — backend stream is kept.
  // ---------------------------------------------------------------------------
  Widget _buildUpcomingPlansCard(double width) {
    return SizedBox(
      width: width,
      height: isUpNextExpanded ? 200 : null,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.blue,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'UP NEXT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CalenderScreen()),
                          );
                        },
                        child: const Text(
                          'View Calendar',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          isUpNextExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            isUpNextExpanded = !isUpNextExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // ================= BODY =================
              if (isUpNextExpanded) ...[
                const SizedBox(height: 12),

                // ---------- EMPTY STATE ----------
                if (dummyPlans.isEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 6),
                      const Text(
                        "No plans coming up.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const CreatePlanDialog(),
                          );
                        },
                        child: const Text(
                          "Plan something!",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                // ---------- LIST VIEW ----------
                if (dummyPlans.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dummyPlans.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _dummyPlanCard(dummyPlans[index]),
                      );
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _dummyPlanCard(Map<String, String> plan) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // DATE BADGE
          Container(
            width: 48,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xffE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  plan["month"]!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  plan["day"]!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // PLAN INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan["title"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${plan["time"]} · ${plan["tag"]}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PLAN CARD – full implementation remains in file (kept for future use)
  // ---------------------------------------------------------------------------
  Widget _planCard(BuildContext context, PlanModel plan) {
    final date = plan.startDateTime;
    final timeText =
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    // Recurring label like: Every 2 Weeks
    String recurringText = "";
    if (plan.isRecurring && plan.repeatType != "none") {
      final unit = plan.repeatType; // daily / weekly / monthly
      String unitLabel;
      if (unit == "daily") {
        unitLabel = "Day";
      } else if (unit == "weekly") {
        unitLabel = "Week";
      } else {
        unitLabel = "Month";
      }
      recurringText =
          "Every ${plan.repeatInterval} ${unitLabel}${plan.repeatInterval > 1 ? 's' : ''}";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Title + menu ----------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  plan.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                // onSelected: (value) async {
                //   if (value == 'delete') {
                //     await planC.deletePlan(plan);
                //   }
                // },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'delete', child: Text('Delete plan')),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ---------- Recurring chip ----------
          if (recurringText.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffeef2ff),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.repeat, size: 16, color: Color(0xff4f46e5)),
                  const SizedBox(width: 4),
                  Text(
                    recurringText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff4f46e5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // ---------- Date + Time ----------
          Row(
            children: [
              // Date badge like OCT 24
              Container(
                width: 52,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xfffee2e2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _monthShort(date.month),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffb91c1c),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date.day.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff111827),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffeff6ff),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 20,
                        color: Color(0xff1d4ed8),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Start Time",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff6b7280),
                            ),
                          ),
                          Text(
                            timeText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff111827),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ---------- Repeat Days (for weekly recurring) ----------
          if (plan.isRecurring &&
              plan.repeatType == "weekly" &&
              plan.repeatDays.isNotEmpty) ...[
            const SizedBox(height: 8),

            Row(
              children: const [
                Icon(Icons.event_repeat, size: 18, color: Color(0xff0ea5e9)),
                SizedBox(width: 6),
                Text(
                  'REPEATS ON',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6b7280),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Wrap(
              spacing: 6,
              children: List.generate(7, (index) {
                const labels = ["M", "T", "W", "T", "F", "S", "S"];

                final isSelected = plan.repeatDays.contains(index);

                if (!isSelected) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffe0f2fe),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    labels[index],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0369a1),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 8),
          ],

          const SizedBox(height: 14),

          // ---------- Location ----------
          if (plan.location != null) ...[
            Row(
              children: const [
                Icon(Icons.location_on, size: 18, color: Color(0xfff97316)),
                SizedBox(width: 6),
                Text(
                  'LOCATION',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6b7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(plan.location!, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
          ],

          // ---------- Friends involved ----------
          // if (plan.invitedUserIds.isNotEmpty) ...[
          Row(
            children: const [
              Icon(Icons.group, size: 18, color: Color(0xff22c55e)),
              SizedBox(width: 6),
              Text(
                'FRIENDS INVOLVED',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff6b7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // ⭐ Real avatars using planC.allUsers
          // Obx(() {
          //   final invitedUsers = planC.allUsers
          //       .where((u) => plan.invitedUserIds.contains(u["id"]))
          //       .toList();

          //   if (invitedUsers.isEmpty) {
          //     return const SizedBox.shrink();
          //   }

          //   return Row(
          //     children: [
          //       for (int i = 0; i < invitedUsers.length && i < 3; i++)
          //         Padding(
          //           padding: const EdgeInsets.only(right: 6),
          //           child: CircleAvatar(
          //             radius: 16,
          //             backgroundImage:
          //                 (invitedUsers[i]["ImageUrl"] != null &&
          //                     invitedUsers[i]["ImageUrl"]
          //                         .toString()
          //                         .isNotEmpty)
          //                 ? NetworkImage(invitedUsers[i]["ImageUrl"])
          //                 : null,
          //             child:
          //                 (invitedUsers[i]["ImageUrl"] == null ||
          //                     invitedUsers[i]["ImageUrl"].toString().isEmpty)
          //                 ? const Icon(Icons.person, size: 18)
          //                 : null,
          //           ),
          //         ),

          //       if (invitedUsers.length > 3)
          //         CircleAvatar(
          //           radius: 16,
          //           backgroundColor: Colors.black87,
          //           child: Text(
          //             "+${invitedUsers.length - 3}",
          //             style: const TextStyle(
          //               fontSize: 12,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ),
          //     ],
          //   );
          // }),
          const SizedBox(height: 12),
        ],

        // ---------- Notes ----------
        // if (plan.notes != null && plan.notes!.isNotEmpty) ...[
        //   Row(
        //     children: const [
        //       Icon(
        //         Icons.sticky_note_2_outlined,
        //         size: 18,
        //         color: Color(0xff6366f1),
        //       ),
        //       SizedBox(width: 6),
        //       Text(
        //         'NOTES',
        //         style: TextStyle(
        //           fontSize: 12,
        //           letterSpacing: 0.5,
        //           fontWeight: FontWeight.bold,
        //           color: Color(0xff6b7280),
        //         ),
        //       ),
        //     ],
        //   ),
        //   const SizedBox(height: 6),
        //   Container(
        //     width: double.infinity,
        //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        //     decoration: BoxDecoration(
        //       color: const Color(0xffeef2ff),
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Text(
        //       plan.notes!,
        //       maxLines: 3,
        //       overflow: TextOverflow.ellipsis,
        //     ),
        //   ),
        // ],
      ),
    );
  }

  // helper: month short name
  String _monthShort(int month) {
    const months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC",
    ];
    return months[month - 1];
  }

  // ---------------------------------------------------------------------------
  // RECENT MOMENTS CARD
  // ---------------------------------------------------------------------------
  Widget _buildRecentMomentsCard(double width) {
    return SizedBox(
      height: 150,
      width: width,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              _cardHeader(
                icon: Icons.image_outlined,
                iconColor: Colors.red,
                title: 'Recent Moments',
                actionText: 'View All',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Momentsscreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'No recent moments to show.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SOCIAL NUDGES SECTION (kept in file but not used — uncomment call to re-enable)
  // ---------------------------------------------------------------------------
  Widget _buildSocialNudgesSection(double width) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.front_hand, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Social Nudges',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildReconnectCard(),
            const SizedBox(height: 16),

            _buildBirthdayCard(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RECONNECT CARD
  // ---------------------------------------------------------------------------
  Widget _buildReconnectCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.green[200],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.add, size: 30, color: Color(0xffbbf7d0)),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reconnect!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),
                  const Text(
                    "You haven't planned anything with your work buddies lately.",
                  ),
                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: () => CreatePlanDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffbbf7d0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Plan Now',
                      style: TextStyle(
                        color: Color(0xff166534),
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
  }

  // ---------------------------------------------------------------------------
  // BIRTHDAY CARD
  // ---------------------------------------------------------------------------
  Widget _buildBirthdayCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blue[200],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 30),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Birthday Coming Up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),
                  const Text("It's Diana Prince's birthday soon."),
                  const Text("Time to make some plans."),
                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: () => CreatePlanDialog(),
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
                    child: const Text(
                      'Create Plan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1e40af),
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
  }

  // ---------------------------------------------------------------------------
  // GENERIC CARD HEADER
  // ---------------------------------------------------------------------------
  Widget _cardHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                actionText,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward, color: Colors.blue),
            ],
          ),
        ),
      ],
    );
  }
}
