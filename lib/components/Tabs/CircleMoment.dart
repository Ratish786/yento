import 'package:flutter/material.dart';
import 'package:yento_app/screens/MomentsScreen.dart';

class Circlemoment extends StatelessWidget {
  const Circlemoment({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color(0xffeff6ff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  CreateMoment(height, width, context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color(0xff1d4ed8)),
                    Text(
                      'Share a New Moment',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1d4ed8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(child: Text('No moments shared in this circle yet.')),
        ],
      ),
    );
  }
}
