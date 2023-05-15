import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:phara/screens/pages/chat_page.dart';
import 'package:phara/widgets/text_widget.dart';

import '../../plugins/my_location.dart';
import '../../utils/colors.dart';
import '../../utils/keys.dart';
import '../home_screen.dart';

class TrackingOfDriverPage extends StatefulWidget {
  final Map tripDetails;

  const TrackingOfDriverPage({super.key, required this.tripDetails});

  @override
  State<TrackingOfDriverPage> createState() => _TrackingOfDriverPageState();
}

class _TrackingOfDriverPageState extends State<TrackingOfDriverPage> {
  late StreamSubscription<loc.LocationData> subscription;

  @override
  void initState() {
    super.initState();
    determinePosition();
    getLocation();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      getDrivers();
    });
  }

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = kGoogleApiKey;

  var hasLoaded = false;

  GoogleMapController? mapController;

  Set<Marker> markers = {};

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late double lat = 0;
  late double long = 0;

  @override
  Widget build(BuildContext context) {
    final CameraPosition camPosition = CameraPosition(
        target: LatLng(lat, long), zoom: 16, bearing: 45, tilt: 40);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: (() {
            mapController?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    bearing: 45,
                    tilt: 40,
                    target: LatLng(lat, long),
                    zoom: 16)));
          }),
          child: const Icon(
            Icons.my_location_rounded,
            color: Colors.red,
          )),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ratingsDialog();
          },
          icon: const Icon(
            Icons.exit_to_app_rounded,
            color: grey,
          ),
        ),
        foregroundColor: grey,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              minRadius: 17.5,
              maxRadius: 17.5,
              backgroundImage:
                  NetworkImage(widget.tripDetails['driverProfile']),
            ),
            const SizedBox(
              width: 20,
            ),
            TextRegular(
                text: widget.tripDetails['driverName'],
                fontSize: 20,
                color: grey),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ChatPage(
                        driverName: widget.tripDetails['driverName'],
                        driverId: widget.tripDetails['driverId'],
                      )));
            },
            icon: const Icon(
              Icons.message_outlined,
              color: grey,
            ),
          ),
        ],
      ),
      body: hasLoaded
          ? Stack(
              children: [
                GoogleMap(
                  polylines: {_poly},
                  zoomControlsEnabled: false,
                  buildingsEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  markers: markers,
                  mapType: MapType.normal,
                  initialCameraPosition: camPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    setState(() {
                      mapController = controller;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 50,
                      width: 200,
                      child: Center(
                        child: TextRegular(
                            text: 'Driver on the way',
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  late Polyline _poly;

  getDrivers() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    FirebaseFirestore.instance
        .collection('Drivers')
        .where('id', isEqualTo: widget.tripDetails['driverId'])
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        Marker driverMarker = Marker(
            markerId: MarkerId(doc['name']),
            infoWindow: InfoWindow(
              title: doc['name'],
              snippet: doc['number'],
            ),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(doc['location']['lat'], doc['location']['long']));
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
            googleAPIKey,
            PointLatLng(position.latitude, position.longitude),
            PointLatLng(doc['location']['lat'], doc['location']['long']));
        if (result.points.isNotEmpty) {
          polylineCoordinates = result.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
        }
        setState(() {
          _poly = Polyline(
              color: Colors.red,
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              width: 4);
          markers.add(driverMarker);
          hasLoaded = true;
        });
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                bearing: 45,
                tilt: 40,
                target: LatLng(doc['location']['lat'], doc['location']['long']),
                zoom: 18)));
      }
    });
  }

  ratingsDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextRegular(
                text: 'Rate your experience',
                fontSize: 14,
                color: Colors.black),
            content: SizedBox(
              height: 50,
              child: Center(
                child: RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) async {
                    int stars = 0;

                    await FirebaseFirestore.instance
                        .collection('Drivers')
                        .where('id', isEqualTo: widget.tripDetails['driverId'])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        setState(() {
                          stars = doc['stars'];
                        });
                      }
                    });
                    await FirebaseFirestore.instance
                        .collection('Drivers')
                        .doc(widget.tripDetails['driverId'])
                        .update({
                      'ratings': FieldValue.arrayUnion(
                          [FirebaseAuth.instance.currentUser!.uid]),
                      'stars': stars + rating.toInt()
                    });
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
                child: TextBold(
                    text: 'Continue', fontSize: 18, color: Colors.amber),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    mapController!.dispose();

    super.dispose();
  }
}
