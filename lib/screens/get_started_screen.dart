import 'package:flutter/material.dart';
import 'package:phara/screens/auth/landing_screen.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/text_widget.dart';

import '../utils/colors.dart';
import '../widgets/normal_dialog.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: grey,
            image: DecorationImage(
                opacity: 0.5,
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fitHeight)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/animation.gif',
                          width: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                const Text(
                  'Making your travels much easier.',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'QBold',
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextRegular(
                    text:
                        "Ride with ease and speed, experience the thrill of the road with PARA - your ultimate motorcycle ride-hailing app!",
                    fontSize: 14,
                    color: Colors.white),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ButtonWidget(
                    radius: 100,
                    color: Colors.black,
                    opacity: 1,
                    label: 'Get Started',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return NormalDialog(
                                label:
                                    "PARA collects location data to enable user tracking for the transaction of ride to be proccessed even when the app is closed or not in use.",
                                buttonColor: Colors.red,
                                buttonText: 'I understand',
                                icon: Icons.warning,
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LandingScreen()));
                                },
                                iconColor: Colors.red);
                          });
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
