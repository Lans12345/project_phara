import 'dart:async';

import 'package:badges/badges.dart' as b;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phara/plugins/my_location.dart';
import 'package:phara/screens/pages/bookmark_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/book_bottomsheet_widget.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/drawer_widget.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

import '../widgets/delegate/search_my_places.dart';
import 'pages/messages_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();
    getLocation();
    getAllDrivers();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late String currentAddress;

  late double lat = 0;
  late double long = 0;

  var hasLoaded = false;

  String driverId = '';

  GoogleMapController? mapController;

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final CameraPosition camPosition = CameraPosition(
        target: LatLng(lat, long), zoom: 16, bearing: 45, tilt: 40);
    return hasLoaded
        ? Scaffold(
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: (() {
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              bearing: 45,
                              tilt: 40,
                              target: LatLng(lat, long),
                              zoom: 16)));
                    }),
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
                          builder: (context) => MessagesTab()));
                    }),
                    child: const Icon(
                      Icons.message_outlined,
                      color: grey,
                    )),
                const SizedBox(
                  height: 15,
                ),
                FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: (() {}),
                    child: b.Badge(
                      badgeStyle: b.BadgeStyle(
                        badgeColor: Colors.amber[700]!,
                      ),
                      badgeContent: TextRegular(
                          text: '5', fontSize: 12, color: Colors.white),
                      child: const Icon(
                        Icons.star_border_rounded,
                        color: grey,
                      ),
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
            drawer: Drawer(
              child: DrawerWidget(),
            ),
            appBar: AppBar(
              foregroundColor: grey,
              backgroundColor: Colors.white,
              title:
                  TextRegular(text: 'PHara', fontSize: 24, color: Colors.black),
              actions: [
                b.Badge(
                  position: b.BadgePosition.custom(start: -1, top: 3),
                  badgeContent: TextRegular(
                    text: '1',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    onPressed: (() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MessagesTab()));
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
                  zoomControlsEnabled: false,
                  buildingsEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  markers: markers,
                  mapType: MapType.normal,
                  initialCameraPosition: camPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    setState(() {
                      myLocationMarker(lat, long);
                      mapController = controller;
                    });
                  },
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      driverId != ''
                          ? ButtonWidget(
                              width: 175,
                              radius: 100,
                              opacity: 1,
                              color: Colors.green,
                              label: 'Book a ride',
                              onPressed: (() async {
                                List<Placemark> p =
                                    await placemarkFromCoordinates(lat, long);

                                Placemark place = p[0];

                                final sessionToken = const Uuid().v4();

                                await showSearch(
                                    context: context,
                                    delegate: LocationsSearch(sessionToken));

                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: ((context) {
                                      return BookBottomSheetWidget(
                                        driverId: driverId,
                                        coordinates: {
                                          'lat': lat,
                                          'long': long,
                                          'pickupLocation':
                                              '${place.street}, ${place.locality}, ${place.administrativeArea}'
                                        },
                                      );
                                    }));
                              }))
                          : const SizedBox(),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  myLocationMarker(double lat, double lang) async {
    Marker mylocationMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        infoWindow: const InfoWindow(
          title: 'Your Current Location',
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(lat, lang));

    markers.add(mylocationMarker);
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> p =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = p[0];

    setState(() {
      lat = position.latitude;
      long = position.longitude;
      currentAddress =
          '${place.street}, ${place.subLocality}, ${place.locality}';
      hasLoaded = true;
    });
  }

  getAllDrivers() async {
    FirebaseFirestore.instance
        .collection('Drivers')
        .where('isActive', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        Marker driverMarker = Marker(
            onTap: () {
              setState(() {
                driverId = doc['id'];
              });
            },
            markerId: MarkerId(doc['name']),
            infoWindow: InfoWindow(
              title: doc['name'],
              snippet: doc['number'],
            ),
            icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(
                size: Size(12, 12),
              ),
              'assets/images/driver.png',
            ),
            position: LatLng(doc['location']['lat'], doc['location']['long']));

        markers.add(driverMarker);
      }
    });
  }
}
