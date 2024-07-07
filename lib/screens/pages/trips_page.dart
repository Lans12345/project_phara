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
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('Recent Trips'),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('History')
              .where('myid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print('error');
              return const Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              );
            }

            final data = snapshot.requireData;
            return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          minRadius: 37,
                          maxRadius: 37,
                          backgroundColor: Colors.black,
                          child: TextBold(
                              text: data.docs[index]['destination'][0],
                              fontSize: 24,
                              color: Colors.white),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              child: TextBold(
                                  text:
                                      'To: ${data.docs[index]['destination']}',
                                  fontSize: 14,
                                  color: grey),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextRegular(
                                  text: 'From: ${data.docs[index]['origin']}',
                                  fontSize: 12,
                                  color: grey),
                            ),
                            TextRegular(
                                text:
                                    'Distance: ${data.docs[index]['distance']}km',
                                fontSize: 12,
                                color: grey),
                            TextRegular(
                                text: 'Fare: ₱${data.docs[index]['fare']}',
                                fontSize: 12,
                                color: grey),
                            TextRegular(
                                text: DateFormat.yMMMd()
                                    .add_jm()
                                    .format(data.docs[index]['date'].toDate()),
                                fontSize: 12,
                                color: grey),
                            TextRegular(
                                text:
                                    'Ratings: ${data.docs[index]['rating']} ★',
                                fontSize: 12,
                                color: grey),
                          ],
                        ),
                        IconButton(
                          onPressed: (() async {
                            await FirebaseFirestore.instance
                                .collection('History')
                                .doc(data.docs[index].id)
                                .delete();
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
