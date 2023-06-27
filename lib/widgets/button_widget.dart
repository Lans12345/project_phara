import 'package:flutter/material.dart';
import 'package:phara/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? fontSize;
  final double? radius;
  final double? height;
  final double? opacity;
  final Color? color;
  final Color? textcolor;

  const ButtonWidget(
      {super.key,
      required this.label,
      required this.onPressed,
      this.textcolor = Colors.white,
      this.width = 300,
      this.fontSize = 18,
      this.height = 50,
      this.radius = 5,
      this.opacity = 0.6,
      this.color = const Color.fromARGB(255, 233, 228, 228)});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius!)),
        minWidth: width,
        height: height,
        color: color?.withOpacity(opacity!),
        onPressed: onPressed,
        child: TextBold(text: label, fontSize: fontSize!, color: textcolor!));
  }
}
