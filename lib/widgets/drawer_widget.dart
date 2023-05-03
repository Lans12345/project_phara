import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phara/screens/auth/login_screen.dart';
import 'package:phara/screens/home_screen.dart';
import 'package:phara/screens/pages/aboutus_page.dart';
import 'package:phara/screens/pages/contactus_page.dart';
import 'package:phara/screens/pages/messages_tab.dart';
import 'package:phara/screens/pages/trips_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:phara/widgets/textfield_widget.dart';

class DrawerWidget extends StatelessWidget {
  final numberController = TextEditingController();

  DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: userData,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading'));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          dynamic data = snapshot.data;
          return SizedBox(
            child: Drawer(
              child: ListView(
                padding: const EdgeInsets.only(top: 0),
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    accountEmail: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.phone,
                              color: Colors.grey,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextRegular(
                                  text: data['number'],
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: ((context) {
                                          final formKey =
                                              GlobalKey<FormState>();
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[100],
                                            title: TextRegular(
                                                text: 'New contact number',
                                                fontSize: 14,
                                                color: Colors.black),
                                            content: Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFieldWidget(
                                                    hint: '09XXXXXXXXX',
                                                    inputType:
                                                        TextInputType.number,
                                                    label: 'Mobile Number',
                                                    controller:
                                                        numberController,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter a mobile number';
                                                      } else if (value.length !=
                                                              11 ||
                                                          !value.startsWith(
                                                              '09')) {
                                                        return 'Please enter a valid mobile number';
                                                      }

                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: (() {
                                                      Navigator.pop(context);
                                                    }),
                                                    child: TextRegular(
                                                        text: 'Close',
                                                        fontSize: 12,
                                                        color: grey),
                                                  ),
                                                  TextButton(
                                                    onPressed: (() async {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('Users')
                                                            .doc(data['id'])
                                                            .update({
                                                          'number':
                                                              numberController
                                                                  .text
                                                        });

                                                        Navigator.pop(context);
                                                      }
                                                    }),
                                                    child: TextBold(
                                                        text: 'Update',
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }));
                                  },
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    color: grey,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.email,
                              color: Colors.grey,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextRegular(
                              text: data['email'],
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                    accountName: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextBold(
                        text: data['name'],
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    currentAccountPicture: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        minRadius: 75,
                        maxRadius: 75,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: TextRegular(
                      text: 'Home',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.message_outlined),
                    title: TextRegular(
                      text: 'Messages',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MessagesTab()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.collections_bookmark_outlined),
                    title: TextRegular(
                      text: 'Recent trips',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const TripsPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.manage_accounts_outlined,
                    ),
                    title: TextRegular(
                      text: 'Contact us',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ContactusPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline_rounded,
                    ),
                    title: TextRegular(
                      text: 'About us',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const AboutusPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: TextRegular(
                      text: 'Logout',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                  'Logout Confirmation',
                                  style: TextStyle(
                                      fontFamily: 'QBold',
                                      fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  'Are you sure you want to Logout?',
                                  style: TextStyle(fontFamily: 'QRegular'),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
