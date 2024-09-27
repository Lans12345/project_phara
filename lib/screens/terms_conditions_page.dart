import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/text_widget.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: grey,
          backgroundColor: Colors.white,
          title: TextRegular(
              text: 'Terms and Conditions', fontSize: 24, color: grey),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Terms and Conditions',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                SizedBox(height: 14.0),
                Text(
                  'Please read these terms and conditions carefully before using PASADA. By using the application, you agree to be bound by these terms and conditions.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '1. User Eligibility',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '1.1 PASADA can only be used by individuals who are at least 18 years old and possess a valid tricycle license.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '2. Booking and Ride Process',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '2.1 Users can book a ride by providing their current location and desired destination through the PASADA application.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                Text(
                  '2.2 The availability of tricycle drivers and the estimated time of arrival are provided for informational purposes and may vary based on traffic conditions.',
                  style: TextStyle(fontSize: 16.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '3. Payment',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '3.1 Payments for the rides can be made through the available payment methods supported by PASADA.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '4. User Conduct',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '4.1 Users are expected to behave responsibly and respectfully towards the tricycle drivers and other users.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                Text(
                  '4.2 Any damage caused to the tricycle during the ride due to user negligence may result in additional charges.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '5. Limitation of Liability',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '5.1 PASADA shall not be held liable for any damages, losses, or injuries arising from the use of the application or the services provided by the tricycle drivers.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                Text(
                  '5.2 PASADA does not guarantee the availability of tricycle drivers at all times. The application relies on the availability of independent tricycle drivers, and their availability cannot be guaranteed.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                Text(
                  '5.3 PASADA shall not be responsible for any delays, cancellations, or changes in the ride schedule caused by factors beyond its control, including but not limited to traffic conditions, weather conditions, or any other unforeseen circumstances.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '6. User Privacy',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '6.1 PASADA collects and processes user personal information in accordance with its Privacy Policy. By using the application, you consent to the collection and processing of your personal information as described in the Privacy Policy.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '7. Intellectual Property',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '7.1 The PASADA application and all its content, including but not limited to logos, trademarks, and graphics, are the intellectual property of PASADA. Users are prohibited from reproducing, distributing, or modifying any part of the application without prior written consent from PASADA.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '8. Governing Law and Dispute Resolution',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '8.1 These terms and conditions shall be governed by and construed in accordance with the laws of Philippines. Any disputes arising from the use of PASADA shall be subject to the exclusive jurisdiction of the courts in Philippines.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '9. Modifications to the Terms and Conditions',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '9.1 PASADA reserves the right to modify or update these terms and conditions at any time. Users will be notified of any changes through the application or via email. Continued use of the application after the modifications constitutes acceptance of the updated terms and conditions.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '10. Contact Us',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QBold'),
                ),
                Text(
                  '10.1 If you have any questions or concerns regarding these terms and conditions, please contact us at algovision123@gmail.com',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'QRegular'),
                ),
              ],
            ),
          ),
        ));
  }
}
