import 'package:flutter/material.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';

PreferredSizeWidget AppbarWidget(String title) {
  return AppBar(
    centerTitle: true,
    foregroundColor: grey,
    backgroundColor: Colors.white,
    title: TextRegular(text: title, fontSize: 24, color: grey),
  );
}
