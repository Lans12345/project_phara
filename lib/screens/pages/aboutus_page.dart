import 'package:flutter/material.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';

import '../../widgets/appbar_widget.dart';
import '../../widgets/drawer_widget.dart';

class AboutusPage extends StatelessWidget {
  const AboutusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('About Us'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            TextBold(text: 'Who awe are', fontSize: 24, color: black),
            const SizedBox(
              height: 10,
            ),
            TextRegular(
                text:
                    'Occaecat occaecat laborum et sit excepteur ipsum consequat. Voluptate laboris eu est officia et tempor voluptate pariatur minim laboris exercitation est. Minim do excepteur duis exercitation adipisicing exercitation sunt officia adipisicing cupidatat ad non. Aute et labore officia aliquip aliquip nulla dolore amet. Aliquip veniam sunt commodo occaecat in esse velit. Consequat tempor nulla deserunt velit. Reprehenderit eu elit do occaecat pariatur id eu laborum et dolor excepteur ex deserunt id. Quis aliquip mollit deserunt nulla fugiat magna aliqua est.',
                fontSize: 14,
                color: grey),
            const SizedBox(
              height: 50,
            ),
            TextBold(text: 'What we do', fontSize: 24, color: black),
            const SizedBox(
              height: 10,
            ),
            TextRegular(
                text:
                    'Occaecat occaecat laborum et sit excepteur ipsum consequat. Voluptate laboris eu est officia et tempor voluptate pariatur minim laboris exercitation est. Minim do excepteur duis exercitation adipisicing exercitation sunt officia adipisicing cupidatat ad non. Aute et labore officia aliquip aliquip nulla dolore amet. Aliquip veniam sunt commodo occaecat in esse velit. Consequat tempor nulla deserunt velit. Reprehenderit eu elit do occaecat pariatur id eu laborum et dolor excepteur ex deserunt id. Quis aliquip mollit deserunt nulla fugiat magna aliqua est.',
                fontSize: 14,
                color: grey),
            const Expanded(
              child: SizedBox(
                height: 10,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextRegular(text: 'PHara 2023', fontSize: 9, color: grey),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
