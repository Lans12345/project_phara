import 'package:flutter/material.dart';
import 'package:phara/widgets/text_widget.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String? hint;
  bool? isObscure;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final int? maxLine;
  final TextInputType? inputType;
  late bool? showEye;
  late Color? color;
  late double? radius;

  final TextCapitalization? textCapitalization;

  TextFieldWidget(
      {required this.label,
      this.hint = '',
      required this.controller,
      this.isObscure = false,
      this.width = double.infinity,
      this.height = 40,
      this.maxLine = 1,
      this.showEye = false,
      this.color = Colors.white,
      this.radius = 5,
      this.textCapitalization = TextCapitalization.sentences,
      this.inputType = TextInputType.text});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextRegular(text: widget.label, fontSize: 12, color: Colors.white),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              border: Border.all(
                color: widget.color!,
              ),
              borderRadius: BorderRadius.circular(widget.radius!)),
          child: TextFormField(
            textCapitalization: widget.textCapitalization!,
            keyboardType: widget.inputType,
            decoration: InputDecoration(
              suffixIcon: widget.showEye! == true
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          widget.isObscure = !widget.isObscure!;
                        });
                      },
                      icon: widget.isObscure!
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off))
                  : const SizedBox(),
              filled: true,
              fillColor: Colors.white,
              hintText: widget.hint,
              border: InputBorder.none,
            ),
            maxLines: widget.maxLine,
            obscureText: widget.isObscure!,
            controller: widget.controller,
          ),
        ),
      ],
    );
  }
}
