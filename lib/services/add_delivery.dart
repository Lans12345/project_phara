import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/distance_calculations.dart';

Future<String> addDelivery(
    driverId,
    origin,
    destination,
    distance,
    time,
    fare,
    originLat,
    originLong,
    destinationLat,
    destinationLong,
    userName,
    userProfile,
    receiver,
    receiverNumber,
    item) async {
  final docUser = FirebaseFirestore.instance.collection('Delivery').doc();

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
    'userName': userName,
    'userProfile': userProfile,
    'receiver': receiver,
    'receiverNumber': receiverNumber,
    'item': item,
  };

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    'deliveryHistory': FieldValue.arrayUnion([
      {
        'origin': origin,
        'destination': destination,
        'distance': calculateDistance(
                originLat, originLong, destinationLat, destinationLong)
            .toStringAsFixed(2),
        'payment': (((calculateDistance(originLat, originLong, destinationLat,
                        destinationLong)) *
                    8) +
                20)
            .toStringAsFixed(2),
        'date': DateTime.now(),
      }
    ]),
  });

  await docUser.set(json);
  return docUser.id;
}
