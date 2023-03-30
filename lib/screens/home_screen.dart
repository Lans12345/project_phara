import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/drawer_widget.dart';

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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: (() {}),
              child: const Icon(
                Icons.pin_drop_rounded,
                color: Colors.red,
              )),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: (() {}),
              child: const Icon(
                Icons.push_pin_rounded,
                color: grey,
              )),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: (() {}),
              child: const Icon(
                Icons.my_location_rounded,
                color: grey,
              )),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: (() {}),
              child: const Icon(
                Icons.collections_bookmark_outlined,
                color: grey,
              )),
        ],
      ),
      drawer: const Drawer(
        child: DrawerWidget(),
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
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonWidget(
                    width: 175,
                    radius: 100,
                    opacity: 1,
                    color: Colors.red,
                    label: 'Clear pin',
                    onPressed: (() {})),
                const SizedBox(
                  height: 20,
                ),
                ButtonWidget(
                    width: 175,
                    radius: 100,
                    opacity: 1,
                    color: Colors.green,
                    label: 'Book a ride',
                    onPressed: (() {})),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
