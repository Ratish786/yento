import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool showFlightForm = false;

  final airlineCtrl = TextEditingController();
  final flightCtrl = TextEditingController();
  final confCtrl = TextEditingController();

  final checklistCtrl = TextEditingController();
  List<String> checklist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        title: const Text("Smart Trip"),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              width: 140,
              height: 40,
              decoration: BoxDecoration(color: Colors.pink),
              child: Row(
                children: [
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
          // TextButton(
          //   onPressed: () {},
          //   child: const Text(
          //     "Post Moment",
          //     style: TextStyle(color: Colors.pink),
          //   ),
          // ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          Icon(Icons.delete),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            weatherCard(),
            infoTile(
              Icons.calendar_today,
              "DATE",
              "Wednesday, December 17, 2025",
            ),
            infoTile(Icons.access_time, "TIME", "07:00 PM"),
            infoTile(
              Icons.repeat,
              "REPEATS",
              "Repeats every week on Monday, Wednesday until December 18, 2025",
            ),
            infoTile(Icons.location_on, "LOCATION", "dddvffg"),
            SizedBox(height: 20),
            attendeesCard(),
            SizedBox(height: 20),
            notesCard(),
            SizedBox(height: 20),
            flightDetailsCard(),
            SizedBox(height: 20),
            travelChecklistCard(),
            SizedBox(height: 20),
            exportCalendarCard(),
            SizedBox(height: 20),
            sharedAlbumCard(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // ---------------- WEATHER ----------------
  Widget weatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "FORECAST",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "84°F",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Sunny",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  "in dddvffg",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          // RIGHT ICON
          Container(
            height: 44,
            width: 44,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wb_sunny, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  // ---------------- INFO TILE ----------------
  Widget infoTile(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(value),
    );
  }

  // ---------------- ATTENDEES ----------------
  Widget attendeesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- HEADER ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Attendees (2)",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

          // ---------- ATTENDEES LIST CONTAINER ----------
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffF6F7FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                attendeeItem(name: "Alex Young"),
                const SizedBox(height: 8),
                attendeeItem(name: "Charles Davis"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget attendeeItem({required String name}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 18, backgroundColor: Color(0xffE0E0E0)),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),

          // ---------- STATUS BADGE ----------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xffFFEEC2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "pending",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff8A6D00),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- NOTES ----------------
  Widget notesCard() {
    return Container(
      width: double.infinity,
      color: const Color(0xffFFF7D6),
      // elevation: 0,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("NOTES", style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 6),
            Text("dkf"),
          ],
        ),
      ),
    );
  }

  // ---------------- FLIGHT DETAILS ----------------
  Widget flightDetailsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xffEEF2F7), // outer base
      ),
      child: Column(
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xffEEF2F7), // header color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.flight, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Flight Details",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showFlightForm = !showFlightForm;
                    });
                  },
                  child: const Text(
                    "ADD FLIGHT",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // ================= BODY =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xffF9FAFC), // body color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: showFlightForm
                ? flightFormUI()
                : const Center(
                    child: Text(
                      "No flight details added.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // method

  Widget flightFormUI() {
    return Column(
      children: [
        TextField(decoration: _flightInput("Airline")),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: TextField(decoration: _flightInput("Flight #"))),
            const SizedBox(width: 12),
            Expanded(child: TextField(decoration: _flightInput("Conf. Code"))),
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
                });
              },
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showFlightForm = false;
                });
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _flightInput(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ---------------- CHECKLIST ----------------
  Widget travelChecklistCard() {
    return Card(
      color: const Color(0xffEFFFF6),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Travel Checklist",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            for (final item in checklist)
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(item),
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: checklistCtrl,
                    decoration: const InputDecoration(
                      hintText: "Add an item...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (checklistCtrl.text.isEmpty) return;
                    setState(() {
                      checklist.add(checklistCtrl.text);
                      checklistCtrl.clear();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- EXPORT ----------------
  Widget exportCalendarCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- HEADER ----------
          Row(
            children: const [
              Icon(Icons.share, size: 18),
              SizedBox(width: 8),
              Text(
                "EXPORT TO CALENDAR",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ---------- BUTTONS ----------
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

  // method
  Widget calendarButton({required IconData icon, required String label}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ---------------- SHARED ALBUM ----------------
  Widget sharedAlbumCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- HEADER ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.image_outlined, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Shared Album",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Add Photo"),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ---------- INPUT ROW ----------
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Paste image URL...",
                    filled: true,
                    fillColor: const Color(0xffF9FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
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

          // ---------- EMPTY STATE ----------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: const Color(0xffF9FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xffE0E0E0),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: const [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 32,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  "No photos shared yet.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
