import 'package:flutter/material.dart';
import 'package:phara/screens/home_screen.dart';
import 'package:phara/screens/auth/login_screen.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:phara/widgets/textfield_widget.dart';

class SignupScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                  height: 20,
                ),
                TextBold(text: 'PHara', fontSize: 58, color: Colors.white),
                const SizedBox(
                  height: 25,
                ),
                TextRegular(text: 'Signup', fontSize: 24, color: Colors.white),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(label: 'Name', controller: nameController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    inputType: TextInputType.number,
                    label: 'Mobile Number',
                    controller: numberController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    inputType: TextInputType.streetAddress,
                    label: 'Address',
                    controller: addressController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    inputType: TextInputType.streetAddress,
                    label: 'Email',
                    controller: emailController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    showEye: true,
                    isObscure: true,
                    inputType: TextInputType.streetAddress,
                    label: 'Password',
                    controller: passwordController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    showEye: true,
                    isObscure: true,
                    inputType: TextInputType.streetAddress,
                    label: 'Confirm Password',
                    controller: confirmPasswordController),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: ButtonWidget(
                    color: black,
                    label: 'Signup',
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
                        text: "Already have an Account?",
                        fontSize: 12,
                        color: Colors.white),
                    TextButton(
                      onPressed: (() {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      }),
                      child: TextBold(
                          text: "Login Now", fontSize: 14, color: Colors.white),
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
