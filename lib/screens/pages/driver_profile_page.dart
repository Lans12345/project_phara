import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/text_widget.dart';

class DriverProfilePage extends StatelessWidget {
  final String driverId;

  const DriverProfilePage({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Drivers')
        .doc(driverId)
        .snapshots();
    return Scaffold(
      appBar: AppbarWidget('Driver Profile'),
      body: StreamBuilder<DocumentSnapshot>(
          stream: userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            dynamic data = snapshot.data;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
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
                              SizedBox(
                                width: 140,
                                child: TextRegular(
                                    text: 'Vehicle: ${data['vehicle']}',
                                    fontSize: 14,
                                    color: grey),
                              ),
                              SizedBox(
                                width: 140,
                                child: TextRegular(
                                    text: 'Plate No.: ${data['plateNumber']}',
                                    fontSize: 14,
                                    color: grey),
                              ),
                              TextRegular(
                                  text: data['ratings'].length != 0
                                      ? 'Rating: ${(data['stars'] / data['ratings'].length).toStringAsFixed(2)} ★'
                                      : 'No ratings',
                                  fontSize: 14,
                                  color: Colors.amber),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
