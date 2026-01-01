import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ---------------- MODEL ----------------
class SidebarItem {
  final String id;
  final String title;
  final String route;
  final IconData icon;
  bool isFavorite;

  SidebarItem({
    required this.id,
    required this.title,
    required this.route,
    required this.icon,
    this.isFavorite = false,
  });
}

/// ---------------- CONTROLLER ----------------
class SidebarController extends GetxController {
  /// Sidebar items
  final RxList<SidebarItem> items = <SidebarItem>[
    SidebarItem(
      id: "home",
      title: "Smart Hub",
      route: "/home",
      icon: Icons.home_outlined,
    ),
    SidebarItem(
      id: "calendar",
      title: "Calendar",
      route: "/calender",
      icon: Icons.calendar_today_outlined,
    ),
    SidebarItem(
      id: "circle",
      title: "Circles",
      route: "/circle",
      icon: Icons.circle_outlined,
    ),
    SidebarItem(
      id: "moments",
      title: "Moments",
      route: "/moments",
      icon: Icons.image_outlined,
    ),
    SidebarItem(
      id: "broadcast",
      title: "Broadcast",
      route: "/broadcast",
      icon: Icons.wifi,
    ),
    SidebarItem(
      id: "messages",
      title: "Messages",
      route: "/messages",
      icon: Icons.message_outlined,
    ),
    SidebarItem(
      id: "group",
      title: "Group Plans",
      route: "/group",
      icon: Icons.group_outlined,
    ),
    SidebarItem(
      id: "find",
      title: "Find Friends",
      route: "/findFriend",
      icon: Icons.person_add_alt_1_rounded,
    ),
  ].obs;

  /// Search text
  final RxString searchText = ''.obs;

  /// ---------------- FILTERING ----------------
  bool _matchSearch(SidebarItem item) {
    if (searchText.value.isEmpty) return true;
    return item.title
        .toLowerCase()
        .contains(searchText.value.toLowerCase());
  }

  List<SidebarItem> get favorites =>
      items.where((e) => e.isFavorite && _matchSearch(e)).toList();

  List<SidebarItem> get others =>
      items.where((e) => !e.isFavorite && _matchSearch(e)).toList();

  void updateSearch(String value) {
    searchText.value = value;
  }

  /// ---------------- FAVORITE ----------------
  void toggleFavorite(String id) {
    final index = items.indexWhere((e) => e.id == id);
    if (index == -1) return;

    items[index].isFavorite = !items[index].isFavorite;
    _normalize();
  }

  /// ---------------- REORDER ----------------
  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    _normalize();
  }

  /// ---------------- KEEP FAVORITES ON TOP ----------------
  void _normalize() {
    final favs = items.where((e) => e.isFavorite).toList();
    final rest = items.where((e) => !e.isFavorite).toList();
    items.assignAll([...favs, ...rest]);
  }
}
