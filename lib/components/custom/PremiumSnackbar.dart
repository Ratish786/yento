import 'package:flutter/material.dart';

void PremiumSnackBar(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      String selectedPlan = "yearly";

      return StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.95,
            maxChildSize: 0.95,
            minChildSize: 0.95,
            builder: (_, controller) => Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: controller,
                children: [
                  // CLOSE BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // LOGO
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: isDark
                        ? const Color(0xff1e3a8a)
                        : const Color(0xffdbeafe),
                    child: const Icon(
                      Icons.apps,
                      size: 30,
                      color: Color(0xff3b82f6),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // TITLE
                  Center(
                    child: Text(
                      'Unlock Venne+ ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Supercharge your planning and create lasting memories.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey[300] : const Color(0xFF475569),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // FEATURES
                  _FeatureTile(
                    icon: Icons.camera_alt_outlined,
                    title: 'Group Video Hangouts',
                    subtitle:
                    'Spontaneously jump into video calls with your Circles, just like being in the same room.',
                    isDark: isDark,
                  ),
                  _FeatureTile(
                    icon: Icons.lock_outline,
                    title: 'Trip Planning Mode',
                    subtitle:
                    'Collaboratively plan group trips with smart itineraries, budget tracking, and destination suggestions.',
                    isDark: isDark,
                  ),
                  _FeatureTile(
                    icon: Icons.star_border_outlined,
                    title: 'Advanced AI Planning',
                    subtitle:
                    'Let our AI find the perfect times, suggest ideas, and autofill details to make planning effortless.',
                    isDark: isDark,
                  ),
                  _FeatureTile(
                    icon: Icons.calendar_today_outlined,
                    title: 'Unlimited Calendar Sync',
                    subtitle:
                    'Sync Google, Apple, and Outlook calendars simultaneously to keep your availability perfectly updated.',
                    isDark: isDark,
                  ),

                  const SizedBox(height: 20),

                  // YEARLY PLAN
                  GestureDetector(
                    onTap: () => setState(() => selectedPlan = "yearly"),
                    child: _PlanTile(
                      selected: selectedPlan == "yearly",
                      price: "\$39.99/year",
                      subtitle: "Billing annually",
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // MONTHLY PLAN
                  GestureDetector(
                    onTap: () => setState(() => selectedPlan = "monthly"),
                    child: _PlanTile(
                      selected: selectedPlan == "monthly",
                      price: "\$4.99/month",
                      subtitle: "Billing monthly",
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CTA BUTTON
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle subscription logic
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xff3b82f6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Upgrade Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Cancel anytime in your profile settings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : const Color(0xff94a3b8),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

/// -------- REUSABLE WIDGETS --------

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isDark
            ? const Color(0xff1e3a8a)
            : const Color(0xffeff6ff),
        child: Icon(icon, color: const Color(0xff3b82f6)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark ? Colors.grey[300] : const Color(0xFF475569),
        ),
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final bool selected;
  final String price;
  final String subtitle;
  final bool isDark;

  const _PlanTile({
    required this.selected,
    required this.price,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: selected
            ? (isDark ? const Color(0xff1e3a8a) : const Color(0xffeff6ff))
            : (isDark ? const Color(0xFF475569) : Colors.white),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: selected
              ? const Color(0xff3b82f6)
              : (isDark ? Colors.grey.shade600 : Colors.grey.shade300),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            price,
            style: TextStyle(
              color: selected
                  ? const Color(0xff3b82f6)
                  : (isDark ? Colors.white : Colors.black),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: selected
                  ? const Color(0xff60a5fa)
                  : (isDark ? Colors.grey[400] : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}