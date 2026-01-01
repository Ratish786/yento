import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yento_app/components/custom/CreatedSnackBar.dart';

class LocationService {
  /// Save user location to a circle if it exists
  static Future<void> getUserLocationAndSave({
    required BuildContext context,
    required String userId,
    required String circleName, // Now using name
  }) async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    // 2. Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location Can not be shared because location permission permanently denied')),
      );
      return;
    }

    try {
      // 3. Find the circle by name
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Circles')
          .where('name', isEqualTo: circleName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Circle does not Exist or you are not a Member.'),
          ),
        );
        return;
      }

      final circleDoc = querySnapshot.docs.first;

      // 4. Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 5. Save location under the circle
      await circleDoc.reference.set({
        'location': GeoPoint(position.latitude, position.longitude),
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      showCreatedSnackBar(context, 'Location shared successfully');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
