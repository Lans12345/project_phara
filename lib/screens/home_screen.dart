import 'dart:async';

import 'package:badges/badges.dart' as b;
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
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late String currentAddress;

  late double lat = 0;
  late double long = 0;

  var hasLoaded = false;

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
              title: GestureDetector(
                onTap: () async {
                  final sessionToken = const Uuid().v4();

                  await showSearch(
                      context: context,
                      delegate: LocationsSearch(sessionToken));
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
                          onPressed: (() {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: ((context) {
                                  return BookBottomSheetWidget();
                                }));
                          })),
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

    Marker driverMarker = Marker(
        markerId: const MarkerId('driver1'),
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
          snippet: '09090104355',
        ),
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(12, 12),
          ),
          'assets/images/driver.png',
        ),
        position: const LatLng(8.472385879216784, 124.64719623327255));

    markers.add(mylocationMarker);
    markers.add(driverMarker);
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
}
