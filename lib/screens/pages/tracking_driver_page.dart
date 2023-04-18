import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:phara/widgets/text_widget.dart';

import '../../utils/colors.dart';
import '../home_screen.dart';

class TrackingOfDriverPage extends StatefulWidget {
  final Map tripDetails;

  const TrackingOfDriverPage({super.key, required this.tripDetails});

  @override
  State<TrackingOfDriverPage> createState() => _TrackingOfDriverPageState();
}

class _TrackingOfDriverPageState extends State<TrackingOfDriverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: TextRegular(
                        text: 'Rate your experience',
                        fontSize: 14,
                        color: Colors.black),
                    content: SizedBox(
                      height: 50,
                      child: Center(
                        child: RatingBar.builder(
                          initialRating: 5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) async {
                            int stars = 0;

                            FirebaseFirestore.instance
                                .collection('Drivers')
                                .where('id',
                                    isEqualTo: widget.tripDetails['driverId'])
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                setState(() {
                                  stars = doc['stars'];
                                });
                              }
                            });
                            await FirebaseFirestore.instance
                                .collection('Drivers')
                                .doc(widget.tripDetails['driverId'])
                                .update({
                              'ratings': FieldValue.arrayUnion(
                                  [FirebaseAuth.instance.currentUser!.uid]),
                              'stars': stars + 1
                            });
                          },
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        child: TextBold(
                            text: 'Continue',
                            fontSize: 18,
                            color: Colors.amber),
                      ),
                    ],
                  );
                });
          },
          icon: const Icon(
            Icons.exit_to_app_rounded,
            color: grey,
          ),
        ),
        centerTitle: true,
        foregroundColor: grey,
        backgroundColor: Colors.white,
        title: TextRegular(text: 'Lance Olana', fontSize: 24, color: grey),
      ),
    );
  }
}
