import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yento_app/components/Tabs/CircleBroadcast.dart';
import 'package:yento_app/components/Tabs/CircleChat.dart';
import 'package:yento_app/components/Tabs/CircleMoment.dart';
import 'package:yento_app/components/Tabs/CirclePlan.dart';
import 'package:yento_app/components/Tabs/Circle_List.dart';
import 'package:yento_app/components/Tabs/circle_vault.dart';
import 'package:yento_app/screens/Hangout_screen.dart';
import '../custom/app_shell.dart';
import '../custom/customNotificationsBox.dart';
import '../custom/customBottombar.dart';

// ==================== MEMBER MODEL ====================
class Member {
  final String name;
  final String role;
  final String? avatarUrl;

  const Member({required this.name, required this.role, this.avatarUrl});
}

// ==================== MAIN SCREEN ====================
class CircleDetailsScreen extends StatefulWidget {
  final String name;

  const CircleDetailsScreen({super.key, required this.name});

  @override
  State<CircleDetailsScreen> createState() => _CircleDetailsScreenState();
}

class _CircleDetailsScreenState extends State<CircleDetailsScreen> {
  int selectedTab = 0;

  static const List<_TabData> _tabs = [
    _TabData(icon: Icons.chat, label: "Chat"),
    _TabData(icon: Icons.image_outlined, label: "Moments"),
    _TabData(icon: Icons.calendar_month_outlined, label: "Plans"),
    _TabData(icon: Icons.apps, label: "Vault"),
    _TabData(icon: Icons.wifi, label: "Broadcast"),
    _TabData(icon: Icons.list, label: "List"),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(isDark),
      body: _buildBody(isDark),
      bottomNavigationBar: const Custombottombar(currentIndex: 2),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Text(
        'Circle Hub',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
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
          onPressed: () => _showNotifications(),
          icon: Icon(
            Icons.notifications_none,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
      ],
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (_) => const CustomNotificationsBox(),
    );
  }

  Widget _buildBody(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildHeader(isDark),
            const SizedBox(height: 16),
            _buildTabs(isDark),
            const SizedBox(height: 8),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey.shade300,
            ),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(width: 40),
            Row(
              children: [
                _buildHangoutButton(isDark),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                    Icons.person_add_alt_1_rounded,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () =>
                      showInviteMembersDialog(context, widget.name),
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () => showManageCircleDialog(context, widget.name),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHangoutButton(bool isDark) {
    return GestureDetector(
      onTap: () => _startHangout(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1e3a8a) : const Color(0xffdbeafe),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Icon(
              Icons.videocam_outlined,
              size: 18,
              color: isDark ? const Color(0xff60a5fa) : const Color(0xff1e40af),
            ),
            const SizedBox(width: 6),
            Text(
              "Start Hangout",
              style: TextStyle(
                color: isDark ? const Color(0xff93c5fd) : const Color(0xff1e40af),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startHangout() {
    Get.to(() => const Hangoutscreen());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting hangout...')),
    );
  }

  Widget _buildTabs(bool isDark) {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          return _buildTabChip(index, _tabs[index].icon, _tabs[index].label, isDark);
        },
      ),
    );
  }

  Widget _buildTabChip(int index, IconData icon, String label, bool isDark) {
    final bool isActive = index == selectedTab;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? const Color(0xff1e3a8a) : const Color(0xffdbeafe))
              : (isDark ? const Color(0xFF475569) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? const Color(0xff3B82F6)
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? (isDark ? const Color(0xff60a5fa) : const Color(0xff1e40af))
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? (isDark ? const Color(0xff93c5fd) : const Color(0xff1e40af))
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: IndexedStack(
        index: selectedTab,
        children: [
          Circlechat(name: widget.name),
          const Circlemoment(),
          const Circleplan(),
          const Circlevault(),
          const Circlebroadcast(),
          CircleList(circleName: widget.name),
        ],
      ),
    );
  }
}

class _TabData {
  final IconData icon;
  final String label;

  const _TabData({required this.icon, required this.label});
}

// ==================== INVITE MEMBERS DIALOG ====================
void showInviteMembersDialog(BuildContext context, String name) {
  showDialog(
    context: context,
    builder: (context) => _InviteMembersDialog(circleName: name),
  );
}

class _InviteMembersDialog extends StatefulWidget {
  final String circleName;

  const _InviteMembersDialog({required this.circleName});

  @override
  State<_InviteMembersDialog> createState() => _InviteMembersDialogState();
}

class _InviteMembersDialogState extends State<_InviteMembersDialog> {
  final _searchController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: size.width * 0.9,
        constraints: BoxConstraints(maxHeight: size.height * 0.6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(isDark),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey.shade300,
            ),
            _buildContent(isDark),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey.shade300,
            ),
            _buildFooter(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invite Members',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Row(
                children: [
                  Text(
                    'to ',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  Text(
                    widget.circleName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[300] : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              size: 24,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add existing members',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _searchController,
              hintText: 'Search by name, email or phone...',
              prefixIcon: Icons.search,
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            Text(
              'Invite new members by email',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Separate emails with commas, spaces or press Enter.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hintText: 'Add more people...',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        )
            : null,
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[500] : Colors.grey[500],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xff3B82F6),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF475569) : Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _sendInvites,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: isDark
                  ? const Color(0xff2563eb)
                  : const Color(0xffbfdbfe),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Send Invites',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xff1e40af),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendInvites() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invites sent!')),
    );
  }
}

// ==================== MANAGE CIRCLE DIALOG ====================
void showManageCircleDialog(BuildContext context, String name) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  try {
    final userCircleQuery = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .collection('Circles')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (userCircleQuery.docs.isEmpty) {
      Get.snackbar(
        "Error",
        "Circle not found",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final circleData = userCircleQuery.docs.first.data();
    final ownerId = circleData['ownerId'];

    if (ownerId != currentUser.uid) {
      Get.snackbar(
        "Access Denied",
        "Only circle creator can manage settings",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _ManageCircleDialog(
        circleName: name,
        circleId: userCircleQuery.docs.first.id,
      ),
    );
  } catch (e) {
    Get.snackbar(
      "Error",
      "Error loading circle data",
      snackPosition: SnackPosition.TOP,
    );
  }
}

class _ManageCircleDialog extends StatefulWidget {
  final String circleName;
  final String circleId;

  const _ManageCircleDialog({required this.circleName, required this.circleId});

  @override
  State<_ManageCircleDialog> createState() => _ManageCircleDialogState();
}

class _ManageCircleDialogState extends State<_ManageCircleDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.circleName);
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentUser = FirebaseAuth.instance.currentUser!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.78,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.uid)
              .collection('Circles')
              .doc(widget.circleId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final circleData =
                snapshot.data!.data() as Map<String, dynamic>? ?? {};
            final isLocked = circleData['locked'] ?? false;
            final members = List<Map<String, dynamic>>.from(
              circleData['members'] ?? [],
            );

            if (_nameController.text !=
                (circleData['name'] ?? widget.circleName)) {
              _nameController.text = circleData['name'] ?? widget.circleName;
            }
            if (_pinController.text != (circleData['pin'] ?? '')) {
              _pinController.text = circleData['pin'] ?? '';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDark),
                const SizedBox(height: 14),
                _buildNameField(isDark),
                const SizedBox(height: 22),
                Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
                const SizedBox(height: 10),
                _buildMembersHeader(members.length, isDark),
                const SizedBox(height: 8),
                _buildMembersList(members, isDark),
                const SizedBox(height: 18),
                _buildLockSection(isLocked, isDark),
                const SizedBox(height: 10),
                Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
                const SizedBox(height: 10),
                _buildFooterButtons(circleData, members, isLocked, isDark),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Manage Circle',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close,
            size: 24,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(bool isDark) {
    return TextField(
      controller: _nameController,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: "Circle Name",
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey.shade700,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff3B82F6), width: 2),
        ),
      ),
    );
  }

  Widget _buildMembersHeader(int memberCount, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Members ($memberCount)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        InkWell(
          onTap: () => showInviteMembersDialog(context, _nameController.text),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Color(0xff3B82F6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Invite',
                  style: TextStyle(
                    color: const Color(0xff3B82F6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersList(List<Map<String, dynamic>> members, bool isDark) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF475569) : Colors.white,
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey.shade300,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: members.isEmpty
              ? _buildEmptyState(isDark)
              : ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: members.length,
            itemBuilder: (context, index) =>
                _buildMemberTile(index, members, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberTile(int index, List<Map<String, dynamic>> members, bool isDark) {
    final member = members[index];
    final memberName = member['name'] ?? 'Unknown';
    final memberImage = member['image'] ?? '';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        backgroundImage: memberImage.isNotEmpty
            ? NetworkImage(memberImage)
            : null,
        child: memberImage.isEmpty
            ? Text(
          memberName[0].toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
            : null,
      ),
      title: Text(
        memberName,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
      subtitle: Text(
        'Member',
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: IconButton(
        onPressed: () => _confirmRemoveMember(index, members),
        icon: const Icon(Icons.delete_outline, color: Color(0xffef4444)),
      ),
    );
  }

  void _confirmRemoveMember(int index, List<Map<String, dynamic>> members) {
    final member = members[index];
    final memberName = member['name'] ?? 'Unknown';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF334155) : Colors.white,
        title: Text(
          'Remove Member',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          'Remove $memberName from this circle?',
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.black87,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _removeMember(index, members);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Color(0xffef4444)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeMember(
      int index,
      List<Map<String, dynamic>> members,
      ) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final updatedMembers = List<Map<String, dynamic>>.from(members);
      updatedMembers.removeAt(index);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('Circles')
          .doc(widget.circleId)
          .update({'members': updatedMembers});

      await _updateMembersForAllMembers(updatedMembers);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to remove member",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Widget _buildLockSection(bool isLocked, bool isDark) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF475569) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Lock this Circle",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              subtitle: Text(
                "Requires a PIN to view this circle.",
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              value: isLocked,
              onChanged: (value) async {
                await _updateLockStatus(value);
              },
            ),
            if (isLocked) _buildPinField(isDark),
          ],
        ),
      ),
    );
  }

  Future<void> _updateLockStatus(bool locked) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('Circles')
          .doc(widget.circleId)
          .update({'locked': locked, 'pin': locked ? _pinController.text : ''});
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update lock status",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: isDark ? Colors.grey[600] : Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'No members yet',
            style: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Set a 4-digit PIN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _pinController,
            maxLength: 4,
            keyboardType: TextInputType.number,
            obscureText: true,
            onChanged: (value) => _updatePin(value),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xff3B82F6), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePin(String pin) async {
    if (pin.length == 4) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser!;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .collection('Circles')
            .doc(widget.circleId)
            .update({'pin': pin});
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to update PIN",
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  Widget _buildFooterButtons(
      Map<String, dynamic> circleData,
      List<Map<String, dynamic>> members,
      bool isLocked,
      bool isDark,
      ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildDeleteButton(isDark)),
            const SizedBox(width: 10),
            Expanded(child: _buildSaveButton(circleData, members, isLocked, isDark)),
          ],
        ),
        const SizedBox(height: 12),
        _buildCancelButton(isDark),
      ],
    );
  }

  Widget _buildDeleteButton(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF7f1d1d) : const Color(0xFFfee2e2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFef4444)),
      ),
      child: TextButton(
        onPressed: _confirmDeleteCircle,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          foregroundColor: const Color(0xFFef4444),
        ),
        child: const Text(
          "Delete Circle",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSaveButton(
      Map<String, dynamic> circleData,
      List<Map<String, dynamic>> members,
      bool isLocked,
      bool isDark,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff2563eb) : const Color(0xffbfdbfe),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff3B82F6)),
      ),
      child: TextButton(
        onPressed: () => _saveChanges(circleData, members, isLocked),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          foregroundColor: isDark ? Colors.white : const Color(0xff1e40af),
        ),
        child: const Text(
          "Save Changes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCancelButton(bool isDark) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      style: TextButton.styleFrom(
        foregroundColor: isDark ? Colors.grey[400] : Colors.black54,
      ),
      child: const Text(
        "Cancel",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _confirmDeleteCircle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF334155) : Colors.white,
        title: Text(
          'Delete Circle',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          'Are you sure? This action cannot be undone.',
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.black87,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              await _deleteCircle();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xffef4444)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCircle() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .get();
      final batch = FirebaseFirestore.instance.batch();
      final circleName = _nameController.text;

      for (final userDoc in usersSnapshot.docs) {
        final circleQuery = await userDoc.reference
            .collection('Circles')
            .where('name', isEqualTo: circleName)
            .get();
        for (final circleDoc in circleQuery.docs) {
          batch.delete(circleDoc.reference);
        }
      }

      await batch.commit();
      Get.snackbar(
        "Success",
        "Circle deleted successfully",
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete circle",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _saveChanges(
      Map<String, dynamic> circleData,
      List<Map<String, dynamic>> members,
      bool isLocked,
      ) async {
    if (isLocked && _pinController.text.length != 4) {
      Get.snackbar(
        "Validation Error",
        "Please enter a 4-digit PIN",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Circle name cannot be empty",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final updatedData = {
        'name': _nameController.text.trim(),
        'locked': isLocked,
        'pin': isLocked ? _pinController.text : '',
        'members': members,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('Circles')
          .doc(widget.circleId)
          .update(updatedData);

      if (_nameController.text.trim() != widget.circleName) {
        await _updateCircleNameForAllMembers(
          widget.circleName,
          _nameController.text.trim(),
        );
      }

      await _updateMembersForAllMembers(members);
      Navigator.pop(context);
      Get.snackbar(
        "Success",
        "Circle updated successfully!",
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save changes",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _updateCircleNameForAllMembers(
      String oldName,
      String newName,
      ) async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .get();
      final batch = FirebaseFirestore.instance.batch();

      for (final userDoc in usersSnapshot.docs) {
        final circleQuery = await userDoc.reference
            .collection('Circles')
            .where('name', isEqualTo: oldName)
            .get();
        for (final circleDoc in circleQuery.docs) {
          batch.update(circleDoc.reference, {'name': newName});
        }
      }
      await batch.commit();
    } catch (e) {
      print('Error updating circle name: $e');
    }
  }

  Future<void> _updateMembersForAllMembers(
      List<Map<String, dynamic>> members,
      ) async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .get();
      final batch = FirebaseFirestore.instance.batch();
      final circleName = _nameController.text.trim();

      for (final userDoc in usersSnapshot.docs) {
        final circleQuery = await userDoc.reference
            .collection('Circles')
            .where('name', isEqualTo: circleName)
            .get();
        for (final circleDoc in circleQuery.docs) {
          batch.update(circleDoc.reference, {
            'members': members,
            'locked': _pinController.text.isNotEmpty,
            'pin': _pinController.text,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
      await batch.commit();
    } catch (e) {
      print('Error updating members: $e');
    }
  }
}