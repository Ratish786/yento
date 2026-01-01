import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/PremiumCard.dart';
import 'package:yento_app/components/custom/PremiumSnackbar.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/screens/group_plan_detail_screen.dart';
import '../components/custom/app_shell.dart';
import '../components/custom/customBottombar.dart';
import '../controller/theme_controller.dart';

class Groupplansscreen extends StatefulWidget {
  const Groupplansscreen({super.key});

  @override
  State<Groupplansscreen> createState() => _GroupplansscreenState();
}

final List<String> planImages = [
  "https://picsum.photos/id/1018/1200/400",
  "https://picsum.photos/id/1025/1200/400",
  "https://picsum.photos/id/1035/1200/400",
  "https://picsum.photos/id/1043/1200/400",
  "https://picsum.photos/id/1056/1200/400",
  "https://picsum.photos/id/1062/1200/400",
  "https://picsum.photos/id/1080/1200/400",
  "https://picsum.photos/id/1084/1200/400",
  "https://picsum.photos/seed/sdcd/800/400",
];

void Notifications(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CustomNotificationsBox(),
  );
}

class Plan {
  final String title;
  final String destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final String description;
  final List<String> members;

  Plan({
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.members,
  });
}

class _GroupplansscreenState extends State<Groupplansscreen> {
  final ThemeController themeC = Get.find<ThemeController>();
  final List<Plan> _plans = [];

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  String _fmtDate(DateTime? d) => d == null
      ? '-'
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<Plan?> _showCreatePlanDialog() async {
    final isDark = themeC.isDarkMode.value;
    final titleCtrl = TextEditingController();
    final destCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    DateTime? startDate;
    DateTime? endDate;

    final Map<String, bool> members = {
      'Family': false,
      'Friends': false,
      'Book Club': false,
      'Work Buddies': false,
    };

    String fmt(DateTime? d) =>
        d == null ? "Select" : "${d.day}/${d.month}/${d.year}";

    return await showDialog<Plan>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              Future pickStart() async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xff1e40af),
                          onPrimary: Colors.white,
                          onSurface: Colors.black87,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xff1e40af),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (d != null) setState(() => startDate = d);
              }

              Future pickEnd() async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: endDate ?? (startDate ?? DateTime.now()),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xff1e40af),
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xff1e40af),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (d != null) setState(() => endDate = d);
              }

              final inputBorder = OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF334155) : Colors.grey,
                ),
              );

              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: DefaultTabController(
                  length: 2,
                  child: SingleChildScrollView(
                    child: Container(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      padding: const EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Create a Group Plan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
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
                          const SizedBox(height: 8),
                          Divider(
                            color: isDark
                                ? const Color(0xFF334155)
                                : Colors.grey.shade300,
                          ),
                          TabBar(
                            indicatorColor: const Color(0xff1e40af),
                            labelColor: const Color(0xff1e40af),
                            unselectedLabelColor: isDark
                                ? const Color(0xFF94A3B8)
                                : Colors.grey,
                            tabs: const [
                              Tab(text: 'Trip Details'),
                              Tab(text: 'Members'),
                            ],
                          ),
                          SizedBox(
                            height: 420,
                            child: TabBarView(
                              children: [
                                // TAB 1
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Text(
                                        'Plan Title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: titleCtrl,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "e.g. Summer Vacation",
                                          hintStyle: TextStyle(
                                            color: isDark
                                                ? const Color(0xFF64748B)
                                                : Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? const Color(0xFF0F172A)
                                              : Colors.white,
                                          border: inputBorder,
                                          enabledBorder: inputBorder,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        'Destination',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: destCtrl,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'e.g., Paris, France',
                                          hintStyle: TextStyle(
                                            color: isDark
                                                ? const Color(0xFF64748B)
                                                : Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? const Color(0xFF0F172A)
                                              : Colors.white,
                                          border: inputBorder,
                                          enabledBorder: inputBorder,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        'Dates',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: pickStart,
                                              child: Container(
                                                padding:
                                                const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: isDark
                                                      ? const Color(0xFF0F172A)
                                                      : Colors.white,
                                                  border: Border.all(
                                                    color: isDark
                                                        ? const Color(
                                                      0xFF334155,
                                                    )
                                                        : Colors.grey,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  fmt(startDate),
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: pickEnd,
                                              child: Container(
                                                padding:
                                                const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: isDark
                                                      ? const Color(0xFF0F172A)
                                                      : Colors.white,
                                                  border: Border.all(
                                                    color: isDark
                                                        ? const Color(
                                                      0xFF334155,
                                                    )
                                                        : Colors.grey,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  fmt(endDate),
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        'Description',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: descCtrl,
                                        maxLines: 3,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "What's the plan about?",
                                          hintStyle: TextStyle(
                                            color: isDark
                                                ? const Color(0xFF64748B)
                                                : Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? const Color(0xFF0F172A)
                                              : Colors.white,
                                          border: inputBorder,
                                          enabledBorder: inputBorder,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // TAB 2
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Circle',
                                        style: TextStyle(
                                          color: isDark
                                              ? const Color(0xFF64748B)
                                              : Colors.grey[600],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: members.keys.map((name) {
                                          return CheckboxListTile(
                                            title: Text(
                                              name,
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            value: members[name],
                                            onChanged: (v) => setState(
                                                  () =>
                                              members[name] = v ?? false,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: isDark
                                ? const Color(0xFF334155)
                                : Colors.grey.shade300,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark
                                      ? const Color(0xFF334155)
                                      : Colors.grey[300],
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (titleCtrl.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Plan title is required'),
                                      ),
                                    );
                                    return;
                                  }

                                  final selected = members.entries
                                      .where((e) => e.value)
                                      .map((e) => e.key)
                                      .toList();

                                  Navigator.pop(
                                    context,
                                    Plan(
                                      title: titleCtrl.text.trim(),
                                      destination: destCtrl.text.trim(),
                                      startDate: startDate,
                                      endDate: endDate,
                                      description: descCtrl.text.trim(),
                                      members: selected,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff3b82f6),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Add Plan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _onCreatePlanTap() async {
    final plan = await _showCreatePlanDialog();
    if (plan != null) {
      setState(() => _plans.insert(0, plan));
    }
  }

  Widget _buildPlanCard(Plan p, int index) {
    final isDark = themeC.isDarkMode.value;
    final img = planImages[index % planImages.length];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupPlanScreenDetails(
              title: p.title,
              imageUrl: img,
              startDate: p.startDate,
              endDate: p.endDate,
              destination: p.destination,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: width * 0.95,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isDark
              ? []
              : const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              child: Image.network(
                img,
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 130,
                  color: isDark
                      ? const Color(0xFF334155)
                      : Colors.grey[200],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          p.destination.isEmpty
                              ? 'No location'
                              : p.destination,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_fmtDate(p.startDate)} → ${_fmtDate(p.endDate)}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.description.isEmpty
                        ? 'No description'
                        : p.description,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : Colors.black54,
                    ),
                  ),
                  if (p.members.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: p.members
                          .map(
                            (m) => Chip(
                          label: Text(m),
                          backgroundColor: isDark
                              ? const Color(0xFF334155)
                              : Colors.blue.shade50,
                          labelStyle: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeC.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.grey[200],
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          foregroundColor: isDark ? Colors.white : Colors.black,
          title: Text(
            'Group Plans',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
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
          actions: [
            IconButton(
              onPressed: () => Notifications(context),
              icon: Icon(
                Icons.notifications_none,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Group Plans',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _onCreatePlanTap,
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xff1e40af),
                      ),
                      label: const Text(
                        'Create Plan',
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
              const SizedBox(height: 14),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    Icons.question_mark,
                    color: isDark ? Colors.white70 : Colors.black,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Need some inspiration?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _plans.isEmpty
                    ? _NoPlan(context, isDark)
                    : ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: _plans.length,
                  itemBuilder: (context, idx) =>
                      _buildPlanCard(_plans[idx], idx),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Custombottombar(),
      );
    });
  }
}

Widget _NoPlan(BuildContext context, bool isDark) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.4,
    width: MediaQuery.of(context).size.width * 0.9,
    child: Card(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No group plans yet.',
              style: TextStyle(
                fontSize: 20,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Upgrade to Venne+ to create your own trip, or wait for an invite!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                PremiumSnackBar(context);
              },
              child: const Text(
                'Upgrade Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2563eb),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}