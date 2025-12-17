import 'package:flutter/material.dart';
import 'package:yento_app/components/dialog/CreatePlan.dart';

class Circleplan extends StatelessWidget {
  const Circleplan({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                CreatePlanDialog();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xffeff6ff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Color(0xff1d4ed8)),
                  SizedBox(width: 6),
                  Text(
                    'Share a New Plan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1d4ed8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: ListTile(
              title: Text(
                'Weekly Team Sync',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('24/11/2025'),
            ),
          ),
        ],
      ),
    );
  }
}
