import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phara/utils/colors.dart';

import '../data/user_stream.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/text_widget.dart';
import 'pages/notif_page.dart';
import 'package:badges/badges.dart' as b;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: DrawerWidget(),
      ),
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: grey,
        backgroundColor: Colors.white,
        title: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 24.0,
            fontFamily: 'QBold',
          ),
          child: TextBold(
            text: 'HOME',
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        actions: [
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseData().userData,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox();
                }
                dynamic data = snapshot.data;

                List oldnotifs = data['notif'];

                List notifs = oldnotifs.reversed.toList();
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NotifTab()));
                  },
                  icon: b.Badge(
                      showBadge: notifs.isNotEmpty,
                      badgeContent: TextRegular(
                        text: data['notif'].length.toString(),
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.notifications_rounded)),
                );
              }),
        ],
      ),
    );
  }
}
