import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phara/services/add_messages.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/colors.dart';

class ChatPage extends StatefulWidget {
  final String driverId;
  const ChatPage({super.key, required this.driverId});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    getDriverData();
  }

  final messageController = TextEditingController();

  String message = '';

  final ScrollController _scrollController = ScrollController();

  bool executed = true;

  String driverName = '';
  String driverContactNumber = '';

  bool hasLoaded = false;

  getDriverData() {
    FirebaseFirestore.instance
        .collection('Drivers')
        .where('id', isEqualTo: widget.driverId)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        setState(() {
          driverName = doc['name'];
          driverContactNumber = doc['number'];
          hasLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> chatData = FirebaseFirestore.instance
        .collection('Messages')
        .doc(FirebaseAuth.instance.currentUser!.uid + widget.driverId)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: grey,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              minRadius: 22,
              maxRadius: 22,
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/originals/45/e1/9c/45e19c74f5c293c27a7ec8aee6a92936.jpg'),
            ),
            const SizedBox(
              width: 10,
            ),
            TextRegular(text: driverName, fontSize: 18, color: grey),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var text = 'tel:$driverContactNumber';
              if (await canLaunch(text)) {
                await launch(text);
              }
            },
            icon: const Icon(
              Icons.call,
              color: grey,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: hasLoaded
          ? SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream: chatData,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: Text('Loading'));
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong'));
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        dynamic data = snapshot.data;
                        List messages = data['messages'];
                        return Expanded(
                          child: SizedBox(
                            child: ListView.builder(
                                itemCount: messages.length,
                                controller: _scrollController,
                                itemBuilder: ((context, index) {
                                  if (executed) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeOut);

                                      setState(() {
                                        executed = false;
                                      });
                                    });
                                  }
                                  return Row(
                                    mainAxisAlignment: messages[index]
                                                ['sender'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      messages[index]['sender'] !=
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? const Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: CircleAvatar(
                                                minRadius: 15,
                                                maxRadius: 15,
                                                backgroundImage: NetworkImage(
                                                    'https://i.pinimg.com/originals/45/e1/9c/45e19c74f5c293c27a7ec8aee6a92936.jpg'),
                                              ),
                                            )
                                          : const SizedBox(),
                                      Column(
                                        crossAxisAlignment: messages[index]
                                                    ['sender'] ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 10.0),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            decoration: BoxDecoration(
                                              color: black,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20.0),
                                                topRight:
                                                    const Radius.circular(20.0),
                                                bottomLeft: messages[index]
                                                            ['sender'] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? const Radius.circular(
                                                        20.0)
                                                    : const Radius.circular(
                                                        0.0),
                                                bottomRight: messages[index]
                                                            ['sender'] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? const Radius.circular(0.0)
                                                    : const Radius.circular(
                                                        20.0),
                                              ),
                                            ),
                                            child: Text(
                                              messages[index]['message'],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontFamily: 'QRegular'),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              DateFormat.jm().format(
                                                  messages[index]['dateTime']
                                                      .toDate()),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.0,
                                                  fontFamily: 'QRegular'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      messages[index]['sender'] ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: CircleAvatar(
                                                minRadius: 15,
                                                maxRadius: 15,
                                                backgroundImage: AssetImage(
                                                  'assets/images/profile.png',
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  );
                                })),
                          ),
                        );
                      }),
                  const Divider(
                    color: grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 45,
                            width: 240,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: messageController,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(width: 1, color: grey),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                hintText: 'Type a message',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                message = value;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          MaterialButton(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            minWidth: 75,
                            height: 45,
                            color: Colors.green,
                            onPressed: (() async {
                              if (message != '') {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Messages')
                                      .doc(FirebaseAuth
                                              .instance.currentUser!.uid +
                                          widget.driverId)
                                      .update({
                                    'lastMessage': messageController.text,
                                    'dateTime': DateTime.now(),
                                    'messages': FieldValue.arrayUnion([
                                      {
                                        'message': messageController.text,
                                        'dateTime': DateTime.now(),
                                        'sender': FirebaseAuth
                                            .instance.currentUser!.uid
                                      }
                                    ]),
                                  });
                                } catch (e) {
                                  addMessage(
                                      widget.driverId, messageController.text);
                                }
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut);
                                messageController.clear();
                                message = '';
                              }
                            }),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
