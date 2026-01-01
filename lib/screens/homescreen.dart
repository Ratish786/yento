import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/custom/app_shell.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/components/dialog/ExploreDialog.dart';
import 'package:yento_app/components/dialog/shareLocation.dart';
import 'package:yento_app/screens/MomentsScreen.dart';
import 'package:yento_app/screens/broadcastScreen.dart';
import 'package:yento_app/screens/calenderScreen.dart';
import 'package:yento_app/screens/circleScreen.dart';
import 'package:yento_app/screens/groupPlansScreen.dart';
import '../components/dialog/CreatePlan.dart';
import '../components/models/groupPlanModel.dart';
import '../controller/auth_controller.dart';
import '../controller/create_plan_controller.dart';
import '../controller/theme_controller.dart';
import '../services/Firebase/FirebaseServices.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

void showNotifications(BuildContext context) {
  showDialog(context: context, builder: (_) => const CustomNotificationsBox());
}

class _HomeScreenState extends State<HomeScreen> {
  late final CreatePlanController planC;
  final ThemeController themeC = Get.find<ThemeController>();

  String user = 'User';
  bool isUpNextExpanded = true;
  List<Map<String, String>> dummyPlans = [];

  @override
  void initState() {
    super.initState();
    planC = Get.put(CreatePlanController());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Obx(() => Scaffold(
      backgroundColor: themeC.isDarkMode.value
          ? const Color(0xFF0F172A)
          : const Color(0xFFF9FAFB),
      appBar: _buildAppBar(context),
      body: _buildBody(width),
      bottomNavigationBar: const Custombottombar(currentIndex: 0),
    ));
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: themeC.isDarkMode.value
          ? const Color(0xFF1E293B)
          : Colors.white,
      foregroundColor: themeC.isDarkMode.value
          ? Colors.white
          : const Color(0xFF1F2937),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            const SizedBox(height: 16),
            _buildTilesGrid(),
            const SizedBox(height: 20),
            _buildUpcomingPlansCard(width),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: BroadcastServices().getBroadcastsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: themeC.isDarkMode.value
                          ? const Color(0xFF60A5FA)
                          : const Color(0xFF3B82F6),
                    ),
                  );
                }

                final broadcasts = snapshot.data!.docs;

                if (broadcasts.isEmpty) {
                  return _emptyStateCard("No broadcasts yet");
                }

                final latestBroadcast =
                broadcasts.first.data() as Map<String, dynamic>;

                return _buildLatestBroadcastCard(width, latestBroadcast);
              },
            ),
            const SizedBox(height: 20),
            _buildRecentMomentsCard(width),
            const SizedBox(height: 20),
            _buildTripBudget(context),
            const SizedBox(height: 20),
            _buildPlanSomethingFunCard(width),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GREETING
  // ---------------------------------------------------------------------------
  Widget _buildGreeting() {
    return Text(
      'Good afternoon, $user!',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: themeC.isDarkMode.value ? Colors.white : const Color(0xFF1F2937),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE CARD
  // ---------------------------------------------------------------------------
  Widget _emptyStateCard(String text) {
    return Card(
      elevation: 0,
      color: themeC.isDarkMode.value
          ? const Color(0xFF1E293B)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: themeC.isDarkMode.value
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF64748B),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TILES GRID
  // ---------------------------------------------------------------------------
  Widget _buildTilesGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreatePlanDialog(),
                );
              },
              child: _tile(
                color: Colors.black,
                iconColor: Colors.white,
                icon: Icons.calendar_today_outlined,
                text: 'New Plan',
                textColor: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(Exploredialog());
              },
              child: _tile(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
                icon: Icons.flash_on,
                iconColor: Colors.white,
                text: 'Explore',
                textColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() {
              final userId = AuthController.instance.userId;
              if (userId == null) return const SizedBox();

              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ShareLocationDialog(userId: userId),
                  );
                },
                child: _tile(
                  color: themeC.isDarkMode.value
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  iconColor: Colors.red,
                  icon: Icons.location_on,
                  text: 'Share Location',
                  textColor: themeC.isDarkMode.value
                      ? Colors.white
                      : const Color(0xFF1F2937),
                ),
              );
            }),
            GestureDetector(
              onTap: () {
                Get.to(() => Circlescreen());
              },
              child: _tile(
                color: themeC.isDarkMode.value
                    ? const Color(0xFF1E293B)
                    : Colors.white,
                iconColor: Colors.green,
                icon: Icons.video_camera_back_outlined,
                text: 'Hangout',
                textColor: themeC.isDarkMode.value
                    ? Colors.white
                    : const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tile({
    Color? color,
    Color? iconColor,
    Gradient? gradient,
    required IconData icon,
    required String text,
    required Color textColor,
  }) {
    return Container(
      height: 44,
      width: 165,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PLAN SOMETHING FUN CARD
  // ---------------------------------------------------------------------------
  Widget _buildPlanSomethingFunCard(double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 36),
          const SizedBox(height: 16),
          const Text(
            'Plan something fun!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Let AI help you find the perfect\nactivity for this weekend.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreatePlanDialog(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4F46E5),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Brainstorm Ideas",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LATEST BROADCAST CARD
  // ---------------------------------------------------------------------------
  Widget _buildLatestBroadcastCard(
      double width,
      Map<String, dynamic> broadcast,
      ) {
    final broadcastTitle = broadcast['Title'] ?? '';
    final broadcastAuthor = broadcast['UserName'] ?? 'Unknown';
    final broadcastExcerpt = broadcast['Message'] ?? '';

    return Card(
      elevation: 0,
      color: themeC.isDarkMode.value
          ? const Color(0xFF1E293B)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.rss_feed,
                  color: themeC.isDarkMode.value
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "LATEST BROADCAST",
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      color: themeC.isDarkMode.value
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => BroadcastScreen()),
                  child: Row(
                    children: const [
                      Text(
                        "Read More",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xFF3B82F6),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeC.isDarkMode.value
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: themeC.isDarkMode.value
                      ? const Color(0xFF334155)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    broadcastTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: themeC.isDarkMode.value
                          ? Colors.white
                          : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "by $broadcastAuthor",
                    style: TextStyle(
                      fontSize: 13,
                      color: themeC.isDarkMode.value
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    broadcastExcerpt,
                    style: TextStyle(
                      fontSize: 14,
                      color: themeC.isDarkMode.value
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF6B7280),
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
    );
  }

  // ---------------------------------------------------------------------------
  // UPCOMING PLANS CARD
  // ---------------------------------------------------------------------------
  Widget _buildUpcomingPlansCard(double width) {
    return Card(
      elevation: 0,
      color: themeC.isDarkMode.value
          ? const Color(0xFF1E293B)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'UP NEXT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeC.isDarkMode.value
                            ? Colors.white
                            : const Color(0xFF1F2937),
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
                          color: Color(0xFF3B82F6),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isUpNextExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF3B82F6),
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
            if (isUpNextExpanded) ...[
              const SizedBox(height: 16),
              if (dummyPlans.isEmpty)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "No plans coming up.",
                      style: TextStyle(
                        color: themeC.isDarkMode.value
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF9CA3AF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              if (dummyPlans.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dummyPlans.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _dummyPlanCard(dummyPlans[index]),
                    );
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _dummyPlanCard(Map<String, String> plan) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeC.isDarkMode.value
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeC.isDarkMode.value
              ? const Color(0xFF334155)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
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
                    color: Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  plan["day"]!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan["title"]!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeC.isDarkMode.value
                        ? Colors.white
                        : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${plan["time"]} · ${plan["tag"]}",
                  style: TextStyle(
                    fontSize: 13,
                    color: themeC.isDarkMode.value
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RECENT MOMENTS CARD
  // ---------------------------------------------------------------------------
  Widget _buildRecentMomentsCard(double width) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Card(
      elevation: 0,
      color: themeC.isDarkMode.value
          ? const Color(0xFF1E293B)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: uid == null
                  ? Center(
                child: Text(
                  'No moments available',
                  style: TextStyle(
                    color: themeC.isDarkMode.value
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              )
                  : StreamBuilder(
                stream: MomentServices().getMoments(uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No recent moments to show.',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeC.isDarkMode.value
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs.take(3).toList();

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final moment =
                      docs[index].data() as Map<String, dynamic>;
                      final imgUrl = moment['ImgURL'] ??
                          'https://fastly.picsum.photos/id/570/1200/400.jpg?hmac=yJRcaq6hiuStbSfeYJ-2ADujgsZNvzxXR1yIdwo_6nM';
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imgUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: themeC.isDarkMode.value
                                ? const Color(0xFF334155)
                                : Colors.grey[300],
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
    );
  }

  // ---------------------------------------------------------------------------
  // CARD HEADER
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
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeC.isDarkMode.value
                    ? Colors.white
                    : const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: const [
              Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward,
                color: Color(0xFF3B82F6),
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TRIP BUDGET
  // ---------------------------------------------------------------------------
  Widget _buildTripBudget(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Card(
      elevation: 0,
      color: themeC.isDarkMode.value
          ? const Color(0xFF1E293B)
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.monetization_on_outlined,
                  color: Color(0xFF16A34A),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'TRIP BUDGET',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    color: themeC.isDarkMode.value
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Get.to(() => Groupplansscreen()),
                  child: const Row(
                    children: [
                      Text(
                        'Manage',
                        style: TextStyle(
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF16A34A),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: uid == null
                  ? Center(
                child: Text(
                  'No active plan',
                  style: TextStyle(
                    color: themeC.isDarkMode.value
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              )
                  : StreamBuilder<List<GroupPlan>>(
                stream: GroupPlanService().streamGroupPlans(uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No group plans',
                        style: TextStyle(
                          color: themeC.isDarkMode.value
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    );
                  }

                  final latest = snapshot.data!.first;

                  return Container(
                    decoration: BoxDecoration(
                      color: themeC.isDarkMode.value
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          latest.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: themeC.isDarkMode.value
                                ? const Color(0xFF6EE7B7)
                                : const Color(0xFF166534),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$0',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: themeC.isDarkMode.value
                                ? Colors.white
                                : const Color(0xFF14532D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total spent so far',
                          style: TextStyle(
                            fontSize: 12,
                            color: themeC.isDarkMode.value
                                ? const Color(0xFFA7F3D0)
                                : const Color(0xFF166534),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: month short name
  String _monthShort(int month) {
    const months = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ];
    return months[month - 1];
  }
}