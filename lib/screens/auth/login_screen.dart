import 'package:flutter/material.dart';
import 'package:phara/screens/auth/signup_screen.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:phara/widgets/textfield_widget.dart';

import '../home_screen.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/back.png'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextBold(text: 'PHara', fontSize: 58, color: Colors.white),
                const SizedBox(
                  height: 75,
                ),
                TextRegular(text: 'Login', fontSize: 24, color: Colors.white),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    hint: 'Email', label: 'Email', controller: emailController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    showEye: true,
                    isObscure: true,
                    hint: 'Password',
                    label: 'Password',
                    controller: passwordController),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: ButtonWidget(
                    color: black,
                    label: 'Login',
                    onPressed: (() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    }),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextRegular(
                        text: "New to PHara?",
                        fontSize: 12,
                        color: Colors.white),
                    TextButton(
                      onPressed: (() {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                      }),
                      child: TextBold(
                          text: "Signup Now",
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
