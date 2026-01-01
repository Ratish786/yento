import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yento_app/components/dialog/CreatePlan.dart';
import '../controller/create_plan_controller.dart';
import '../components/custom/app_shell.dart';
import '../components/custom/customBottombar.dart';
import '../components/custom/customNotificationsBox.dart';
import '../screens/plan_Screen.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final CreatePlanController planC = Get.find<CreatePlanController>();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // View mode: 0=Month, 1=Week, 2=Day
  int _viewMode = 0;

  // 🔹 NEW: slide panel state
  bool _showSidePanel = false;
  PlanModel? _selectedPlan;

  /// 🔹 helper (DO NOT CHANGE)
  List<PlanModel> plansForDate(DateTime date, List<PlanModel> plans) {
    return plans
        .where(
          (p) =>
      p.startDateTime.year == date.year &&
          p.startDateTime.month == date.month &&
          p.startDateTime.day == date.day,
    )
        .toList();
  }

  void showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const CustomNotificationsBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Calendar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => AppShell.shellScaffoldKey.currentState!.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () => showNotifications(context),
          ),
        ],
      ),

      body: StreamBuilder<List<PlanModel>>(
        stream: planC.getOwnerPlans().asyncMap((ownerPlans) async {
          final invitedPlans = await planC.getInvitedPlans().first;
          return [...ownerPlans, ...invitedPlans];
        }),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allPlans = snapshot.data!;

          return Stack(
            children: [
              // ================= MAIN CONTENT =================
              Column(
                children: [
                  _monthHeader(isDark),
                  _viewTabs(isDark),
                  const SizedBox(height: 8),

                  TableCalendar<PlanModel>(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2100),
                    headerVisible: false,
                    calendarFormat: _viewMode == 0
                        ? CalendarFormat.month
                        : _viewMode == 1
                        ? CalendarFormat.week
                        : CalendarFormat.week,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                      CalendarFormat.week: 'Week',
                    },

                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

                    onDaySelected: (selectedDay, focusedDay) {
                      final plans = plansForDate(selectedDay, allPlans);

                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;

                        if (plans.isNotEmpty) {
                          _selectedPlan = plans.first;
                          _showSidePanel = true;
                        } else {
                          // Show CreatePlan dialog for free days
                          _showSidePanel = false;
                          _showCreatePlanForDate(selectedDay);
                        }
                      });
                    },

                    eventLoader: (day) => plansForDate(day, allPlans),

                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      defaultTextStyle: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      weekendTextStyle: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      todayDecoration: BoxDecoration(
                        color: const Color(0xff3B82F6).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xff3B82F6),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                      weekendStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return const SizedBox();
                        return Positioned(
                          bottom: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff3B82F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              events.first.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // ================= RIGHT SLIDE PANEL =================
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                right: _showSidePanel ? 0 : -MediaQuery.of(context).size.width,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.85,
                child: _sidePanel(isDark),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: const Custombottombar(currentIndex: 1),
    );
  }

  // ================= SIDE PANEL UI =================
  Widget _sidePanel(bool isDark) {
    if (_selectedPlan == null) return const SizedBox();

    return Material(
      elevation: 8,
      color: isDark ? const Color(0xFF334155) : Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedPlan!.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => setState(() => _showSidePanel = false),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Date & Time with icon
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 20,
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_selectedPlan!.startDateTime.day} "
                            "${_monthName(_selectedPlan!.startDateTime.month)}, "
                            "${_selectedPlan!.startDateTime.year}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                          isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        "${_selectedPlan!.startDateTime.hour.toString().padLeft(2, '0')}:"
                            "${_selectedPlan!.startDateTime.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Location with icon
              if (_selectedPlan!.location != null &&
                  _selectedPlan!.location!.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedPlan!.location!,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                          isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),

              if (_selectedPlan!.location != null &&
                  _selectedPlan!.location!.isNotEmpty)
                const SizedBox(height: 16),

              // Attendees with user pics
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 20,
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${_selectedPlan!.invitedUsers.length} Attendees",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // User profile pictures
              if (_selectedPlan!.invitedUsers.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: _selectedPlan!.invitedUsers.take(5).map((user) {
                    final imageUrl = user.image ?? "";
                    final userName = user.name ?? "?";

                    return CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: imageUrl.isNotEmpty
                          ? (imageUrl.startsWith('assets/')
                          ? AssetImage(imageUrl) as ImageProvider
                          : NetworkImage(imageUrl))
                          : null,
                      child: imageUrl.isEmpty
                          ? Text(
                        userName.isNotEmpty
                            ? userName[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                          : null,
                    );
                  }).toList(),
                ),

              const SizedBox(height: 16),

              // Notes section
              if (_selectedPlan!.notes != null &&
                  _selectedPlan!.notes!.isNotEmpty) ...[
                Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedPlan!.notes!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                ),
              ],

              const Spacer(),

              // Open details button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xff3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsScreen(
                          ownerId: _selectedPlan!.ownerId,
                          planId: _selectedPlan!.id,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Open Full Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _monthHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => setState(
                  () => _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month - 1,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "${_monthName(_focusedDay.month)} ${_focusedDay.year}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => setState(
                  () => _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewTabs(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _viewTab("Month", 0, isDark),
          _viewTab("Week", 1, isDark),
          _viewTab("Day", 2, isDark),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.add,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const CreatePlanDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _viewTab(String text, int mode, bool isDark) {
    final selected = _viewMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _viewMode = mode),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
          ),
          color: selected
              ? const Color(0xff3B82F6)
              : (isDark ? const Color(0xFF334155) : Colors.transparent),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : (isDark ? Colors.grey[400] : Colors.grey),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  // Show CreatePlan dialog with pre-selected date
  void _showCreatePlanForDate(DateTime selectedDate) {
    // Set the selected date in the controller
    planC.selectedDate.value = selectedDate;

    showDialog(context: context, builder: (_) => const CreatePlanDialog());
  }
}