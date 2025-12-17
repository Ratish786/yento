import 'package:flutter/material.dart';
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
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomeScreen(),
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
                CalenderScreen(),
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
                Circlescreen(),
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
                Messagesscreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: widget.currentIndex >= 0 ? widget.currentIndex : 0,
      // fallback to 0 but not highlighting
      selectedItemColor: widget.currentIndex == -1 ? Colors.grey : Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: _navigateTo,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Hub'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Calender',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.circle_outlined),
          label: 'Circles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          label: 'Messages',
        ),
      ],
    );
  }
}
