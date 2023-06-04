import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phara/screens/pages/chat_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../../widgets/appbar_widget.dart';
import '../../widgets/drawer_widget.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({super.key});

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  final messageController = TextEditingController();

  String filter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('Messages'),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 300,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: messageController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: grey,
                ),
                suffixIcon: filter != ''
                    ? IconButton(
                        onPressed: (() {
                          setState(() {
                            filter = '';
                            messageController.clear();
                          });
                        }),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: grey,
                        ),
                      )
                    : const SizedBox(),
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: grey),
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(100),
                ),
                hintText: 'Search Message',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: filter != ''
                  ? FirebaseFirestore.instance
                      .collection('Messages')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('driverName',
                          isGreaterThanOrEqualTo:
                              toBeginningOfSentenceCase(filter))
                      .where('driverName',
                          isLessThan: '${toBeginningOfSentenceCase(filter)}z')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('Messages')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .orderBy('dateTime')
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                        itemCount: data.docs.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(5),
                              child: ListTile(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection('Messages')
                                      .doc(data.docs[index].id)
                                      .update({'seen': true});
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                            driverId: data.docs[index]
                                                ['driverId'],
                                            driverName: data.docs[index]
                                                ['driverName'],
                                          )));
                                },
                                leading: CircleAvatar(
                                  maxRadius: 25,
                                  minRadius: 25,
                                  backgroundImage: NetworkImage(
                                    data.docs[index]['driverProfile'],
                                  ),
                                ),
                                title: data.docs[index]['seen'] == true
                                    ? TextRegular(
                                        text: data.docs[index]['driverName'],
                                        fontSize: 15,
                                        color: grey)
                                    : TextBold(
                                        text: data.docs[index]['driverName'],
                                        fontSize: 15,
                                        color: Colors.black),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    data.docs[index]['seen'] == true
                                        ? Text(
                                            data.docs[index]['lastMessage']
                                                        .toString()
                                                        .length >
                                                    21
                                                ? '${data.docs[index]['lastMessage'].toString().substring(0, 21)}...'
                                                : data.docs[index]
                                                    ['lastMessage'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: grey,
                                                fontFamily: 'QRegular'),
                                          )
                                        : Text(
                                            data.docs[index]['lastMessage']
                                                        .toString()
                                                        .length >
                                                    21
                                                ? '${data.docs[index]['lastMessage'].toString().substring(0, 21)}...'
                                                : data.docs[index]
                                                    ['lastMessage'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontFamily: 'QBold'),
                                          ),
                                    data.docs[index]['seen'] == true
                                        ? TextRegular(
                                            text: DateFormat.jm().format(data
                                                .docs[index]['dateTime']
                                                .toDate()),
                                            fontSize: 12,
                                            color: grey)
                                        : TextBold(
                                            text: DateFormat.jm().format(data
                                                .docs[index]['dateTime']
                                                .toDate()),
                                            fontSize: 12,
                                            color: Colors.black),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.arrow_right,
                                  color: grey,
                                ),
                              ));
                        })),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
