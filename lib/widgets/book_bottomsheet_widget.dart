import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:phara/widgets/trackbooking_bottomsheet_widget.dart';

import '../services/providers/coordinates_provider.dart';
import 'button_widget.dart';

class BookBottomSheetWidget extends StatelessWidget {
  final destinationController = TextEditingController();

  final String driverId;

  final Map coordinates;

  BookBottomSheetWidget(
      {super.key, required this.driverId, required this.coordinates});

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Drivers')
        .doc(driverId)
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

            double rating = data['ratings'].length / data['stars'];
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
                          const CircleAvatar(
                            minRadius: 50,
                            maxRadius: 50,
                            backgroundImage: NetworkImage(
                                'https://i.pinimg.com/originals/45/e1/9c/45e19c74f5c293c27a7ec8aee6a92936.jpg'),
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
                                  text: 'Vehicle: Sniper 150',
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
                                text: coordinates['pickupLocation'],
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
                          text: 'Distance: 1.3km', fontSize: 15, color: grey),
                      const SizedBox(
                        height: 5,
                      ),
                      TextRegular(
                          text: 'Estimated time: 30mins',
                          fontSize: 15,
                          color: grey),
                      const SizedBox(
                        height: 5,
                      ),
                      TextRegular(
                          text: 'Fare: ₱250.00', fontSize: 15, color: grey),
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
                            label: 'Book now',
                            onPressed: (() {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((context) {
                                    return const TrackBookingBottomSheetWidget();
                                  }));
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
