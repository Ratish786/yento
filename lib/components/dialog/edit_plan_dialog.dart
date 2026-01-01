import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/controller/create_plan_controller.dart';

class EditPlanDialog extends StatefulWidget {
  final PlanModel plan;

  const EditPlanDialog({super.key, required this.plan});

  @override
  State<EditPlanDialog> createState() => _EditPlanDialogState();
}

class _EditPlanDialogState extends State<EditPlanDialog> {
  late CreatePlanController planController;

  // Controllers
  late final TextEditingController titleCtrl;
  late final TextEditingController locationCtrl;
  late final TextEditingController notesCtrl;

  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late bool isRecurring;
  late String repeatType;
  late int repeatInterval;
  late List<int> repeatDays;

  // Attendees from plan with selection state
  late List<InvitedUser> attendees;
  late List<bool> attendeeSelection;

  @override
  void initState() {
    super.initState();
    planController = Get.find<CreatePlanController>();

    // Initialize with plan data
    titleCtrl = TextEditingController(text: widget.plan.title);
    locationCtrl = TextEditingController(text: widget.plan.location ?? '');
    notesCtrl = TextEditingController(text: widget.plan.notes ?? '');

    selectedDate = widget.plan.startDateTime;
    selectedTime = TimeOfDay.fromDateTime(widget.plan.startDateTime);
    isRecurring = widget.plan.isRecurring ?? false;
    repeatType = ['daily', 'weekly', 'monthly'].contains(widget.plan.repeatType)
        ? widget.plan.repeatType!
        : 'daily';
    repeatInterval = widget.plan.repeatInterval ?? 1;
    repeatDays = widget.plan.repeatDays != null
        ? List.from(widget.plan.repeatDays)
        : [];

    attendees = List.from(widget.plan.invitedUsers);
    attendeeSelection = List.filled(attendees.length, true);
  }

  Future<void> _saveChanges() async {
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final selectedAttendees = <InvitedUser>[];
    for (int i = 0; i < attendees.length; i++) {
      if (attendeeSelection[i]) {
        selectedAttendees.add(attendees[i]);
      }
    }

    final success = await planController.updatePlan(
      ownerId: widget.plan.ownerId,
      planId: widget.plan.id,
      title: titleCtrl.text.trim(),
      startDateTime: startDateTime,
      isRecurring: isRecurring,
      repeatType: repeatType,
      repeatInterval: repeatInterval,
      repeatDays: repeatDays,
      location: locationCtrl.text.trim(),
      notes: notesCtrl.text.trim(),
      invitedUsers: selectedAttendees,
    );

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Edit Plan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),

            // ================= BODY =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------- TITLE --------
                    _label("Title", isDark),
                    TextField(
                      controller: titleCtrl,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: _inputDecoration(isDark: isDark),
                    ),

                    const SizedBox(height: 16),

                    // -------- DATE & TIME --------
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("Date", isDark),
                              TextField(
                                readOnly: true,
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                  );
                                  if (date != null) {
                                    setState(() => selectedDate = date);
                                  }
                                },
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: _inputDecoration(
                                  text:
                                  "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                                  icon: Icons.calendar_today,
                                  isDark: isDark,
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
                              _label("Time", isDark),
                              TextField(
                                readOnly: true,
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTime,
                                  );
                                  if (time != null) {
                                    setState(() => selectedTime = time);
                                  }
                                },
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: _inputDecoration(
                                  text:
                                  "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}",
                                  icon: Icons.access_time,
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // -------- RECURRING --------
                    Row(
                      children: [
                        Checkbox(
                          value: isRecurring,
                          onChanged: (v) {
                            setState(() => isRecurring = v!);
                          },
                        ),
                        Text(
                          "Recurring plan",
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),

                    // Recurring options
                    if (isRecurring) ...[
                      const SizedBox(height: 16),
                      _label("Repeats", isDark),
                      DropdownButtonFormField<String>(
                        value: repeatType,
                        decoration: _inputDecoration(isDark: isDark),
                        dropdownColor: isDark ? const Color(0xFF475569) : Colors.white,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "daily",
                            child: Text("Daily"),
                          ),
                          DropdownMenuItem(
                            value: "weekly",
                            child: Text("Weekly"),
                          ),
                          DropdownMenuItem(
                            value: "monthly",
                            child: Text("Monthly"),
                          ),
                        ],
                        onChanged: (v) => setState(() => repeatType = v!),
                      ),
                      const SizedBox(height: 12),
                      _label("Every", isDark),
                      TextField(
                        decoration: _inputDecoration(isDark: isDark),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        controller: TextEditingController(
                          text: repeatInterval.toString(),
                        ),
                        onChanged: (v) => repeatInterval = int.tryParse(v) ?? 1,
                      ),
                      if (repeatType == 'weekly') ...[
                        const SizedBox(height: 12),
                        _label("On Days", isDark),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _dayButton('S', 0, isDark),
                            _dayButton('M', 1, isDark),
                            _dayButton('T', 2, isDark),
                            _dayButton('W', 3, isDark),
                            _dayButton('T', 4, isDark),
                            _dayButton('F', 5, isDark),
                            _dayButton('S', 6, isDark),
                          ],
                        ),
                      ],
                    ],

                    const SizedBox(height: 12),

                    // -------- LOCATION --------
                    _label("Location (Optional)", isDark),
                    TextField(
                      controller: locationCtrl,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: _inputDecoration(isDark: isDark),
                    ),

                    const SizedBox(height: 12),

                    // -------- NOTES --------
                    _label("Notes (Optional)", isDark),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 3,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: _inputDecoration(isDark: isDark),
                    ),

                    const SizedBox(height: 20),

                    // -------- SUGGEST TIMES --------
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.schedule,
                        color: Color(0xff3B82F6),
                      ),
                      label: const Text(
                        "Suggest Times",
                        style: TextStyle(color: Color(0xff3B82F6)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= ATTENDEES =================
                    _label("Attendees", isDark),
                    const SizedBox(height: 8),

                    Column(
                      children: List.generate(attendees.length, (index) {
                        final user = attendees[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF475569) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CheckboxListTile(
                            value: attendeeSelection[index],
                            onChanged: (bool? value) {
                              setState(() {
                                attendeeSelection[index] = value ?? true;
                              });
                            },
                            secondary: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                              user.image != null && user.image!.isNotEmpty
                                  ? NetworkImage(user.image!)
                                  : null,
                              child: user.image == null || user.image!.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(
                              user.name,
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            subtitle: Text(
                              'Status: ${user.status}',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // ================= FOOTER =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3B82F6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayButton(String day, int dayIndex, bool isDark) {
    final isSelected = repeatDays.contains(dayIndex);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            repeatDays.remove(dayIndex);
          } else {
            repeatDays.add(dayIndex);
          }
        });
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? const Color(0xff3B82F6)
              : (isDark ? Colors.grey[700] : Colors.grey[200]),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[400] : Colors.black),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------
  Widget _label(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey[400] : Colors.grey,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? text,
    IconData? icon,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: text,
      hintStyle: TextStyle(
        color: isDark ? Colors.grey[500] : Colors.grey[500],
      ),
      suffixIcon: icon != null
          ? Icon(
        icon,
        size: 18,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      )
          : null,
      filled: true,
      fillColor: isDark ? const Color(0xFF475569) : const Color(0xffF9FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.transparent,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xff3B82F6),
          width: 2,
        ),
      ),
    );
  }
}