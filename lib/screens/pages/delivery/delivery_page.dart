import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phara/widgets/appbar_widget.dart';
import 'package:phara/widgets/drawer_widget.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => DeliveryPageState();
}

class DeliveryPageState extends State<DeliveryPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('Delivery'),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   location.Prediction? p = await PlacesAutocomplete.show(
      //       context: context,
      //       apiKey: kGoogleApiKey,
      //       language: 'en',
      //       strictbounds: false,
      //       types: [""],
      //       decoration: InputDecoration(
      //           hintText: 'Search Pick Up Location',
      //           focusedBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(20),
      //               borderSide: const BorderSide(color: Colors.white))),
      //       components: [location.Component(location.Component.country, "ph")]);

      //   location.GoogleMapsPlaces places = location.GoogleMapsPlaces(
      //       apiKey: kGoogleApiKey,
      //       apiHeaders: await const GoogleApiHeaders().getHeaders());

      //   location.PlacesDetailsResponse detail =
      //       await places.getDetailsByPlaceId(p!.placeId!);
      // }),
    );
  }
}
