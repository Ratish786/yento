import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/controller/sidebar_controller.dart';
import 'package:yento_app/controller/theme_controller.dart';
import 'package:yento_app/screens/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  final Function(String routeName) onNavigate;

  const CustomDrawer({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final drawerWidth = width * 0.4;

    // 🔥 GetX Controllers
    final SidebarController sidebarC = Get.find<SidebarController>();
    final ThemeController themeC = Get.find<ThemeController>();

    return Obx(
          () {
        final isDark = themeC.isDarkMode.value;
        final bgColor = isDark ? const Color(0xFF16213E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;
        final subtextColor = isDark ? Colors.white70 : Colors.black54;
        final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
        final inputBg = isDark ? const Color(0xFF1A1B2E) : Colors.white;
        final dividerColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

        return Drawer(
          backgroundColor: bgColor,
          child: Container(
            color: bgColor,
            width: drawerWidth,
            child: Column(
              children: [
                // ---------------- Drawer Header ----------------
                SizedBox(
                  height: 100,
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      'VENNE',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),

                // ---------------- Search Field ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    onChanged: sidebarC.updateSearch,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Search Venne...',
                      hintStyle: TextStyle(color: subtextColor),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: subtextColor,
                      ),
                      filled: true,
                      fillColor: inputBg,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ---------------- Drawer Items ----------------
                Expanded(
                  child: Obx(() {
                    return ListView(
                      children: [
                        // ⭐ FAVORITES
                        ...sidebarC.favorites.map(
                              (item) => _drawerTile(
                            item,
                            textColor: textColor,
                            iconColor: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),

                        // Divider only if favorites exist
                        if (sidebarC.favorites.isNotEmpty)
                          Divider(thickness: 1, color: dividerColor),

                        // 📂 OTHERS
                        ...sidebarC.others.map(
                              (item) => _drawerTile(
                            item,
                            textColor: textColor,
                            iconColor: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                // ---------------- Drawer Footer ----------------
                Divider(thickness: 1, color: dividerColor),

                InkWell(
                  onTap: () => onNavigate("/profile"),
                  child: ListTile(
                    title: Text(
                      'User',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      'a@gmail.com',
                      style: TextStyle(
                        color: subtextColor,
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        // 1. Sign out from Firebase
                        await FirebaseAuth.instance.signOut();

                        // 2. Navigate to Login Screen
                        Get.offAll(() => const SimpleLoginScreen());
                      },
                      icon: Icon(
                        Icons.logout,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- Drawer Tile ----------------
  Widget _drawerTile(
      SidebarItem item, {
        required Color textColor,
        required Color iconColor,
      }) {
    return ListTile(
      title: Row(
        children: [
          Icon(item.icon, color: iconColor),
          const SizedBox(width: 8),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
      onTap: () => onNavigate(item.route),
    );
  }
}