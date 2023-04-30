import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addMessage(driverId, message, driverName, userName) async {
  final docUser = FirebaseFirestore.instance
      .collection('Messages')
      .doc(FirebaseAuth.instance.currentUser!.uid + driverId);

  final json = {
    'messages': [
      {
        'message': message,
        'dateTime': DateTime.now(),
        'sender': FirebaseAuth.instance.currentUser!.uid
      }
    ],
    'lastMessage': message,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'driverId': driverId,
    'dateTime': DateTime.now(),
    'seen': false,
    'driverName': driverName,
    'userName': userName
  };

  await docUser.set(json);
}
