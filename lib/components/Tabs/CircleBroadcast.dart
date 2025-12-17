import 'package:flutter/material.dart';
import 'package:yento_app/screens/broadcastScreen.dart';

class Circlebroadcast extends StatelessWidget {
  const Circlebroadcast({super.key});

  @override
  Widget build(BuildContext context) {
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
                  NewBroadcast(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color(0xff1d4ed8)),
                    Text(
                      'Write a New Broadcast',
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
          Center(
            child: ListTile(
              title: Text(
                'Testing...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('by on 24/11/2025'),
            ),
          ),
        ],
      ),
    );
  }
}
