import 'package:flutter/material.dart';
import 'package:yento_app/components/dialog/CreatePlan.dart';
import '../components/custom/app_shell.dart';
import '../components/custom/customBottombar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/custom/customNotificationsBox.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

void Notifications(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CustomNotificationsBox(),
  );
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Calendar',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              AppShell.shellScaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Notifications(context);
            },
            icon: Icon(Icons.notifications_none),
          ),
        ],
      ),
      // drawer: CustomDrawer(),
      body: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime(2025),
        lastDay: DateTime(2100),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          CreatePlanDialog();
        },
      ),

      bottomNavigationBar: Custombottombar(currentIndex: 1),
    );
  }
}
