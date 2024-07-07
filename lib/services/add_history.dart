import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/distance_calculations.dart';

Future addHistory(destination, origin, distance, fare, rating, driverid) async {
  final docUser = FirebaseFirestore.instance
      .collection('History')
      .doc(DateTime.now().toString());

  final json = {
    'myid': FirebaseAuth.instance.currentUser!.uid,
    'driverid': driverid,
    'destination': destination,
    'origin': origin,
    'distance': distance,
    'fare': fare,
    'rating': rating,
    'date': DateTime.now(),
  };

  await docUser.set(json);
}
