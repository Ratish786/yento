import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yento_app/components/custom/app_shell.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/dialog/edit_plan_dialog.dart';
import '../controller/create_plan_controller.dart';
import '../controller/theme_controller.dart';

class EventDetailsScreen extends StatefulWidget {
  final String ownerId;
  final String planId;

  const EventDetailsScreen({
    super.key,
    required this.ownerId,
    required this.planId,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final ThemeController themeC = Get.find<ThemeController>();
  bool showFlightForm = false;
  PlanModel? plan;
  late CreatePlanController planController;
  String? editingFlightId;
  String? _temperature;
  final String _weatherApiKey = '8ba4ca67b13e6e669404feed20bc005c';

  final airlineCtrl = TextEditingController();
  final flightCtrl = TextEditingController();
  final confCtrl = TextEditingController();
  final checklistCtrl = TextEditingController();
  final imageUrlCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    planController = Get.find<CreatePlanController>();
    _loadPlan();
  }

  Future<void> _fetchWeatherData(String location) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$_weatherApiKey&units=metric',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = '${data['main']['temp'].round()}°C';
        });
      }
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  Future<Map<String, dynamic>?> _fetchUserData(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('SingupUsers')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        return {
          'name': data?['name'] ?? data?['displayName'] ?? 'Unknown User',
          'image':
          data?['ImageUrl'] ??
              data?['photoURL'] ??
              data?['image'] ??
              data?['profileImage'] ??
              '',
        };
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return {'name': 'Unknown User', 'image': ''};
  }

  Future<void> _loadPlan() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.ownerId)
        .collection('plans')
        .doc(widget.planId)
        .get();

    if (doc.exists) {
      setState(() {
        plan = PlanModel.fromDoc(doc);
      });

      if (plan!.location != null && plan!.location!.isNotEmpty) {
        _fetchWeatherData(plan!.location!);
      }
    }
  }

  Future<void> _saveFlightDetails() async {
    if (plan == null) return;

    if (editingFlightId != null) {
      await planController.updateFlightDetail(
        ownerId: widget.ownerId,
        planId: widget.planId,
        flightId: editingFlightId!,
        airline: airlineCtrl.text.trim(),
        flightNumber: flightCtrl.text.trim(),
        confirmationCode: confCtrl.text.trim(),
      );
    } else {
      await planController.addFlightDetail(
        ownerId: widget.ownerId,
        planId: widget.planId,
        airline: airlineCtrl.text.trim(),
        flightNumber: flightCtrl.text.trim(),
        confirmationCode: confCtrl.text.trim(),
      );
    }

    setState(() {
      showFlightForm = false;
      editingFlightId = null;
      airlineCtrl.clear();
      flightCtrl.clear();
      confCtrl.clear();
    });
  }

  Future<void> _addChecklistItem() async {
    if (checklistCtrl.text.isEmpty || plan == null) return;

    await planController.addChecklistItem(
      ownerId: widget.ownerId,
      planId: widget.planId,
      title: checklistCtrl.text.trim(),
    );

    setState(() {
      checklistCtrl.clear();
    });
  }

  Future<void> _addSharedImage() async {
    if (imageUrlCtrl.text.isEmpty || plan == null) return;

    await planController.addSharedMedia(
      ownerId: widget.ownerId,
      planId: widget.planId,
      type: 'image',
      value: imageUrlCtrl.text.trim(),
    );

    setState(() {
      imageUrlCtrl.clear();
    });
  }

  Future<void> _showDeleteDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Plan'),
          content: const Text('Are you sure you want to delete this plan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePlan();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePlan() async {
    if (plan == null) return;

    try {
      print('Attempting to delete plan: ${widget.planId} for owner: ${widget.ownerId}');
      
      // Delete the plan document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.ownerId)
          .collection('plans')
          .doc(widget.planId)
          .delete();
      
      print('Plan deleted successfully');
      
      // Delete invitations for all invited users
      if (plan!.invitedUsers.isNotEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        for (final user in plan!.invitedUsers) {
          if (user.userId != widget.ownerId) {
            final inviteRef = FirebaseFirestore.instance
                .collection('users')
                .doc(user.userId)
                .collection('invitations')
                .doc(widget.planId);
            batch.delete(inviteRef);
          }
        }
        await batch.commit();
        print('Invitations deleted successfully');
      }
      
      Get.snackbar(
        'Success',
        'Plan deleted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      Navigator.of(context).pop();
    } catch (e) {
      print('Error deleting plan: $e');
      Get.snackbar(
        'Error',
        'Failed to delete plan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";

  String formatTime(DateTime d) {
    final hour = d.hour > 12 ? d.hour - 12 : d.hour;
    final period = d.hour >= 12 ? "PM" : "AM";
    return "$hour:${d.minute.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeC.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xffF5F6FA),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          foregroundColor: isDark ? Colors.white : Colors.black,
          title: Text("Smart Trip", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                AppShell.shellScaffoldKey.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu, color: isDark ? Colors.white : Colors.black),
            ),
          ),
          actions: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Container(
                width: 140,
                height: 40,
                decoration: BoxDecoration(color: Colors.pink),
                child: Row(
                  children: const [
                    SizedBox(width: 10),
                    Icon(Icons.photo_camera_outlined, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Post Moment",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => EditPlanDialog(plan: plan!),
                );

                if (result == true) {
                  _loadPlan();
                }
              },
              icon: Icon(Icons.edit, color: isDark ? Colors.white : Colors.black),
            ),
            IconButton(
              onPressed: _showDeleteDialog,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => const CustomNotificationsBox(),
              ),
              icon: Icon(Icons.notifications_none, color: isDark ? Colors.white : Colors.black),
            ),
          ],
        ),
        bottomNavigationBar: const Custombottombar(currentIndex: 0),
        body: plan == null
            ? Center(
          child: CircularProgressIndicator(
            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              weatherCard(),
              infoTile(
                Icons.calendar_today,
                "DATE",
                formatDate(plan!.startDateTime),
              ),
              infoTile(
                Icons.access_time,
                "TIME",
                formatTime(plan!.startDateTime),
              ),
              if (plan!.isRecurring)
                infoTile(
                  Icons.repeat,
                  "REPEATS",
                  "Every ${plan!.repeatInterval} ${plan!.repeatType}",
                ),
              if (plan!.location != null && plan!.location!.isNotEmpty)
                infoTile(Icons.location_on, "LOCATION", plan!.location!),
              const SizedBox(height: 20),
              attendeesCard(),
              const SizedBox(height: 20),
              notesCard(),
              const SizedBox(height: 20),
              flightDetailsCard(),
              const SizedBox(height: 20),
              travelChecklistCard(),
              const SizedBox(height: 20),
              exportCalendarCard(),
              const SizedBox(height: 20),
              sharedAlbumCard(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      );
    });
  }

  Widget weatherCard() {
    if (plan == null) return const SizedBox();
    final isDark = themeC.isDarkMode.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FORECAST",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _temperature ?? "18°C",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Sunny",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  plan!.location ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wb_sunny, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget infoTile(IconData icon, String title, String value) {
    final isDark = themeC.isDarkMode.value;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFF94A3B8) : Colors.black,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
    );
  }

  Widget attendeesCard() {
    if (plan == null) return const SizedBox();
    final isDark = themeC.isDarkMode.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attendees (${plan!.invitedUsers.length})",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.link, size: 18, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add_alt, size: 18),
                    label: const Text("Invite"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xffF6F7FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: plan!.invitedUsers.isEmpty
                ? Center(
              child: Text(
                "No attendees yet",
                style: TextStyle(
                  color: isDark ? const Color(0xFF64748B) : Colors.grey,
                ),
              ),
            )
                : Column(
              children: plan!.invitedUsers
                  .map(
                    (user) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FutureBuilder<Map<String, dynamic>?>(
                    future: _fetchUserData(user.userId),
                    builder: (context, snapshot) {
                      final userData = snapshot.data;
                      final displayName =
                          userData?['name'] ??
                              (user.name.isNotEmpty
                                  ? user.name
                                  : 'Unknown User');
                      return attendeeItem(
                        name: displayName,
                        image: userData?['image'] ?? user.image,
                        status: user.status,
                      );
                    },
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget attendeeItem({
    required String name,
    String? image,
    required String status,
  }) {
    final isDark = themeC.isDarkMode.value;
    final imageUrl = image ?? "";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xffE0E0E0),
            backgroundImage: imageUrl.isNotEmpty
                ? (imageUrl.startsWith('assets/')
                ? AssetImage(imageUrl) as ImageProvider
                : NetworkImage(imageUrl))
                : null,
            child: imageUrl.isEmpty
                ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: _getStatusTextColor(status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return const Color(0xffD1FAE5);
      case 'rejected':
        return const Color(0xffFEE2E2);
      default:
        return const Color(0xffFFEEC2);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'accepted':
        return const Color(0xff065F46);
      case 'rejected':
        return const Color(0xffDC2626);
      default:
        return const Color(0xff8A6D00);
    }
  }

  Widget notesCard() {
    if (plan == null || plan!.notes == null || plan!.notes!.isEmpty)
      return const SizedBox();
    final isDark = themeC.isDarkMode.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF422006) : const Color(0xffFFF7D6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "NOTES",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFFFBBF24) : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            plan!.notes!,
            style: TextStyle(
              color: isDark ? const Color(0xFFFEF3C7) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget flightDetailsCard() {
    final isDark = themeC.isDarkMode.value;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark ? const Color(0xFF1E293B) : const Color(0xffEEF2F7),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xffEEF2F7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flight, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      "Flight Details",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showFlightForm = !showFlightForm;
                      if (showFlightForm) {
                        planController
                            .getFlightDetails(
                          ownerId: widget.ownerId,
                          planId: widget.planId,
                        )
                            .first
                            .then((flights) {
                          if (flights.isNotEmpty) {
                            final flight = flights.first;
                            editingFlightId = flight['id'];
                            airlineCtrl.text = flight['airline'] ?? '';
                            flightCtrl.text = flight['flightNumber'] ?? '';
                            confCtrl.text =
                                flight['confirmationCode'] ?? '';
                          } else {
                            editingFlightId = null;
                            airlineCtrl.clear();
                            flightCtrl.clear();
                            confCtrl.clear();
                          }
                        });
                      }
                    });
                  },
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: planController.getFlightDetails(
                      ownerId: widget.ownerId,
                      planId: widget.planId,
                    ),
                    builder: (context, snapshot) {
                      final hasFlights =
                          snapshot.hasData && snapshot.data!.isNotEmpty;
                      return Text(
                        hasFlights ? "Edit Flight" : "Add Flight",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xffF9FAFC),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: showFlightForm
                ? flightFormUI()
                : StreamBuilder<List<Map<String, dynamic>>>(
              stream: planController.getFlightDetails(
                ownerId: widget.ownerId,
                planId: widget.planId,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No flight details added.",
                      style: TextStyle(
                        color: isDark ? const Color(0xFF64748B) : Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }

                final flights = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: flights.map(
                        (flight) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  if (flight['airline']?.isNotEmpty ==
                                      true)
                                    Text(
                                      flight['airline'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  if (flight['flightNumber']
                                      ?.isNotEmpty ==
                                      true)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                      ),
                                      child: Text(
                                        flight['flightNumber'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (flight['confirmationCode']
                                ?.isNotEmpty ==
                                true)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF0F172A) : const Color(0xffF9FAFC),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF475569) : Colors.grey.shade300,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "CONFIRMATION",
                                      style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 0.6,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      flight['confirmationCode'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget flightFormUI() {
    final isDark = themeC.isDarkMode.value;

    return Column(
      children: [
        TextField(
          controller: airlineCtrl,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: _flightInput("Airline"),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: flightCtrl,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _flightInput("Flight #"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: confCtrl,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _flightInput("Conf. Code"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  showFlightForm = false;
                  editingFlightId = null;
                  airlineCtrl.clear();
                  flightCtrl.clear();
                  confCtrl.clear();
                });
              },
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _saveFlightDetails,
              child: const Text("Save"),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _flightInput(String hint) {
    final isDark = themeC.isDarkMode.value;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : Colors.grey),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : Colors.grey.shade300),
      ),
    );
  }

  Widget travelChecklistCard() {
    final isDark = themeC.isDarkMode.value;

    return Card(
      color: isDark ? const Color(0xFF065F46) : const Color(0xffEFFFF6),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Travel Checklist",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF6EE7B7) : Colors.black,
              ),
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: planController.getChecklist(
                ownerId: widget.ownerId,
                planId: widget.planId,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final checklist = snapshot.data!;
                return Column(
                  children: checklist
                      .map(
                        (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              planController.toggleChecklistItem(
                                ownerId: widget.ownerId,
                                planId: widget.planId,
                                itemId: item['id'],
                                completed: !item['completed'],
                              );
                            },
                            child: Icon(
                              item['completed']
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: item['completed']
                                  ? (isDark ? const Color(0xFF10B981) : Colors.green)
                                  : (isDark ? const Color(0xFF94A3B8) : Colors.grey),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['title'],
                              style: TextStyle(
                                decoration: item['completed']
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 16,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              planController.deleteChecklistItem(
                                ownerId: widget.ownerId,
                                planId: widget.planId,
                                itemId: item['id'],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                      .toList(),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: checklistCtrl,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: "Add an item...",
                      hintStyle: TextStyle(
                        color: isDark ? const Color(0xFF64748B) : Colors.grey,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: isDark ? const Color(0xFF6EE7B7) : Colors.black,
                  ),
                  onPressed: _addChecklistItem,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget exportCalendarCard() {
    final isDark = themeC.isDarkMode.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.share, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                "EXPORT TO CALENDAR",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: calendarButton(
                  icon: Icons.g_mobiledata,
                  label: "Google",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: calendarButton(icon: Icons.apple, label: "Apple"),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: calendarButton(icon: Icons.window, label: "Outlook"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget calendarButton({required IconData icon, required String label}) {
    final isDark = themeC.isDarkMode.value;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xffE0E0E0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.white : Colors.black),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget sharedAlbumCard() {
    final isDark = themeC.isDarkMode.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.image_outlined, size: 18, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    "Shared Album",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: _addSharedImage,
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Add Photo"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: imageUrlCtrl,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: "Paste image URL...",
                    hintStyle: TextStyle(
                      color: isDark ? const Color(0xFF64748B) : Colors.grey,
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xffF9FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addSharedImage,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(60, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Add"),
              ),
            ],
          ),
          const SizedBox(height: 14),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: planController.getSharedMedia(
              ownerId: widget.ownerId,
              planId: widget.planId,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xffF9FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xffE0E0E0),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        size: 32,
                        color: isDark ? const Color(0xFF64748B) : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "No photos shared yet.",
                        style: TextStyle(
                          color: isDark ? const Color(0xFF64748B) : Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final images = snapshot.data!
                  .where((item) => item['type'] == 'image')
                  .toList();
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[index]['value'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark ? const Color(0xFF334155) : Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}