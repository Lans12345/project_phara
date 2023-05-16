import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phara/data/distance_calculations.dart';
import 'package:phara/data/time_calculation.dart';
import 'package:phara/services/add_booking.dart';

import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:phara/widgets/trackbooking_bottomsheet_widget.dart';

import '../services/providers/coordinates_provider.dart';
import 'button_widget.dart';

class BookBottomSheetWidget extends StatefulWidget {
  final String driverId;

  final Map coordinates;

  const BookBottomSheetWidget(
      {super.key, required this.driverId, required this.coordinates});

  @override
  State<BookBottomSheetWidget> createState() => _BookBottomSheetWidgetState();
}

class _BookBottomSheetWidgetState extends State<BookBottomSheetWidget> {
  String userName = '';
  String userProfile = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() {
    FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        setState(() {
          userName = doc['name'];
          userProfile = doc['profilePicture'];
        });
      }
    });
  }

  final destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Drivers')
        .doc(widget.driverId)
        .snapshots();
    return SingleChildScrollView(
      reverse: true,
      child: StreamBuilder<DocumentSnapshot>(
          stream: userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading'));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            dynamic data = snapshot.data;

            double rating = data['stars'] / data['ratings'].length;
            return Consumer(builder: ((context, ref, child) {
              return SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextBold(text: 'Driver', fontSize: 15, color: grey),
                          IconButton(
                            onPressed: (() {
                              Navigator.pop(context);
                            }),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            minRadius: 50,
                            maxRadius: 50,
                            backgroundImage:
                                NetworkImage(data['profilePicture']),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBold(
                                  text: 'Name: ${data['name']}',
                                  fontSize: 15,
                                  color: grey),
                              TextRegular(
                                  text: 'Vehicle: ${data['vehicle']}',
                                  fontSize: 14,
                                  color: grey),
                              TextRegular(
                                  text: 'Plate No.: ${data['plateNumber']}',
                                  fontSize: 14,
                                  color: grey),
                              TextRegular(
                                  text: data['ratings'].length != 0
                                      ? 'Rating: ${rating.toStringAsFixed(2)} ★'
                                      : 'No ratings',
                                  fontSize: 14,
                                  color: Colors.amber),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextBold(
                          text: 'Current Location', fontSize: 15, color: grey),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.my_location,
                            color: grey,
                            size: 32,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 270,
                            child: TextRegular(
                                text: widget.coordinates['pickupLocation'],
                                fontSize: 16,
                                color: grey),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          TextRegular(text: 'To:', fontSize: 18, color: grey),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 250,
                            height: 42,
                            child: TextFormField(
                              enabled: false,
                              controller: destinationController,
                              style: const TextStyle(
                                  color: Colors.black, fontFamily: 'QRegular'),
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.pin_drop_sharp,
                                  color: Colors.red,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: ref
                                    .read(destinationProvider.notifier)
                                    .state,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextRegular(
                          text:
                              'Distance: ${(calculateDistance(widget.coordinates['lat'], widget.coordinates['long'], ref.read(latProvider.notifier).state, ref.read(longProvider.notifier).state)).toStringAsFixed(2)} km',
                          fontSize: 15,
                          color: grey),
                      const SizedBox(
                        height: 5,
                      ),
                      TextRegular(
                          text:
                              'Estimated time: ${(calculateTravelTime((calculateDistance(widget.coordinates['lat'], widget.coordinates['long'], ref.read(latProvider.notifier).state, ref.read(longProvider.notifier).state)), 26.8)).toStringAsFixed(2)} hr/s',
                          fontSize: 15,
                          color: grey),
                      const SizedBox(
                        height: 5,
                      ),
                      TextRegular(
                          text:
                              'Fare: ₱${(((calculateDistance(widget.coordinates['lat'], widget.coordinates['long'], ref.read(latProvider.notifier).state, ref.read(longProvider.notifier).state)) * 12) + 45).toStringAsFixed(2)}',
                          fontSize: 15,
                          color: grey),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: grey,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ButtonWidget(
                            width: 250,
                            radius: 100,
                            opacity: 1,
                            color: Colors.green,
                            label: 'Continue',
                            onPressed: (() {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                          'Booking Confirmation',
                                          style: TextStyle(
                                              fontFamily: 'QBold',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: const Text(
                                          'Confirm booking?',
                                          style:
                                              TextStyle(fontFamily: 'QRegular'),
                                        ),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text(
                                              'Close',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'QRegular',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('Drivers')
                                                  .doc(widget.driverId)
                                                  .update({
                                                'notif': FieldValue.arrayUnion([
                                                  {
                                                    'notif':
                                                        'You received a new booking!',
                                                    'read': false,
                                                    'date': DateTime.now(),
                                                  }
                                                ]),
                                              });

                                              final String docId = await addBooking(
                                                  widget.driverId,
                                                  widget.coordinates[
                                                      'pickupLocation'],
                                                  ref
                                                      .read(destinationProvider
                                                          .notifier)
                                                      .state,
                                                  (calculateDistance(
                                                          widget.coordinates[
                                                              'lat'],
                                                          widget.coordinates[
                                                              'long'],
                                                          ref
                                                              .read(latProvider
                                                                  .notifier)
                                                              .state,
                                                          ref
                                                              .read(longProvider
                                                                  .notifier)
                                                              .state))
                                                      .toStringAsFixed(2),
                                                  (calculateTravelTime(
                                                          (calculateDistance(
                                                              widget
                                                                  .coordinates['lat'],
                                                              widget.coordinates['long'],
                                                              ref.read(latProvider.notifier).state,
                                                              ref.read(longProvider.notifier).state)),
                                                          26.8))
                                                      .toStringAsFixed(2),
                                                  (((calculateDistance(widget.coordinates['lat'], widget.coordinates['long'], ref.read(latProvider.notifier).state, ref.read(longProvider.notifier).state)) * 12) + 45).toStringAsFixed(2),
                                                  widget.coordinates['lat'],
                                                  widget.coordinates['long'],
                                                  ref.read(latProvider.notifier).state,
                                                  ref.read(longProvider.notifier).state,
                                                  userName,
                                                  userProfile);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);

                                              showModalBottomSheet(
                                                  isDismissible: false,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: ((context) {
                                                    return TrackBookingBottomSheetWidget(
                                                      tripDetails: {
                                                        'driverRatings': data[
                                                                        'ratings']
                                                                    .length !=
                                                                0
                                                            ? 'Rating: ${rating.toStringAsFixed(2)} ★'
                                                            : 'No ratings',
                                                        'docId': docId,
                                                        'driverProfile': data[
                                                            'profilePicture'],
                                                        'driverName':
                                                            data['name'],
                                                        'driverId':
                                                            widget.driverId,
                                                        'distance': (calculateDistance(
                                                                widget.coordinates[
                                                                    'lat'],
                                                                widget.coordinates[
                                                                    'long'],
                                                                ref
                                                                    .read(latProvider
                                                                        .notifier)
                                                                    .state,
                                                                ref
                                                                    .read(longProvider
                                                                        .notifier)
                                                                    .state))
                                                            .toStringAsFixed(2),
                                                        'origin': widget
                                                                .coordinates[
                                                            'pickupLocation'],
                                                        'destination': ref
                                                            .read(
                                                                destinationProvider
                                                                    .notifier)
                                                            .state,
                                                        'fare': (((calculateDistance(
                                                                        widget.coordinates[
                                                                            'lat'],
                                                                        widget.coordinates[
                                                                            'long'],
                                                                        ref
                                                                            .read(latProvider
                                                                                .notifier)
                                                                            .state,
                                                                        ref
                                                                            .read(longProvider.notifier)
                                                                            .state)) *
                                                                    12) +
                                                                45)
                                                            .toStringAsFixed(2)
                                                      },
                                                    );
                                                  }));
                                            },
                                            child: const Text(
                                              'Continue',
                                              style: TextStyle(
                                                  fontFamily: 'QBold',
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ],
                                      ));
                            })),
                      ),
                    ],
                  ),
                ),
              );
            }));
          }),
    );
  }
}
