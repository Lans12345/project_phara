import 'package:flutter/material.dart';
import 'package:phara/widgets/text_widget.dart';

import '../../utils/colors.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();

  String message = '';

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 3,
                child: SizedBox(
                  width: double.infinity,
                  height: 175,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircleAvatar(
                        minRadius: 50,
                        maxRadius: 50,
                        backgroundImage: NetworkImage(
                            'https://i.pinimg.com/originals/45/e1/9c/45e19c74f5c293c27a7ec8aee6a92936.jpg'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextBold(
                        text: 'Lance Olana',
                        fontSize: 18,
                        color: grey,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextRegular(
                        text: '09090104355',
                        fontSize: 14,
                        color: grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                    itemCount: 50,
                    controller: _scrollController,
                    itemBuilder: ((context, index) {
                      return Row(
                        mainAxisAlignment: index % 2 == 0
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          index % 2 != 0
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
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: black,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0),
                                bottomLeft: index % 2 == 0
                                    ? const Radius.circular(20.0)
                                    : const Radius.circular(0.0),
                                bottomRight: index % 2 == 0
                                    ? const Radius.circular(0.0)
                                    : const Radius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              'Sample Message',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          index % 2 == 0
                              ? const Padding(
                                  padding: EdgeInsets.only(right: 5),
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
            ),
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
                            borderSide: const BorderSide(width: 1, color: grey),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          hintText: 'Type a message',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            message = value;
                          });
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
                      color: message != '' ? Colors.green : grey,
                      onPressed: message == ''
                          ? (() {})
                          : (() {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOut);
                              messageController.clear();
                            }),
                      child: Icon(
                        Icons.send,
                        color: message != '' ? Colors.white : Colors.white30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
