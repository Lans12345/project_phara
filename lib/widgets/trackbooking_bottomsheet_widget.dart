import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:phara/widgets/text_widget.dart';

import '../screens/home_screen.dart';
import '../utils/colors.dart';
import 'button_widget.dart';

class TrackBookingBottomSheetWidget extends StatefulWidget {
  final Map tripDetails;

  const TrackBookingBottomSheetWidget({super.key, required this.tripDetails});

  @override
  State<TrackBookingBottomSheetWidget> createState() =>
      _TrackBookingBottomSheetWidgetState();
}

class _TrackBookingBottomSheetWidgetState
    extends State<TrackBookingBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: SizedBox(
        height: 520,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child:
                    TextBold(text: 'Current trip', fontSize: 24, color: grey),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/rider.png',
                        height: 75,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 100,
                    child: Divider(
                      thickness: 5,
                      color: Colors.blue[900],
                    ),
                  ),
                  const Icon(
                    Icons.pin_drop_rounded,
                    color: Colors.red,
                    size: 58,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.red,
                  ),
                  title: TextRegular(
                      text: 'Distance: ${widget.tripDetails['distance']} km',
                      fontSize: 16,
                      color: grey),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.my_location,
                    color: grey,
                  ),
                  title: TextRegular(
                      text: 'From:  ${widget.tripDetails['origin']}',
                      fontSize: 16,
                      color: grey),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.pin_drop_rounded,
                    color: Colors.red,
                  ),
                  title: TextRegular(
                      text: 'To:  ${widget.tripDetails['destination']}',
                      fontSize: 16,
                      color: grey),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.payments_outlined,
                    color: grey,
                  ),
                  title: TextRegular(
                      text: 'Fare: ₱${widget.tripDetails['fare']}',
                      fontSize: 16,
                      color: grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1.5,
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                radius: 100,
                opacity: 1,
                color: black,
                label: 'Track driver',
                onPressed: (() {}),
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonWidget(
                radius: 100,
                opacity: 1,
                color: Colors.green,
                label: 'Confirm payment',
                onPressed: (() {
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
                                          isEqualTo:
                                              widget.tripDetails['driverId'])
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
                                    'ratings': FieldValue.arrayUnion([
                                      FirebaseAuth.instance.currentUser!.uid
                                    ]),
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
                                        builder: (context) =>
                                            const HomeScreen()));
                              },
                              child: TextBold(
                                  text: 'Continue',
                                  fontSize: 18,
                                  color: Colors.amber),
                            ),
                          ],
                        );
                      });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
