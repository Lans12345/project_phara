import 'package:flutter/material.dart';
import 'package:phara/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: SizedBox(),
      ),
      appBar: AppBar(
        foregroundColor: grey,
        backgroundColor: Colors.white,
        title: TextFormField(
          decoration: const InputDecoration.collapsed(
            hintText: "Search Location",
            hintStyle: TextStyle(fontFamily: 'QBold', color: grey),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
              onPressed: (() {}), icon: const Icon(Icons.pin_drop_outlined))
        ],
      ),
    );
  }
}
