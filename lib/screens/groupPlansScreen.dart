// lib/screens/groupPlansScreen.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import '../components/custom/app_shell.dart';
import '../components/custom/customBottombar.dart';

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

final img = planImages[Random().nextInt(planImages.length)];

void Notifications(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CustomNotificationsBox(),
  );
}

/// Simple in-memory Plan model
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
  // In-memory list of plans (static for the session)
  final List<Plan> _plans = [
    // ------------Static Card----------------
    // Plan(
    //   title: 'Weekend at the Lake',
    //   destination: 'Blue Lake',
    //   startDate: DateTime(2025, 12, 05),
    //   endDate: DateTime(2025, 12, 07),
    //   description: 'Chill, BBQ and a small hike.',
    //   members: ['Family'],
    // ),
  ];

  double get width => MediaQuery.of(context).size.width;

  double get height => MediaQuery.of(context).size.height;

  // Helper to format date (yyyy-mm-dd)
  String _fmtDate(DateTime? d) => d == null
      ? '-'
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // Create Plan dialog — returns Plan or null
  Future<Plan?> _showCreatePlanDialog() async {
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
                          primary: Color(0xff1e40af), // header background
                          onPrimary: Colors.white, // header text color
                          onSurface: Colors.black87, // body text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Color(
                              0xff1e40af,
                            ), // buttons (Save/Cancel)
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
                        colorScheme: ColorScheme.light(
                          primary: Color(0xff1e40af),
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xff1e40af),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (d != null) setState(() => endDate = d);
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: DefaultTabController(
                  length: 2,
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // HEADER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Create a Group Plan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          const Divider(),

                          // TABS
                          const TabBar(
                            indicatorColor: Color(0xff1e40af),
                            labelColor: Color(0xff1e40af),
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(text: 'Trip Details'),
                              Tab(text: 'Members'),
                            ],
                          ),

                          // TAB CONTENT
                          SizedBox(
                            height: 420, // FIXED HEIGHT FOR TAB CONTENT
                            child: TabBarView(
                              children: [
                                // ---------------- TAB 1 ----------------
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Plan Title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: titleCtrl,
                                        decoration: InputDecoration(
                                          hintText: "e.g. Summer Vacation",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 18),
                                      const Text(
                                        'Destination',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: destCtrl,
                                        decoration: InputDecoration(
                                          hintText: 'e.g., Paris, France',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 18),
                                      const Text(
                                        'Dates',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: pickStart,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(fmt(startDate)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: pickEnd,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(fmt(endDate)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 18),
                                      const Text(
                                        'Description',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: descCtrl,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          hintText: "What's the plan about?",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ---------------- TAB 2 ----------------
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Circle',
                                        style: TextStyle(
                                          color: Colors.grey[200],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: members.keys.map((name) {
                                          return CheckboxListTile(
                                            title: Text(name),
                                            value: members[name],
                                            onChanged: (v) => setState(
                                              () => members[name] = v ?? false,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      Text(
                                        'Individual',
                                        style: TextStyle(
                                          color: Colors.grey[200],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Divider(),

                          // FOOTER BUTTONS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
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

  // Add created plan to in-memory list
  Future<void> _onCreatePlanTap() async {
    final plan = await _showCreatePlanDialog();
    if (plan != null) {
      setState(() => _plans.insert(0, plan)); // newest on top
    }
  }

  // Build each plan card
  Widget _buildPlanCard(Plan p, int index) {
    // stable per-card image selection
    final img = planImages[index % planImages.length];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: width * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
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
              errorBuilder: (c, e, s) =>
                  Container(height: 130, color: Colors.grey[200]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        p.destination.isEmpty ? 'No location' : p.destination,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text('${_fmtDate(p.startDate)} → ${_fmtDate(p.endDate)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(p.description.isEmpty ? 'No description' : p.description),
                if (p.members.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: p.members
                        .map((m) => Chip(label: Text(m)))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Group Plans',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              AppShell.shellScaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Notifications(context),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      // drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Header / create button
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Group Plans',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ElevatedButton.icon(
                    onPressed: _onCreatePlanTap,
                    icon: const Icon(Icons.add, color: Color(0xff1e40af)),
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
              children: const [
                SizedBox(width: 8),
                Icon(Icons.question_mark),
                SizedBox(width: 6),
                Text(
                  'Need some inspiration?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Plans list
            Expanded(
              child: _plans.isEmpty
                  ? const Center(
                      child: Text('No plans yet. Create one to get started.'),
                    )
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
  }
}
