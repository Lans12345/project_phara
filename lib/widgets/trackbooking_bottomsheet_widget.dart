import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:phara/screens/map_screen.dart';
import 'package:phara/screens/pages/tracking_driver_page.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:phara/widgets/textfield_widget.dart';
import 'package:phara/widgets/toast_widget.dart';

import '../services/add_history.dart';
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
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Bookings')
              .doc(widget.tripDetails['docId'])
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            dynamic data = snapshot.data;
            return SizedBox(
              height: 450,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: TextBold(
                          text: 'Booking Status: ${data['status']}',
                          fontSize: 18,
                          color: data['status'] == 'Pending'
                              ? Colors.blue
                              : data['status'] == 'Rejected'
                                  ? Colors.red
                                  : Colors.green),
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
                            color: data['status'] == 'Pending'
                                ? Colors.blue
                                : data['status'] == 'Rejected'
                                    ? Colors.red
                                    : Colors.green,
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
                    data['status'] == 'Picked up'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Card(
                                    child: Container(
                                      height: 150,
                                      width: 320,
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    minRadius: 50,
                                                    maxRadius: 50,
                                                    backgroundImage:
                                                        NetworkImage(widget
                                                                .tripDetails[
                                                            'driverProfile']),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextBold(
                                                          text:
                                                              'Name: ${widget.tripDetails['driverName']}',
                                                          fontSize: 15,
                                                          color: grey),
                                                      TextRegular(
                                                          text: widget.tripDetails[
                                                                      'driverRatings'] !=
                                                                  'No ratings'
                                                              ? '${widget.tripDetails['driverRatings']} ★'
                                                              : widget.tripDetails[
                                                                  'driverRatings'],
                                                          fontSize: 14,
                                                          color: Colors.amber),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 40,
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.red,
                                  ),
                                  title: TextRegular(
                                      text:
                                          'Distance: ${widget.tripDetails['distance']} km',
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
                                      text:
                                          'From:  ${widget.tripDetails['origin']}',
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
                                      text:
                                          'To:  ${widget.tripDetails['destination']}',
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
                                      text:
                                          'Fare: ₱${widget.tripDetails['fare']}',
                                      fontSize: 16,
                                      color: grey),
                                ),
                              ),
                            ],
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
                    data['status'] == 'Pending'
                        ? MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            minWidth: 250,
                            height: 45,
                            color: Colors.blue,
                            onPressed: () {},
                            child: SizedBox(
                              width: 250,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.all(5.0),
                                  //   child: Image.asset(
                                  //     'assets/images/animation.gif',
                                  //     width: 50,
                                  //     height: 30,
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextRegular(
                                    text: 'Pending request...',
                                    fontSize: 14,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ))
                        : data['status'] == 'Rejected'
                            ? MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                minWidth: 250,
                                height: 45,
                                color: Colors.red,
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => MapScreen()));
                                },
                                child: SizedBox(
                                  width: 250,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.all(5.0),
                                      //   child: Image.asset(
                                      //     'assets/images/animation.gif',
                                      //     width: 50,
                                      //     height: 30,
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      TextRegular(
                                        text: 'Booking rejected!',
                                        fontSize: 18,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ))
                            : data['status'] == 'Picked up'
                                ? ButtonWidget(
                                    radius: 100,
                                    opacity: 1,
                                    color: Colors.amber,
                                    label: 'Rate Driver',
                                    onPressed: (() {
                                      ratingsDialog();
                                    }),
                                  )
                                : ButtonWidget(
                                    radius: 100,
                                    opacity: 1,
                                    color: black,
                                    label: 'Track driver',
                                    onPressed: (() {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TrackingOfDriverPage(
                                                    tripDetails:
                                                        widget.tripDetails,
                                                  )));
                                    }),
                                  ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  final feedbackController = TextEditingController();
  double rating = 5;

  ratingsDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextRegular(
                text: 'Rate your experience',
                fontSize: 18,
                color: Colors.black),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidget(
                    borderColor: Colors.black,
                    hintColor: Colors.amber,
                    color: Colors.black,
                    label: 'Feedback to Driver',
                    controller: feedbackController),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) async {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  int stars = 0;

                  await FirebaseFirestore.instance
                      .collection('Drivers')
                      .where('id', isEqualTo: widget.tripDetails['driverId'])
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
                    'ratings':
                        FieldValue.arrayUnion([DateTime.now().toString()]),
                    'stars': stars + rating.toInt()
                  });

                  await FirebaseFirestore.instance
                      .collection('Drivers')
                      .doc(widget.tripDetails['driverId'])
                      .update({
                    'comments': FieldValue.arrayUnion([
                      {
                        'myName': widget.tripDetails['userName'],
                        'stars': rating.toInt(),
                        'feedback': feedbackController.text,
                        'dateTime': DateTime.now(),
                      }
                    ]),
                  });

                  addHistory(
                      widget.tripDetails['destination'],
                      widget.tripDetails['origin'],
                      widget.tripDetails['distance'],
                      widget.tripDetails['fare'],
                      rating.toInt(),
                      widget.tripDetails['driverId']);

                  showToast('Thankyou for your booking!');
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MapScreen()));
                },
                child: TextBold(
                    text: 'Continue', fontSize: 18, color: Colors.amber),
              ),
            ],
          );
        });
  }
}
