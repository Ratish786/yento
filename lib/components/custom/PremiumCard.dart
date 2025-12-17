import 'package:flutter/material.dart';

class Premiumcard extends StatelessWidget {
  const Premiumcard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      // width: width*.04,
      child: Card(
        color: Color(0xffbfdbfe),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, color: Colors.blue),
            Text(
              'Unlock YenTo+',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
            ),
            Text(
              'Get advanced AI, group trips, video\n calls, and more!',
              style: TextStyle(color: Colors.blue),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3b82f6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(
                'Upgrade',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
