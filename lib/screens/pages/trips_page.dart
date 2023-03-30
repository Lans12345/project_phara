import 'package:flutter/material.dart';
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
      body: ListView.builder(itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/rider.png',
                    height: 100,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBold(
                      text: 'Sample destination', fontSize: 14, color: grey),
                  TextRegular(
                      text: 'From: Sample destination',
                      fontSize: 12,
                      color: grey),
                  TextRegular(
                      text: 'Distance: 6.9km', fontSize: 12, color: grey),
                  TextRegular(text: 'Fare: ₱250.00', fontSize: 12, color: grey),
                  TextRegular(
                      text: 'February 15, 2023', fontSize: 12, color: grey),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: (() {}),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: grey,
                    ),
                  ),
                  IconButton(
                    onPressed: (() {}),
                    icon: const Icon(
                      Icons.star_border_rounded,
                      color: grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      })),
    );
  }
}
