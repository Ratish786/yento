import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/controller/circle_controller.dart';
import 'package:yento_app/controller/create_plan_controller.dart';

class CreatePlanDialog extends StatefulWidget {
  const CreatePlanDialog({super.key});

  @override
  State<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends State<CreatePlanDialog>
    with SingleTickerProviderStateMixin {
  final planC = Get.find<CreatePlanController>();
  final circleC = Get.find<CircleController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    circleC.fetchCircles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> pickStart() async {
    final date = await showDatePicker(
      context: context,
      initialDate: planC.selectedDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (date != null) planC.selectedDate.value = date;
  }

  Future<void> pickStartTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: planC.selectedTime.value,
    );
    if (time != null) planC.selectedTime.value = time;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create a New Plan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
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
            ),

            // ================= TABS =================
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xff3B82F6),
              unselectedLabelColor: isDark ? Colors.grey[500] : Colors.grey,
              indicatorColor: const Color(0xff3B82F6),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 4),
                      Text("Details"),
                    ],
                  ),
                ),
                Obx(
                      () => Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people, size: 16),
                        const SizedBox(width: 4),
                        Text("People (${planC.selectedUserIds.length})"),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ================= TAB BODY =================
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ============ DETAILS TAB ============
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---------- PLAN TITLE ----------
                        Text(
                          "Plan Title",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: planC.titleController,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "What's the plan?",
                                  hintStyle: TextStyle(
                                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
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
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff3B82F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ---------- DATE & TIME ----------
                        Text(
                          "Date & Time",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: pickStart,
                                child: _inputBox(
                                  icon: Icons.calendar_today,
                                  isDark: isDark,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Date",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark ? Colors.grey[400] : Colors.grey,
                                        ),
                                      ),
                                      Obx(() {
                                        final d = planC.selectedDate.value;
                                        return Text(
                                          "${d.day}/${d.month}/${d.year}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: pickStartTime,
                                child: _inputBox(
                                  icon: Icons.access_time,
                                  isDark: isDark,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Time",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark ? Colors.grey[400] : Colors.grey,
                                        ),
                                      ),
                                      Obx(() {
                                        final t = planC.selectedTime.value;
                                        return Text(
                                          "${t.hour}:${t.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff3B82F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.auto_awesome,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ---------- RECURRING ----------
                        Row(
                          children: [
                            Obx(
                                  () => Checkbox(
                                value: planC.isRecurring.value,
                                onChanged: (v) => planC.isRecurring.value = v!,
                              ),
                            ),
                            Text(
                              "Recurring Plan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),

                        Obx(
                              () => planC.isRecurring.value
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Repeat Type
                              DropdownButton<String>(
                                value: planC.repeatType.value,
                                dropdownColor: isDark ? const Color(0xFF475569) : Colors.white,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                items: ["daily", "weekly", "monthly"]
                                    .map(
                                      (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                    .toList(),
                                onChanged: (v) => planC.repeatType.value = v!,
                              ),

                              const SizedBox(height: 10),

                              // Every X
                              Row(
                                children: [
                                  Text(
                                    "Every",
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 70,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (v) =>
                                      planC.repeatInterval.value =
                                          int.tryParse(v) ?? 1,
                                      style: TextStyle(
                                        color: isDark ? Colors.white : Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: isDark
                                                ? Colors.grey[600]!
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: isDark
                                                ? Colors.grey[600]!
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // Weekly days
                              if (planC.repeatType.value == "weekly")
                                Obx(
                                      () => Wrap(
                                    spacing: 8,
                                    children: List.generate(7, (i) {
                                      final day = ["M", "T", "W", "T", "F", "S", "S"][i];
                                      final selected = planC.repeatDays.contains(i);

                                      return GestureDetector(
                                        onTap: () {
                                          if (selected) {
                                            planC.repeatDays.remove(i);
                                          } else {
                                            planC.repeatDays.add(i);
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: 18,
                                          backgroundColor: selected
                                              ? const Color(0xff3B82F6)
                                              : (isDark
                                              ? Colors.grey[700]
                                              : Colors.grey[300]),
                                          child: Text(
                                            day,
                                            style: TextStyle(
                                              color: selected
                                                  ? Colors.white
                                                  : (isDark
                                                  ? Colors.grey[400]
                                                  : Colors.black),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                            ],
                          )
                              : const SizedBox(),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Location (Optional)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: planC.locationController,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey[500] : Colors.grey[500],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
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
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Notes (Optional)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: planC.notesController,
                          maxLines: 3,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey[500] : Colors.grey[500],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
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
                        ),
                      ],
                    ),
                  ),

                  // ============ PEOPLE TAB ============
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Obx(() {
                      if (circleC.allCircles.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView(
                        children: [
                          // ===== INVITE FRIENDS =====
                          Row(
                            children: [
                              Icon(
                                Icons.person_add_alt,
                                size: 18,
                                color: isDark ? Colors.grey[400] : Colors.grey[700],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Invite Friends",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // ===== CIRCLES =====
                          Text(
                            "CIRCLES",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.grey[500] : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),

                          ...circleC.allCircles.map((circle) {
                            final selected = circleC.selectedCircleIds.contains(circle.id);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xff3B82F6).withOpacity(0.15)
                                    : (isDark
                                    ? const Color(0xFF475569)
                                    : Colors.transparent),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CheckboxListTile(
                                value: selected,
                                onChanged: (_) => circleC.toggleCircle(circle.id),
                                title: Text(
                                  circle.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                subtitle: Text(
                                  "${circle.members.length} members",
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                                secondary: CircleAvatar(
                                  backgroundColor: hexToColor(circle.color),
                                  child: Text(
                                    circle.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            );
                          }),

                          const SizedBox(height: 16),

                          // ===== INDIVIDUALS =====
                          Text(
                            "INDIVIDUALS",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.grey[500] : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),

                          if (circleC.selectedCircleUsers.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Center(
                                child: Text(
                                  "Select a circle to see members",
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[500] : Colors.grey,
                                  ),
                                ),
                              ),
                            ),

                          ...circleC.selectedCircleUsers.map((user) {
                            final name = user["name"] ?? "Unknown";
                            final image = user["image"];

                            return CheckboxListTile(
                              value: true,
                              onChanged: null,
                              title: Text(
                                name,
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              secondary: CircleAvatar(
                                backgroundImage: image != null && image.isNotEmpty
                                    ? NetworkImage(image)
                                    : null,
                                child: image == null || image.isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),

            Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),

            // ================= BUTTONS =================
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF475569) : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (planC.validatePlan()) {
                          await planC.createPlan();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xff3B82F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "Add Plan",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }

  Widget _inputBox({
    required IconData icon,
    required Widget child,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF475569) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? Colors.grey[400] : Colors.grey,
          ),
          const SizedBox(width: 6),
          Expanded(child: child),
        ],
      ),
    );
  }
}

Color hexToColor(String hex) {
  return Color(int.parse('FF$hex', radix: 16));
}