import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phara/data/user_stream.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/appbar_widget.dart';
import 'package:phara/widgets/drawer_widget.dart';
import 'package:phara/widgets/text_widget.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppbarWidget('Recent Trips'),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseData().userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading'));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            dynamic data = snapshot.data;

            List history = data['history'];
            List newhistory = history.reversed.toList();
            return ListView.builder(
                itemCount: newhistory.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              height: 100,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              child: TextBold(
                                  text:
                                      'To: ${newhistory[index]['destination']}',
                                  fontSize: 14,
                                  color: grey),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextRegular(
                                  text: 'From: ${newhistory[index]['origin']}',
                                  fontSize: 12,
                                  color: grey),
                            ),
                            TextRegular(
                                text:
                                    'Distance: ${newhistory[index]['distance']}km',
                                fontSize: 12,
                                color: grey),
                            TextRegular(
                                text: 'Fare: ₱${newhistory[index]['fare']}',
                                fontSize: 12,
                                color: grey),
                            TextRegular(
                                text: DateFormat.yMMMd()
                                    .add_jm()
                                    .format(newhistory[index]['date'].toDate()),
                                fontSize: 12,
                                color: grey),
                          ],
                        ),
                        IconButton(
                          onPressed: (() async {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              'history':
                                  FieldValue.arrayRemove([newhistory[index]]),
                            });
                          }),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }));
          }),
    );
  }
}
