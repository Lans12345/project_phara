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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Card(
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: TextRegular(
                        text: data['comments'].length != 0
                            ? 'Passenger Feedbacks'
                            : 'No feedbacks yet',
                        fontSize: 14,
                        color: Colors.amber),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                        itemCount: data['comments'].length,
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.asset(
                              'assets/images/profile.png',
                            ),
                            title: Text(
                              data['comments'][index]['feedback'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'QRegular'),
                            ),
                            subtitle: TextBold(
                                text: data['comments'][index]['myName'],
                                fontSize: 12,
                                color: Colors.grey),
                            trailing: TextRegular(
                                text:
                                    '${data['comments'][index]['stars']}.00 ★',
                                fontSize: 14,
                                color: Colors.amber),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
