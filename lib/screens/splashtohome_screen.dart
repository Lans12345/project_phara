import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phara/screens/home_screen.dart';
import 'package:phara/screens/permission_screen.dart';

import '../plugins/my_location.dart';
import '../utils/colors.dart';

class SplashToHomeScreen extends StatefulWidget {
  const SplashToHomeScreen({super.key});

  @override
  State<SplashToHomeScreen> createState() => _SplashToHomeScreenState();
}

class _SplashToHomeScreenState extends State<SplashToHomeScreen> {
  final box = GetStorage();
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
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PermissionScreen()));
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg:
              'Cannot proceed without your location being enabled, turn on your location!',
        );
        return Future.error('Location services are disabled.');
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
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
                image: AssetImage('assets/images/newimg.jfif'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/images/animation.gif',
              //   width: 250,
              // ),
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
