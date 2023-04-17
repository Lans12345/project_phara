import 'package:flutter/material.dart';
import 'package:phara/widgets/text_widget.dart';

import '../utils/colors.dart';
import 'button_widget.dart';

class TrackBookingBottomSheetWidget extends StatelessWidget {
  final Map tripDetails;

  const TrackBookingBottomSheetWidget({super.key, required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: SizedBox(
        height: 520,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child:
                    TextBold(text: 'Current trip', fontSize: 24, color: grey),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        height: 75,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 100,
                    child: Divider(
                      thickness: 5,
                      color: Colors.blue[900],
                    ),
                  ),
                  const Icon(
                    Icons.pin_drop_rounded,
                    color: Colors.red,
                    size: 58,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.red,
                  ),
                  title: TextRegular(
                      text: 'Distance: ${tripDetails['distance']} km',
                      fontSize: 16,
                      color: grey),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.my_location,
                    color: grey,
                  ),
                  title: TextRegular(
                      text: 'From:  ${tripDetails['origin']}',
                      fontSize: 16,
                      color: grey),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.pin_drop_rounded,
                    color: Colors.red,
                  ),
                  title: TextRegular(
                      text: 'To:  ${tripDetails['destination']}',
                      fontSize: 16,
                      color: grey),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.payments_outlined,
                    color: grey,
                  ),
                  title: TextRegular(
                      text: 'Fare: ₱${tripDetails['fare']}',
                      fontSize: 16,
                      color: grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1.5,
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                radius: 100,
                opacity: 1,
                color: black,
                label: 'Track driver',
                onPressed: (() {}),
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonWidget(
                radius: 100,
                opacity: 1,
                color: Colors.green,
                label: 'Confirm payment',
                onPressed: (() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
