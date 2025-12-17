import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/controller/sidebar_controller.dart';
import '../components/custom/app_shell.dart';
import '../components/custom/customBottombar.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

void Notifications(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CustomNotificationsBox(),
  );
}

class _ProfilescreenState extends State<Profilescreen> {
  bool showMoments = false;
  bool showBroadcast = false;

  // Calendar toggles
  bool googleCalendar = false;
  bool appleCalendar = false;
  bool outlookCalendar = false;
  final SidebarController sidebarC = Get.find<SidebarController>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Venne',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              AppShell.shellScaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Notifications(context),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Center(child: profile(height, width)),
            const SizedBox(height: 16),

            // Sidebar customization card
             _sidebarCustomization(width),

            const SizedBox(height: 12),
            // Center(child: SidebarCustomization(width: width)),

            // const SizedBox(height: 12),

            // Calendar integrations card (added right after SidebarCustomization)
            Center(
              child: CalendarIntegrationsCard(
                width: width,
                googleEnabled: googleCalendar,
                appleEnabled: appleCalendar,
                outlookEnabled: outlookCalendar,
                onGoogleToggle: (v) => setState(() => googleCalendar = v),
                onAppleToggle: (v) => setState(() => appleCalendar = v),
                onOutlookToggle: (v) => setState(() => outlookCalendar = v),
              ),
            ),

            const SizedBox(height: 20),

            /// FIXED — Now works with full state management
            DisplaySettings(
              height: height,
              width: width,
              showMoments: showMoments,
              showBroadcast: showBroadcast,
              onChange: (moments, broadcast) {
                setState(() {
                  showMoments = moments;
                  showBroadcast = broadcast;
                });
              },
            ),
         
            const SizedBox(height: 25),
            PrivacyAndSecurity(height, width),
            const SizedBox(height: 25),
            Premiumcard(height, width),
            const SizedBox(height: 25),
          ],
        ),
      ),
      bottomNavigationBar: Custombottombar(),
    );
  }


Widget _sidebarCustomization(double width) {
  return SizedBox(
    width: width * 0.9,
    child: Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Sidebar Customization",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.drag_indicator, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 6),

            // List
            Obx(
              () => ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sidebarC.items.length,
                onReorder: sidebarC.reorder,
                itemBuilder: (context, index) {
                  final item = sidebarC.items[index];

                  return Container(
                    key: ValueKey(item.id),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),

                      // Drag handle
                      leading: const Icon(
                        Icons.drag_handle,
                        color: Colors.grey,
                      ),

                      title: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Star button
                      trailing: IconButton(
                        splashRadius: 20,
                        icon: Icon(
                          item.isFavorite
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: item.isFavorite
                              ? Colors.amber
                              : Colors.grey,
                        ),
                        onPressed: () =>
                            sidebarC.toggleFavorite(item.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}





}

//
// -----------------------------------------------------------
// PROFILE SECTION
// -----------------------------------------------------------
//
Widget profile(height, width) {
  return Container(
    height: height * 0.35,
    width: width * 0.9,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 45,
          backgroundImage: NetworkImage(
            "https://media.giphy.com/media/xT5LMHxhOfscxPfIfm/giphy.gif",
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'User',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.mail_outline, color: Colors.grey, size: 15),
            SizedBox(width: 5),
            Text('a@gmail.com'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.call_outlined, color: Colors.grey, size: 17),
            SizedBox(width: 5),
            Text('1234567890'),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffdbeafe),
            fixedSize: const Size(150, 40),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.create_outlined, color: Color(0xff1d4ed8)),
              SizedBox(width: 8),
              Text(
                'Edit Profile',
                style: TextStyle(
                  color: Color(0xff1d4ed8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

//
// -----------------------------------------------------------
// SIDEBAR CUSTOMIZATION CARD
// -----------------------------------------------------------
//
 
// -----------------------------------------------------------
// CALENDAR INTEGRATIONS CARD
// (NEW) placed after SidebarCustomization
// -----------------------------------------------------------
//
class CalendarIntegrationsCard extends StatelessWidget {
  final double width;
  final bool googleEnabled;
  final bool appleEnabled;
  final bool outlookEnabled;
  final ValueChanged<bool> onGoogleToggle;
  final ValueChanged<bool> onAppleToggle;
  final ValueChanged<bool> onOutlookToggle;

  const CalendarIntegrationsCard({
    super.key,
    required this.width,
    required this.googleEnabled,
    required this.appleEnabled,
    required this.outlookEnabled,
    required this.onGoogleToggle,
    required this.onAppleToggle,
    required this.onOutlookToggle,
  });

  Widget _integrationRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF2563EB),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.9,
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + description
              Row(
                children: const [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Calendar Integrations',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Sync your external calendars to automatically update your availability.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 12),

              // Integration rows
              _integrationRow(
                icon: Icons.calendar_today,
                label: 'Google Calendar',
                value: googleEnabled,
                onChanged: onGoogleToggle,
              ),
              const SizedBox(height: 8),
              _integrationRow(
                icon: Icons.phone_iphone,
                label: 'Apple Calendar',
                value: appleEnabled,
                onChanged: onAppleToggle,
              ),
              const SizedBox(height: 8),
              _integrationRow(
                icon: Icons.mail_outline,
                label: 'Outlook Calendar',
                value: outlookEnabled,
                onChanged: onOutlookToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// -----------------------------------------------------------
// DISPLAY SETTINGS (FIXED)
// -----------------------------------------------------------
//
Widget DisplaySettings({
  required double height,
  required double width,
  required bool showMoments,
  required bool showBroadcast,
  required Function(bool, bool) onChange,
}) {
  final TextEditingController textController = TextEditingController();

  return Container(
    width: width * 0.9,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.settings),
              SizedBox(width: 10),
              Text(
                'Display Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
          ListTile(
            title: const Text(
              'Show moments in Circles',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Switch(
              activeThumbColor: Color(0xff2563eb),
              inactiveTrackColor: Colors.grey,
              value: showMoments,
              onChanged: (value) => onChange(value, showBroadcast),
            ),
          ),
          ListTile(
            title: const Text(
              'Show Broadcast in Circles',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Switch(
              activeThumbColor: Color(0xff2563eb),
              inactiveTrackColor: Colors.grey,
              value: showBroadcast,
              onChanged: (value) => onChange(showMoments, value),
            ),
          ),
        ],
      ),
    ),
  );
}

//
// -----------------------------------------------------------
// PRIVACY & SECURITY
// -----------------------------------------------------------
//
Widget PrivacyAndSecurity(height, width) {
  return Container(
    // height: height * 0.41,
    width: width * 0.9,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.verified_user_outlined),
              SizedBox(width: 10),
              Text(
                'Privacy and Security',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Enable App Lock to require a PIN every time you open YenTo.',
          ),
          const SizedBox(height: 10),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Set a 4-digit pin',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm pin',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3b82f6),
              fixedSize: const Size(150, 40),
              elevation: 0,
            ),
            child: const Text(
              'Enable App Lock',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

//
// -----------------------------------------------------------
// PREMIUM CARD
// -----------------------------------------------------------
//
Widget Premiumcard(height, width) {
  return Container(
    height: height * 0.30,
    width: width * 0.9,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          'Subscription',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        Container(
          height: 160,
          width: 290,
          decoration: BoxDecoration(
            color: const Color(0xffbbf7d0),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  children: const [
                    Icon(Icons.star_border, color: Color(0xff166534), size: 22),
                    Text(
                      ' YenTo+ Member',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff166534),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'You have access to all premium features.',
                  style: TextStyle(color: Color(0xff166534)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Manage Subscription',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
