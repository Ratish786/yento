import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yento_app/components/custom/TermsOfServices.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import 'package:yento_app/controller/sidebar_controller.dart';
import 'package:yento_app/controller/theme_controller.dart';
import 'package:yento_app/controller/pass_controller.dart';
import '../components/custom/PrivacyPolicy.dart';
import '../components/custom/app_shell.dart';
import '../components/custom/customBottombar.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

void notifications(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CustomNotificationsBox(),
  );
}

class _ProfilescreenState extends State<Profilescreen> {
  bool showMoments = true;
  bool showBroadcast = true;

  bool googleCalendar = false;
  bool appleCalendar = false;
  bool outlookCalendar = false;

  final SidebarController sidebarC = Get.find<SidebarController>();
  final ThemeController themeC = Get.put(ThemeController());
  final PassController passC = Get.put(PassController());

  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Obx(
      () => Scaffold(
        backgroundColor: themeC.isDarkMode.value
            ? const Color(0xFF1A1B2E)
            : Colors.grey[200],
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: themeC.isDarkMode.value
              ? Color(0xFF1A1B2E)
              : Colors.white,
          foregroundColor: themeC.isDarkMode.value
              ? Colors.white
              : Colors.black,
          title: const Text(
            'Venne',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => notifications(context),
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Center(child: profile(height, width, themeC)),
              const SizedBox(height: 16),
              _sidebarCustomization(width, themeC),

              CalendarIntegrationsCard(
                width: width,
                themeController: themeC,
                googleEnabled: googleCalendar,
                appleEnabled: appleCalendar,
                outlookEnabled: outlookCalendar,
                onGoogleToggle: (v) => setState(() => googleCalendar = v),
                onAppleToggle: (v) => setState(() => appleCalendar = v),
                onOutlookToggle: (v) => setState(() => outlookCalendar = v),
              ),

              const SizedBox(height: 20),

              Center(
                child: displaySettings(
                  height: height,
                  width: width,
                  showMoments: showMoments,
                  showBroadcast: showBroadcast,
                  themeController: themeC,
                  onChange: (moments, broadcast) {
                    setState(() {
                      showMoments = moments;
                      showBroadcast = broadcast;
                    });
                  },
                ),
              ),
              const SizedBox(height: 25),
              Center(child: privacyAndSecurity(height, width, themeC, this)),
              const SizedBox(height: 25),
              supportAndLegal(context, themeC),
              const SizedBox(height: 25),
              Center(child: SubscriptionCard(themeController: themeC)),
              const SizedBox(height: 25),
            ],
          ),
        ),
        bottomNavigationBar: Custombottombar(),
      ),
    );
  }

  Widget _sidebarCustomization(double width, ThemeController themeC) {
    return Obx(
      () => SizedBox(
        width: width * 0.9,
        child: Card(
          elevation: 0,
          color: themeC.isDarkMode.value
              ? const Color(0xFF16213E)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sidebar Customization",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeC.isDarkMode.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.drag_indicator,
                      color: themeC.isDarkMode.value
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(
                  color: themeC.isDarkMode.value
                      ? Colors.grey.shade700
                      : Colors.grey.shade200,
                ),
                const SizedBox(height: 6),
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
                          color: themeC.isDarkMode.value
                              ? const Color(0xFF1A1B2E)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: themeC.isDarkMode.value
                                ? Colors.grey.shade700
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(
                            Icons.drag_handle,
                            color: themeC.isDarkMode.value
                                ? Colors.white70
                                : Colors.grey,
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: themeC.isDarkMode.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            splashRadius: 20,
                            icon: Icon(
                              item.isFavorite
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: item.isFavorite
                                  ? Colors.amber
                                  : (themeC.isDarkMode.value
                                        ? Colors.white54
                                        : Colors.grey),
                            ),
                            onPressed: () => sidebarC.toggleFavorite(item.id),
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
      ),
    );
  }
}

// --- CALENDAR CARD (Already has theme support) ---
class CalendarIntegrationsCard extends StatelessWidget {
  final double width;
  final ThemeController themeController;
  final bool googleEnabled;
  final bool appleEnabled;
  final bool outlookEnabled;
  final ValueChanged<bool> onGoogleToggle;
  final ValueChanged<bool> onAppleToggle;
  final ValueChanged<bool> onOutlookToggle;

  const CalendarIntegrationsCard({
    super.key,
    required this.width,
    required this.themeController,
    required this.googleEnabled,
    required this.appleEnabled,
    required this.outlookEnabled,
    required this.onGoogleToggle,
    required this.onAppleToggle,
    required this.onOutlookToggle,
  });

  Widget _integrationRow({
    required Widget leadingIcon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = themeController.isDarkMode.value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1B2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 24, child: Center(child: leadingIcon)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF2563EB),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: isDark
                  ? Colors.grey.shade700
                  : Colors.grey.shade200,
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
      final subTextColor = isDark
          ? Colors.grey.shade400
          : const Color(0xFF64748B);
      final horizontalMargin = (width - (width * 0.9)) / 2;

      return SizedBox(
        width: width,
        child: Card(
          margin: EdgeInsets.only(
            top: 12,
            left: horizontalMargin,
            right: horizontalMargin,
            bottom: 0,
          ),
          color: isDark ? const Color(0xFF16213E) : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 22,
                            color: textColor,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Calendar Integrations',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade800
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade600
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '1 Free',
                            style: TextStyle(
                              fontSize: 10,
                              height: 1.1,
                              color: subTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Sync',
                            style: TextStyle(
                              fontSize: 10,
                              height: 1.1,
                              color: subTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Sync your external calendars to automatically update your availability.',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                _integrationRow(
                  leadingIcon: Text(
                    'G',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                    ),
                  ),
                  label: 'Google Calendar',
                  value: googleEnabled,
                  onChanged: onGoogleToggle,
                ),
                const SizedBox(height: 12),
                _integrationRow(
                  leadingIcon: Icon(
                    Icons.apple,
                    size: 24,
                    color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                  ),
                  label: 'Apple Calendar',
                  value: appleEnabled,
                  onChanged: onAppleToggle,
                ),
                const SizedBox(height: 12),
                _integrationRow(
                  leadingIcon: Icon(
                    Icons.window,
                    size: 20,
                    color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                  ),
                  label: 'Outlook Calendar',
                  value: outlookEnabled,
                  onChanged: onOutlookToggle,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// --- PROFILE CARD (UPDATED) ---
Widget profile(double height, double width, ThemeController themeC) {
  return Obx(() {
    final isDark = themeC.isDarkMode.value;
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtextColor = isDark ? Colors.white70 : Colors.grey;

    return Container(
      height: height * 0.35,
      width: width * 0.9,
      decoration: BoxDecoration(
        color: cardColor,
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
          Text(
            'User',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mail_outline, color: subtextColor, size: 15),
              const SizedBox(width: 5),
              Text('a@gmail.com', style: TextStyle(color: textColor)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.call_outlined, color: subtextColor, size: 17),
              const SizedBox(width: 5),
              Text('1234567890', style: TextStyle(color: textColor)),
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
                borderRadius: BorderRadius.circular(25),
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
  });
}

// --- DISPLAY SETTINGS (Already has theme support) ---
Widget displaySettings({
  required double height,
  required double width,
  required bool showMoments,
  required bool showBroadcast,
  required ThemeController themeController,
  required Function(bool, bool) onChange,
}) {
  return Obx(
    () => Container(
      width: width * 0.9,
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value
            ? const Color(0xFF16213E)
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
                const SizedBox(width: 10),
                Text(
                  'Display Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.dark_mode_outlined,
                size: 20,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black,
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              subtitle: Text(
                'Switch between light and dark themes.',
                style: TextStyle(
                  fontSize: 12,
                  color: themeController.isDarkMode.value
                      ? Colors.white70
                      : Colors.grey,
                ),
              ),
              trailing: Switch(
                activeThumbColor: const Color(0xff2563eb),
                value: themeController.isDarkMode.value,
                onChanged: (value) => themeController.toggleTheme(),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Show Moments in Circles',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              trailing: Switch(
                activeThumbColor: const Color(0xff2563eb),
                value: showMoments,
                onChanged: (value) => onChange(value, showBroadcast),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Show Broadcast in Circles',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              trailing: Switch(
                activeThumbColor: const Color(0xff2563eb),
                value: showBroadcast,
                onChanged: (value) => onChange(showMoments, value),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// --- PRIVACY & SECURITY (Already has theme support) ---
Widget privacyAndSecurity(
  double height,
  double width,
  ThemeController themeC,
  _ProfilescreenState state,
) {
  return Obx(() {
    final isDark = themeC.isDarkMode.value;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark
        ? Colors.grey.shade400
        : const Color(0xFF64748B);
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : const Color(0xFFE2E8F0);
    final inputFillColor = isDark ? const Color(0xFF1A1B2E) : Colors.white;

    return Container(
      width: width * 0.9,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user_outlined, color: textColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Privacy & Security',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF111827)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Mask Phone Number',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.star_border_rounded,
                              size: 16,
                              color: Color(0xFFEAB308),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Hide your phone number in Circles from anyone who doesn't already have you in their contacts.",
                          style: TextStyle(
                            fontSize: 13,
                            color: subTextColor,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Upgrade to Venne+ to enable privacy masking.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Transform.scale(
                    scale: 0.9,
                    child: Switch(
                      value: false,
                      onChanged: (val) {},
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF2563EB),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade200,
                      trackOutlineColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.block, color: Colors.redAccent, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Blocked Users',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 18, color: subTextColor),
                    const SizedBox(width: 6),
                    Text(
                      'Block a user',
                      style: TextStyle(fontSize: 15, color: subTextColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 24),
            Text(
              'App Lock',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final hasPinSet = state.passC.hasPinSetValue.value;

              if (hasPinSet) {
                return _buildPinEnabledCard(
                  state,
                  isDark,
                  textColor,
                  subTextColor,
                  cardColor,
                  borderColor,
                );
              } else {
                return _buildPinSetupCard(
                  state,
                  isDark,
                  textColor,
                  subTextColor,
                  inputFillColor,
                  borderColor,
                );
              }
            }),
          ],
        ),
      ),
    );
  });
}

Widget _buildPinInput(
  String hint,
  Color fillColor,
  Color borderColor,
  Color hintColor,
  TextEditingController controller,
) {
  return TextField(
    controller: controller,
    obscureText: true,
    keyboardType: TextInputType.number,
    maxLength: 4,
    style: const TextStyle(fontSize: 15),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: hintColor, fontSize: 15),
      filled: true,
      fillColor: fillColor,
      counterText: '',
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
      ),
    ),
  );
}

// --- SUBSCRIPTION CARD (UPDATED) ---
class SubscriptionCard extends StatefulWidget {
  final ThemeController themeController;

  const SubscriptionCard({super.key, required this.themeController});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  bool isPremium = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Obx(
      () => isPremium
          ? _premiumCard(height, width)
          : _freePlanCard(height, width),
    );
  }

  Widget _freePlanCard(double height, double width) {
    final isDark = widget.themeController.isDarkMode.value;
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xff1e293b);
    final subBgColor = isDark
        ? const Color(0xFF1A1B2E)
        : const Color(0xfff8fafc);
    final borderColor = isDark ? Colors.grey.shade700 : const Color(0xffe2e8f0);
    final subTextColor = isDark ? Colors.white70 : const Color(0xff64748b);

    return Container(
      width: width * 0.9,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Subscription',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: subBgColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Free Plan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upgrade to unlock trip planning, video calls, and more.',
                    style: TextStyle(
                      color: subTextColor,
                      height: 1.4,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isPremium = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3b82f6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Upgrade to Venne+',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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

  Widget _premiumCard(double height, double width) {
    final isDark = widget.themeController.isDarkMode.value;
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final premiumBgColor = isDark
        ? const Color(0xFF065F46) // Darker green for dark mode
        : const Color(0xffbbf7d0);
    final premiumTextColor = isDark
        ? const Color(0xFF6EE7B7) // Lighter green text
        : const Color(0xff166534);

    return Container(
      width: width * 0.9,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Subscription',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: premiumBgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_border,
                          color: premiumTextColor,
                          size: 22,
                        ),
                        Text(
                          ' Venne+ Member',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: premiumTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You have access to all premium features.',
                      style: TextStyle(color: premiumTextColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
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
      ),
    );
  }
}

// --- SUPPORT & LEGAL (Already has theme support) ---
Widget supportAndLegal(BuildContext context, ThemeController themeC) {
  return Obx(() {
    final width = MediaQuery.of(context).size.width;
    final isDark = themeC.isDarkMode.value;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark
        ? Colors.grey.shade400
        : const Color(0xFF64748B);
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;
    final btnColor = isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC);
    final helpCenterBg = isDark
        ? const Color(0xFF1E3A8A).withOpacity(0.3)
        : const Color(0xFFEFF6FF);

    return Container(
      width: width * 0.9,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.support_agent_rounded, color: textColor, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Support & Legal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: helpCenterBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? Colors.transparent
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: const Icon(
                        Icons.help_outline_rounded,
                        color: Color(0xFF3B82F6),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Help Center',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'FAQs and Support',
                          style: TextStyle(fontSize: 13, color: subTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildNavButton(
              title: "Terms of Service",
              bgColor: btnColor,
              textColor: textColor,
              onTap: () {
                TermsOfServices(context);
              },
            ),
            const SizedBox(height: 12),
            _buildNavButton(
              title: "Privacy Policy",
              bgColor: btnColor,
              textColor: textColor,
              onTap: () {
                PrivacyPolicy(context);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showFeedbackDialog(context);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: btnColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Send Feedback",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: subTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showFeedbackDialog(context, isBugReport: true);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: btnColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Report Bug",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: subTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
}

Widget _buildNavButton({
  required String title,
  required Color bgColor,
  required Color textColor,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: textColor.withOpacity(0.8),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_rounded,
            size: 18,
            color: textColor.withOpacity(0.5),
          ),
        ],
      ),
    ),
  );
}

// --- FEEDBACK DIALOG (Keep as is - already well styled) ---
void showFeedbackDialog(BuildContext context, {bool isBugReport = false}) {
  showDialog(
    context: context,
    builder: (context) => FeedbackDialog(initialIsBugReport: isBugReport),
  );
}

class FeedbackDialog extends StatefulWidget {
  final bool initialIsBugReport;

  const FeedbackDialog({super.key, this.initialIsBugReport = false});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIsBugReport ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final activeBg = Colors.white;
    final inactiveBg = Colors.transparent;
    final toggleBg = const Color(0xFFF1F5F9);
    final activeBorderColor = Colors.black.withOpacity(0.04);
    final primarySlate = const Color(0xFF64748B);

    final isBug = selectedIndex == 1;
    final labelText = isBug ? "Describe the issue" : "What is on your mind?";
    final hintText = isBug
        ? "I tried to click the button and..."
        : "I love the new travel feature, but...";

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Send Feedback",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: toggleBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectedIndex = 0),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedIndex == 0
                                    ? activeBg
                                    : inactiveBg,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: selectedIndex == 0
                                    ? [
                                        BoxShadow(
                                          color: activeBorderColor,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  "General Feedback",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: selectedIndex == 0
                                        ? const Color(0xFF0F172A)
                                        : primarySlate,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectedIndex = 1),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedIndex == 1
                                    ? activeBg
                                    : inactiveBg,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: selectedIndex == 1
                                    ? [
                                        BoxShadow(
                                          color: activeBorderColor,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  "Report a Bug",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: selectedIndex == 1
                                        ? const Color(0xFFEF4444)
                                        : primarySlate,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    labelText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 5,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your device info and app logs will be included automatically.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7e8da1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          "Send Feedback",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.mark_chat_read_outlined,
                          size: 16,
                          color: Colors.white70,
                        ),
                      ],
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
}

Widget _buildPinEnabledCard(
  _ProfilescreenState state,
  bool isDark,
  Color textColor,
  Color subTextColor,
  Color cardColor,
  Color borderColor,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF065F46) : const Color(0xFFD1FAE5),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle,
              color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Lock is Enabled',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFF10B981)
                          : const Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your app is protected with a 4-digit PIN',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF6EE7B7)
                          : const Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await _showDisablePinDialog(state);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Disable',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildPinSetupCard(
  _ProfilescreenState state,
  bool isDark,
  Color textColor,
  Color subTextColor,
  Color inputFillColor,
  Color borderColor,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Enable App Lock to require a PIN every time you open Venne.',
        style: TextStyle(color: textColor, fontSize: 15, height: 1.4),
      ),
      const SizedBox(height: 16),
      _buildPinInput(
        'Set 4-digit PIN',
        inputFillColor,
        borderColor,
        subTextColor,
        state.pinController,
      ),
      const SizedBox(height: 12),
      _buildPinInput(
        'Confirm PIN',
        inputFillColor,
        borderColor,
        subTextColor,
        state.confirmPinController,
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: () async {
            if (state.pinController.text.length != 4) {
              Get.snackbar(
                'Invalid PIN',
                'PIN must be 4 digits',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (state.pinController.text != state.confirmPinController.text) {
              Get.snackbar(
                'PIN Mismatch',
                'PINs do not match',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            final success = await state.passC.setPin(state.pinController.text);
            if (success) {
              state.pinController.clear();
              state.confirmPinController.clear();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: const Text(
            'Enable App Lock',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ],
  );
}

Future<void> _showDisablePinDialog(_ProfilescreenState state) async {
  Get.dialog(
    AlertDialog(
      title: const Text('Disable App Lock'),
      content: const Text('Are you sure you want to disable the app lock?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            Get.back();
            await _disablePin(state);
          },
          child: const Text('Disable', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

Future<void> _disablePin(_ProfilescreenState state) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('password')
          .doc(user.uid)
          .delete();

      // Update the reactive variable
      state.passC.hasPinSetValue.value = false;

      Get.snackbar(
        'Success',
        'App Lock disabled successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to disable App Lock',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
