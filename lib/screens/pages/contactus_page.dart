import 'package:flutter/material.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';

import '../../widgets/appbar_widget.dart';
import '../../widgets/drawer_widget.dart';

class ContactusPage extends StatelessWidget {
  const ContactusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('Contact Us'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/googlelogo.png',
                  height: 25,
                  color: grey,
                ),
                const SizedBox(
                  width: 20,
                ),
                TextRegular(
                    text: 'algovision123@gmail.com', fontSize: 16, color: grey),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/fblogo.png',
                  height: 25,
                  color: grey,
                ),
                const SizedBox(
                  width: 20,
                ),
                TextRegular(
                    text: 'facebook.com/algovision', fontSize: 16, color: grey),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_phone_outlined,
                  color: grey,
                  size: 28,
                ),
                const SizedBox(
                  width: 20,
                ),
                TextRegular(text: '+639639530422', fontSize: 16, color: grey),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.pin_drop_outlined,
                  color: grey,
                  size: 28,
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 200,
                  child: TextRegular(
                      text: 'Province of Aurora, Philippines',
                      fontSize: 16,
                      color: grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
