import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yento_app/screens/homescreen.dart';
import 'package:yento_app/screens/messagesScreen.dart';
import 'package:yento_app/screens/calenderScreen.dart';
import 'package:yento_app/screens/circleScreen.dart';

class Custombottombar extends StatefulWidget {
  final int currentIndex;

  const Custombottombar({super.key, this.currentIndex = -1});

  @override
  State<Custombottombar> createState() => _CustombottombarState();
}

class _CustombottombarState extends State<Custombottombar> {
  void _navigateTo(int index) {
    if (index == widget.currentIndex) {
      // If tapping on current tab and it's Hub (0)
      if (index == 0) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          // Close app if already on home screen and no routes to pop
          SystemNavigator.pop();
        }
      }
      return;
    }

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const CalenderScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const Circlescreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const Messagesscreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      currentIndex: widget.currentIndex >= 0 ? widget.currentIndex : 0,
      selectedItemColor: widget.currentIndex == -1
          ? (isDark ? Colors.grey[600] : Colors.grey)
          : const Color(0xff3B82F6),
      unselectedItemColor: isDark ? Colors.grey[600] : Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      onTap: _navigateTo,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Hub',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.circle_outlined),
          activeIcon: Icon(Icons.circle_outlined),
          label: 'Circles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          activeIcon: Icon(Icons.message),
          label: 'Messages',
        ),
      ],
    );
  }
}