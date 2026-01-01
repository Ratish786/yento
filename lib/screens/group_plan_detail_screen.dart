import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/Tabs/group_tabs/GpBudget.dart';
import 'package:yento_app/components/Tabs/group_tabs/GpChats.dart';
import 'package:yento_app/components/Tabs/group_tabs/GpGuide.dart';
import 'package:yento_app/components/Tabs/group_tabs/GpPoll.dart';
import 'package:yento_app/components/Tabs/group_tabs/GpTasks.dart';
import 'package:yento_app/components/Tabs/group_tabs/Gpitinarary.dart';
import '../components/custom/app_shell.dart';
import '../components/custom/customNotificationsBox.dart';
import '../controller/theme_controller.dart';

class GroupPlanScreenDetails extends StatefulWidget {
  final String title;
  final String imageUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final String destination;

  const GroupPlanScreenDetails({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.destination,
  });

  @override
  State<GroupPlanScreenDetails> createState() => _GroupPlanScreenDetailsState();
}

class _GroupPlanScreenDetailsState extends State<GroupPlanScreenDetails> {
  final ThemeController themeC = Get.find<ThemeController>();
  int selectedTab = 0;

  String _fmtDate(DateTime? d) => d == null
      ? '-'
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (_) => const CustomNotificationsBox(),
    );
  }

  Widget _tabChip(int index, IconData icon, String label) {
    final isDark = themeC.isDarkMode.value;
    final bool active = index == selectedTab;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xffdbeafe)
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active
                ? const Color(0xff1e40af)
                : (isDark ? const Color(0xFF334155) : Colors.grey.shade300),
            width: 1.4,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: active
                  ? const Color(0xff1e40af)
                  : (isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active
                    ? const Color(0xff1e40af)
                    : (isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabContent() {
    switch (selectedTab) {
      case 0:
        return const Gpitinerary();
      case 1:
        return const GPTasks();
      case 2:
        return const GPBudget();
      case 3:
        return const GPGuide();
      case 4:
        return const GPPolls();
      case 5:
        return const GPChats();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height * 0.95;
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      final isDark = themeC.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.grey[200],
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          foregroundColor: isDark ? Colors.white : Colors.black,
          title: Text(
            'Group Plans Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              AppShell.shellScaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _showNotifications,
              icon: Icon(
                Icons.notifications_none,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        body: Center(
          child: Container(
            height: screenHeight * 0.9,
            width: screenWidth * 0.95,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + Details Stack
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        height: 230,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 230,
                          color: isDark
                              ? const Color(0xFF334155)
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.25),
                            Colors.black.withOpacity(0.65),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.3),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.3),
                        child: IconButton(
                          icon: const Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                          ),
                          onPressed: () => _addFriends(context),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.destination.isEmpty
                                      ? 'No destination'
                                      : widget.destination,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_fmtDate(widget.startDate)} → ${_fmtDate(widget.endDate)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Tabs
                SizedBox(
                  height: 46,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        _tabChip(0, Icons.calendar_today_outlined, "Itinerary"),
                        _tabChip(1, Icons.check_circle_outline, "Tasks"),
                        _tabChip(2, Icons.attach_money, "Budget"),
                        _tabChip(3, Icons.menu_book, "Guide"),
                        _tabChip(4, Icons.signal_cellular_alt, "Polls"),
                        _tabChip(5, Icons.chat, "Chats"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tab Content
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Container(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : Colors.grey[50],
                      child: _tabContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

void _addFriends(BuildContext context) {
  final ThemeController themeC = Get.find<ThemeController>();
  final height = MediaQuery.of(context).size.height;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Obx(() {
        final isDark = themeC.isDarkMode.value;
        final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;
        final subtextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
        final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA);
        final borderColor = isDark ? const Color(0xFF334155) : Colors.transparent;

        return Dialog(
          backgroundColor: dialogBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            height: height * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Invite Members',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // To: Test
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'To: ',
                        style: TextStyle(color: subtextColor),
                      ),
                      TextSpan(
                        text: 'Test',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Search
                TextField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Search Venne users...',
                    hintStyle: TextStyle(color: subtextColor),
                    prefixIcon: Icon(Icons.search, color: subtextColor),
                    filled: true,
                    fillColor: inputBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: subtextColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'OR INVITE VIA EMAIL / PHONE',
                        style: TextStyle(
                          fontSize: 12,
                          color: subtextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: subtextColor)),
                  ],
                ),

                const SizedBox(height: 16),

                // Email/Phone Input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Email or Phone number',
                          hintStyle: TextStyle(color: subtextColor),
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE4E8EF),
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: subtextColor),

                // Empty State
                Expanded(
                  child: Center(
                    child: Text(
                      'Search for friends or enter their contact info\nto invite them.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: subtextColor, fontSize: 14),
                    ),
                  ),
                ),

                Divider(color: subtextColor),

                // Bottom Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE4E8EF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF9DB7F5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Send Invites',
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
        );
      });
    },
  );
}