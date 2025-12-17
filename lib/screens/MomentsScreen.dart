import 'package:flutter/material.dart';
import 'package:yento_app/components/custom/customBottombar.dart';
import 'package:yento_app/components/custom/customNotificationsBox.dart';
import '../components/custom/app_shell.dart';

class Momentsscreen extends StatefulWidget {
  const Momentsscreen({super.key});

  @override
  State<Momentsscreen> createState() => _MomentsscreenState();
}

void Notifications(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CustomNotificationsBox(),
  );
}

class _MomentsscreenState extends State<Momentsscreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Moments',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Notifications(context);
            },
            icon: const Icon(Icons.notifications_none),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              AppShell.shellScaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ),
      ),

      // drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Container(
            height: height * 0.7,
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Moments',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        CreateMoment(height, width, context);
                      },
                      icon: const Icon(
                        Icons.image_outlined,
                        color: Color(0xff1e40af),
                      ),
                      label: const Text(
                        'Add Moment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1e40af),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffbfdbfe),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ----------MomentCard---------
                MomentCard(context, 'testing'),
                // If you want to show the "no moments" UI when there are none, toggle NoMoment()
                // NoMoment(),
              ],
            ),
          ),
        ),
      ),
      // <-- FIX: supply required currentIndex
      bottomNavigationBar: const Custombottombar(),
    );
  }
}

// -----------Create Moment Dialog------------------
void CreateMoment(double height, double width, BuildContext context) {
  final imageUrlController = TextEditingController();
  final captionController = TextEditingController();
  final linkPlanController = TextEditingController();
  final shareWithController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Container(
          width: width * 0.85,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [
              const SizedBox(height: 10),
              // ---------------- HEADER ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add a Moment",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const Divider(),
              const SizedBox(height: 20),

              // ---------------- IMAGES ----------------
              const Text(
                'Images (up to 5)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: imageUrlController,
                      decoration: InputDecoration(
                        hintText: 'Paste image URL here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Add image logic (push url to a list, preview, etc.)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffdbeafe),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1e40af),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------------- CAPTION ----------------
              const Text(
                'Caption',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: captionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- LINK TO A PLAN ----------------
              Row(
                children: const [
                  Icon(Icons.calendar_today_outlined),
                  SizedBox(width: 6),
                  Text(
                    'Link to a plan (Optional)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              TextField(
                controller: linkPlanController,
                decoration: InputDecoration(
                  hintText: 'None',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- SHARE WITH ----------------
              Row(
                children: const [
                  Icon(Icons.circle_outlined),
                  SizedBox(width: 6),
                  Text(
                    'Share with (Optional)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              TextField(
                controller: shareWithController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Select one or more circles. By default, moments are private unless shared.',
                style: TextStyle(fontSize: 12),
              ),

              const SizedBox(height: 20),
              const Divider(),

              // ---------------- BUTTONS ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Add moment logic (save state, insert into list, etc.)
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3b82f6),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add Moment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ----------MomentCard---------
Widget MomentCard(BuildContext context, String caption) {
  final width = MediaQuery.of(context).size.width;

  return Container(
    width: width * 0.9,
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image with rounded top corners
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: Image.network(
            'https://picsum.photos/seed/yento/1200/400',
            width: double.infinity,
            height: 130,
            fit: BoxFit.cover,
          ),
        ),

        // Caption
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            caption,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

Widget NoMoment() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'No moments to see here.',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),

      const SizedBox(height: 10),

      const Text(
        'Share a photo to create a timeline of your memories with friends and circles.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),

      const SizedBox(height: 30),
    ],
  );
}
