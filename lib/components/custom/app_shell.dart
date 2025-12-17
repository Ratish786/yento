import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/customDrawer.dart';
import 'package:yento_app/controller/sidebar_controller.dart';
import 'package:yento_app/screens/MomentsScreen.dart';
import 'package:yento_app/screens/ProfileScreen.dart';
import 'package:yento_app/screens/messagesScreen.dart';
import '../../screens/broadcastScreen.dart';
import '../../screens/calenderScreen.dart';
import '../../screens/circleScreen.dart';
import '../../screens/findFriendsScreen.dart';
import '../../screens/groupPlansScreen.dart';
import '../../screens/homescreen.dart';

class AppShell extends StatefulWidget {
  static final GlobalKey<ScaffoldState> shellScaffoldKey = GlobalKey();
  // final SidebarController sidebarC = Get.put(SidebarController());


   AppShell({super.key});

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey();
  String currentRoute = "/home";

void initState() {
  super.initState();
  Get.put(SidebarController()); // 🔥 REQUIRED
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final nav = _navKey.currentState;
        if (nav != null && nav.canPop()) {
          nav.pop();
          // currentRoute = "/home";
          return false;
        }
        return true;
      },

      child: Scaffold(
        key: AppShell.shellScaffoldKey,
        drawer: CustomDrawer(
          onNavigate: (routeName) {
            Navigator.pop(context);
            if (routeName == "/home") {
              // Check if we can pop to home, otherwise push and remove until home
              final nav = _navKey.currentState!;
              if (nav.canPop()) {
                try {
                  nav.popUntil((route) => route.settings.name == "/home");
                } catch (e) {
                  // If popUntil fails, push home and remove all others
                  nav.pushNamedAndRemoveUntil("/home", (route) => false);
                }
              } else {
                // If can't pop, just push home
                nav.pushNamedAndRemoveUntil("/home", (route) => false);
              }
            } else {
              _navKey.currentState!.pushNamedAndRemoveUntil(
                routeName,
                ModalRoute.withName("/home"),
              );
            }
          },
        ),
        body: Navigator(
          key: _navKey,
          initialRoute: "/home",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case "/home":
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomeScreen(),
                  settings: settings,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case "/broadcast":
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      BroadcastScreen(),
                  settings: settings,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case "/calender":
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CalenderScreen(),
                  settings: settings,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case "/circle":
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Circlescreen(),
                  settings: settings,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case "/findFriend":
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Findfriendsscreen(),
                  settings: settings,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case "/group":
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Groupplansscreen(),
                  settings: settings,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case "/moments":
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondAnimation) =>
                      Momentsscreen(),
                  settings: settings,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case "/messages":
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondAnimation) =>
                      Messagesscreen(),
                  settings: settings,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case "/profile":
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondAnimation) =>
                      Profilescreen(),
                  settings: settings,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
            }
            return null;
          },
        ),
      ),
    );
  }
}
