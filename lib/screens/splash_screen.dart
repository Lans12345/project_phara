import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phara/screens/get_started_screen.dart';
import 'package:phara/screens/splashtohome_screen.dart';

import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 5), () async {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const SplashToHomeScreen();
              } else {
                return const GetStartedScreen();
              }
            }),
      ));
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
                opacity: 0.5,
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
