import 'package:flutter/material.dart';
import 'package:phara/screens/pages/chat_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';

import '../../widgets/appbar_widget.dart';
import '../../widgets/drawer_widget.dart';

class MessagesTab extends StatefulWidget {
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
          Expanded(
            child: SizedBox(
              child: ListView.separated(
                  itemCount: 100,
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Divider(
                        color: grey,
                      ),
                    );
                  },
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatPage()));
                        },
                        leading: const CircleAvatar(
                          maxRadius: 25,
                          minRadius: 25,
                          backgroundImage: AssetImage(
                            'assets/images/profile.png',
                          ),
                        ),
                        title: TextBold(
                            text: 'Lance Olana', fontSize: 15, color: grey),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextRegular(
                                text: 'Sample message right here',
                                fontSize: 12,
                                color: grey),
                            TextRegular(
                                text: '2:30 PM', fontSize: 12, color: grey),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.arrow_right,
                          color: grey,
                        ),
                      ),
                    );
                  })),
            ),
          ),
        ],
      ),
    );
  }
}
