import 'package:flutter/material.dart';
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
    // Timer(const Duration(seconds: 5), () async {
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (context) => StreamBuilder<User?>(
    //         stream: FirebaseAuth.instance.authStateChanges(),
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {
    //             return const HomeScreen();
    //           } else {
    //             return const LoginScreen();
    //           }
    //         }),
    //   ));
    // });
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
                'assets/images/rider.png',
                width: 250,
              ),
              const SizedBox(
                height: 50,
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
