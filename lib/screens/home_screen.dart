import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phara/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

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
      body: Scaffold(
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
