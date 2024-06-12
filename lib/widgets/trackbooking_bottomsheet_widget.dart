import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phara/screens/map_screen.dart';
import 'package:phara/screens/pages/tracking_driver_page.dart';
import 'package:phara/widgets/text_widget.dart';

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
                                                tripDetails: widget.tripDetails,
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
}
