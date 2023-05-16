import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:phara/plugins/my_location.dart';
import 'package:phara/screens/get_started_screen.dart';
import 'package:phara/screens/home_screen.dart';
import 'package:phara/widgets/text_widget.dart';

import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    determinePosition();
    Timer(const Duration(seconds: 5), () async {
      bool serviceEnabled;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.requestPermission();
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg:
              'Cannot proceed without your location being enabled, turn on your location and open the app again',
        );
        return Future.error('Location services are disabled.');
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const HomeScreen();
                } else {
                  return const GetStartedScreen();
                }
              }),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: grey,
            image: DecorationImage(
                opacity: 150,
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextBold(text: 'Welcome', fontSize: 32, color: Colors.white),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/animation.gif',
                width: 250,
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),
                child: LinearProgressIndicator(
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
