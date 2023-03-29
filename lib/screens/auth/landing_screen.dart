import 'package:flutter/material.dart';
import 'package:phara/screens/auth/signup_screen.dart';
import 'package:phara/screens/auth/login_screen.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/text_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            color: grey,
            image: DecorationImage(
                opacity: 150,
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextBold(text: 'PHara', fontSize: 48, color: Colors.white),
                TextRegular(
                    text: 'Making your travels more easier',
                    fontSize: 15,
                    color: Colors.white),
                const SizedBox(
                  height: 75,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ButtonWidget(
                        label: 'Login',
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 50,
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextRegular(
                              text: 'or', fontSize: 18, color: Colors.white),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 50,
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: (() {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        }),
                        child: TextBold(
                            text: 'Signup', fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/fblogo.png',
                              height: 35,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/googlelogo.png',
                              height: 35,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
