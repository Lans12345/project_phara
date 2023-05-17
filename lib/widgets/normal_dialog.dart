import 'package:flutter/material.dart';

import 'button_widget.dart';

class NormalDialog extends StatelessWidget {
  late String label;
  late Color buttonColor;
  late IconData icon;
  late Color iconColor;
  late VoidCallback onPressed;
  late String buttonText;

  NormalDialog({
    super.key,
    required this.label,
    required this.buttonColor,
    required this.buttonText,
    required this.icon,
    required this.onPressed,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: iconColor,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontFamily: 'QRegular'),
                )),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: ButtonWidget(
                  opacity: 1,
                  radius: 100,
                  label: buttonText,
                  color: buttonColor,
                  onPressed: onPressed),
            ),
          ],
        ),
      ),
    );
  }
}
