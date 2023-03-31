import 'package:flutter/material.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';

import '../../widgets/appbar_widget.dart';
import '../../widgets/drawer_widget.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('Messages'),
      body: ListView.separated(
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
                leading: const CircleAvatar(
                  maxRadius: 25,
                  minRadius: 25,
                  backgroundImage: AssetImage(
                    'assets/images/profile.png',
                  ),
                ),
                title: TextBold(text: 'Lance Olana', fontSize: 15, color: grey),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextRegular(
                        text: 'Sample message right here',
                        fontSize: 12,
                        color: grey),
                    TextRegular(text: '2:30 PM', fontSize: 12, color: grey),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: grey,
                ),
              ),
            );
          })),
    );
  }
}
