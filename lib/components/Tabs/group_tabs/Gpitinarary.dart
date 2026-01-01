import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Gpitinerary extends StatefulWidget {
  const Gpitinerary({super.key});

  @override
  State<Gpitinerary> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<Gpitinerary> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate = DateTime(2025, 12, 19);
  TimeOfDay? _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay? _endTime = const TimeOfDay(hour: 10, minute: 0);

  final List<_Activity> _activities = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addActivity() {
    final name = _nameController.text.trim();
    if (name.isEmpty ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _activities.add(_Activity(
        date: _selectedDate!,
        startTime: _startTime!,
        endTime: _endTime!,
        name: name,
      ));
      _nameController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity added!')),
    );
  }

  void _removeActivity(int index) {
    setState(() {
      _activities.removeAt(index);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    InputDecoration input(String hintText) => InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF475569) : Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF3B82F6),
          width: 2,
        ),
      ),
      suffixIcon: hintText.contains('Date') || hintText.contains('/')
          ? Icon(
        Icons.calendar_today_rounded,
        color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
        size: 18,
      )
          : hintText.contains('time') || hintText.contains(':')
          ? Icon(
        Icons.access_time_rounded,
        color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
        size: 18,
      )
          : null,
    );

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xff1e3a8a)
                          : const Color(0xffdbeafe),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.event_note,
                      color: isDark
                          ? const Color(0xff60a5fa)
                          : const Color(0xff3B82F6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add Activity',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date + Time row
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextField(
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: input(_selectedDate == null
                              ? 'Date'
                              : DateFormat('dd/MM/yyyy')
                              .format(_selectedDate!)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickStartTime,
                      child: AbsorbPointer(
                        child: TextField(
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: input(_startTime == null
                              ? 'Start time'
                              : _startTime!.format(context)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickEndTime,
                      child: AbsorbPointer(
                        child: TextField(
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: input(_endTime == null
                              ? 'End time'
                              : _endTime!.format(context)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Activity name + Add button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: input('Activity name...'),
                      onSubmitted: (_) => _addActivity(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addActivity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Activities header
              if (_activities.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Scheduled Activities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),

              // Added activities list
              if (_activities.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_available_outlined,
                        size: 64,
                        color: isDark ? Colors.grey[700] : Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No activities planned yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.grey[400]
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your first activity above',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _activities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final a = _activities[i];
                    return _ActivityCard(
                      day: DateFormat('EEE').format(a.date).toUpperCase(),
                      date: DateFormat('dd').format(a.date),
                      time:
                      '${a.startTime.format(context)} - ${a.endTime.format(context)}',
                      name: a.name,
                      isDark: isDark,
                      onDelete: () => _removeActivity(i),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Activity {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String name;

  _Activity({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.name,
  });
}

class _ActivityCard extends StatelessWidget {
  final String day;
  final String date;
  final String time;
  final String name;
  final bool isDark;
  final VoidCallback onDelete;

  const _ActivityCard({
    required this.day,
    required this.date,
    required this.time,
    required this.name,
    required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Date box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xff1e3a8a)
                  : const Color(0xffdbeafe),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xff93c5fd)
                        : const Color(0xff1e40af),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xff60a5fa)
                        : const Color(0xff3B82F6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Activity info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFef4444)),
            onPressed: onDelete,
            tooltip: 'Remove activity',
          ),
        ],
      ),
    );
  }
}