import 'package:flutter/material.dart';
import 'package:phara/screens/pages/chat_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';

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
      drawer: DrawerWidget(),
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
              child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ChatPage(
                                driverId: '',
                              )));
                        },
                        leading: const CircleAvatar(
                          maxRadius: 25,
                          minRadius: 25,
                          backgroundImage: NetworkImage(
                            'https://i.pinimg.com/originals/45/e1/9c/45e19c74f5c293c27a7ec8aee6a92936.jpg',
                          ),
                        ),
                        title: index % 2 == 0
                            ? TextRegular(
                                text: 'Lance Olana', fontSize: 15, color: grey)
                            : TextBold(
                                text: 'Lance Olana',
                                fontSize: 15,
                                color: Colors.black),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            index % 2 == 0
                                ? const Text(
                                    'Sample message right here',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: grey,
                                        fontFamily: 'QRegular'),
                                  )
                                : const Text(
                                    'Sample message right here',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily: 'QBold'),
                                  ),
                            index % 2 == 0
                                ? TextRegular(
                                    text: '2:30 PM', fontSize: 12, color: grey)
                                : TextBold(
                                    text: '2:30 PM',
                                    fontSize: 12,
                                    color: Colors.black),
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
