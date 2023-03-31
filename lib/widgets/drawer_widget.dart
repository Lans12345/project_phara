import 'package:flutter/material.dart';
import 'package:phara/screens/auth/login_screen.dart';
import 'package:phara/screens/home_screen.dart';
import 'package:phara/screens/pages/messages_tab.dart';
import 'package:phara/screens/pages/trips_page.dart';
import 'package:phara/widgets/text_widget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      TextRegular(
                        text: '09090104355',
                        fontSize: 14,
                        color: Colors.grey,
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
                        text: 'olanalans12345@gmail.com',
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
                  text: 'Lance Olana',
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              currentAccountPicture: const Padding(
                padding: EdgeInsets.all(5.0),
                child: CircleAvatar(
                  minRadius: 75,
                  maxRadius: 75,
                  backgroundImage: AssetImage('assets/images/profile.png'),
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
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
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
              leading: const Icon(Icons.tab_rounded),
              title: TextRegular(
                text: 'Recent trips',
                fontSize: 12,
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TripsPage()));
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
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => HomeScreen()));
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
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => HomeScreen()));
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
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
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
  }
}
