import 'package:flutter/material.dart';

Widget CustomMarker(String imageUrl, Color color) {
  return Stack(
    children: [
      Icon(
        Icons.add_location,
        color: color,
        size: 50,
      ),
      Positioned(
        left: 15,
        top: 8,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          )),
        ),
      )
    ],
  );
}
