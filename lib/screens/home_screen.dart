import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phara/screens/pages/bookmark_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/book_bottomsheet_widget.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/drawer_widget.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

import '../widgets/delegate/search_my_places.dart';
import 'pages/messages_tab.dart';

class HomeScreen extends StatelessWidget {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final List<LatLng> _markerLocations = [
    const LatLng(37.4220, -122.0841),
    const LatLng(37.4275, -122.1697),
    const LatLng(37.7749, -122.4194),
    const LatLng(37.3382, -121.8863),
    const LatLng(37.4833, -122.2167),
    const LatLng(37.3352, -121.8811),
    const LatLng(37.3541, -121.9552),
    const LatLng(37.5407, -122.2924),
    const LatLng(37.8044, -122.2711),
    const LatLng(37.8716, -122.2727),
  ];

  Set<Marker> _createMarkers(context) {
    return _markerLocations.map((location) {
      return Marker(
        markerId: MarkerId(location.toString()),
        draggable: true,
        onDragEnd: (value) {
          print(value.latitude);
          print(value.longitude);
        },
        position: location,
        infoWindow: InfoWindow(
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: ((context) {
                  return BookBottomSheetWidget();
                }));
          },
          title: 'Lance Olana',
          snippet: 'Sniper 150',
        ),
      );
    }).toSet();
  }

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
              onPressed: (() {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const BookmarksPage()));
              }),
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
        title: GestureDetector(
          onTap: () async {
            final sessionToken = const Uuid().v4();

            await showSearch(
                context: context, delegate: LocationsSearch(sessionToken));
          },
          child: TextFormField(
            enabled: false,
            decoration: const InputDecoration.collapsed(
              hintText: "Search Location",
              hintStyle: TextStyle(fontFamily: 'QBold', color: grey),
              border: InputBorder.none,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: (() {}),
            icon: const Icon(Icons.pin_drop_outlined),
          ),
          Badge(
            position: BadgePosition.custom(start: -1, top: 3),
            badgeContent: TextRegular(
              text: '1',
              fontSize: 12,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: (() {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MessagesTab()));
              }),
              icon: const Icon(Icons.message_outlined),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            markers: _createMarkers(context),
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
