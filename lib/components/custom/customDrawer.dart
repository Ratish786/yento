import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/controller/sidebar_controller.dart';
// import '../controller/sidebar_controller.dart';
// import '../models/sidebar_item.dart';

class CustomDrawer extends StatelessWidget {
  final Function(String routeName) onNavigate;

  const CustomDrawer({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final drawerWidth = width * 0.4;

    // 🔥 GetX Sidebar Controller
    final SidebarController sidebarC = Get.find<SidebarController>();

    return Drawer(
      child: Container(
        color: Colors.white,
        width: drawerWidth,
        child: Column(
          children: [
            // ---------------- Drawer Header ----------------
            SizedBox(
              height: 100,
              child: Container(
                height: 80,
                alignment: Alignment.center,
                child: const Text(
                  'YENTO',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                onChanged: sidebarC.updateSearch,
                decoration: InputDecoration(
                  hintText: 'Search Venne...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),

            // ---------------- Drawer Items ----------------
            Expanded(
              child: Obx(() {
                return ListView(
                  children: [
                    // ⭐ FAVORITES
                    ...sidebarC.favorites.map((item) => _drawerTile(item)),

                    // Divider only if favorites exist
                    if (sidebarC.favorites.isNotEmpty)
                      const Divider(thickness: 1),

                    // 📂 OTHERS
                    ...sidebarC.others.map((item) => _drawerTile(item)),
                  ],
                );
              }),
            ),

            // ---------------- Drawer Footer ----------------
            InkWell(
              onTap: () => onNavigate("/profile"),
              child: ListTile(
                title: Text(
                  'User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  'a@gmail.com',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.logout),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Drawer Tile ----------------
  Widget _drawerTile(SidebarItem item) {
    return ListTile(
      title: Row(
        children: [
          Icon(item.icon),
          const SizedBox(width: 8),
          Text(
            item.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      onTap: () => onNavigate(item.route),
    );
  }
}
