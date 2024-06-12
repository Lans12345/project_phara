import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/text_widget.dart';

import '../utils/colors.dart';
import 'home_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: grey,
            image: DecorationImage(
                opacity: 180,
                image: AssetImage('assets/images/newimg.jpg'),
                fit: BoxFit.fitHeight)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SafeArea(
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 10),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Image.asset(
                //           'assets/images/animation.gif',
                //           width: 50,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const Expanded(
                  child: SizedBox(),
                ),
                const Text(
                  'Enable Location Services',
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
                        "Let PARA access your location to find nearby drivers.",
                    fontSize: 18,
                    color: Colors.white),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ButtonWidget(
                    radius: 100,
                    color: Colors.black,
                    opacity: 1,
                    label: 'Enable Location Services',
                    onPressed: () async {
                      bool serviceEnabled =
                          await Geolocator.isLocationServiceEnabled();

                      LocationPermission permission =
                          await Geolocator.requestPermission();

                      if (permission == LocationPermission.denied &&
                          serviceEnabled == false) {
                        Fluttertoast.showToast(
                          gravity: ToastGravity.TOP,
                          toastLength: Toast.LENGTH_LONG,
                          msg:
                              'Cannot proceed without your location services being disabled, turn on your location services.',
                        );
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                        Fluttertoast.showToast(
                          toastLength: Toast.LENGTH_LONG,
                          msg: 'Location Services Enabled',
                        );
                      }
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
