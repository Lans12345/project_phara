import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addBooking(driverId, origin, destination, distance, time, fare,
    originLat, originLong, destinationLat, destinationLong) async {
  final docUser = FirebaseFirestore.instance
      .collection('Bookings')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'status': 'Pending',
    'dateTime': DateTime.now(),
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'driverId': driverId,
    'origin': origin,
    'destination': destination,
    'distance': distance,
    'time': time,
    'fare': fare,
    'originCoordinates': {'lat': originLat, 'long': originLong},
    'destinationCoordinates': {'lat': destinationLat, 'long': destinationLong},
  };

  await docUser.set(json);
}
