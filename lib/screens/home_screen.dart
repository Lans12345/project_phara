import 'dart:async';

import 'package:badges/badges.dart' as b;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:phara/data/user_stream.dart';
import 'package:phara/plugins/my_location.dart';
import 'package:phara/screens/pages/trips_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/book_bottomsheet_widget.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/custom_marker.dart';
import 'package:phara/widgets/drawer_widget.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:phara/widgets/toast_widget.dart';
import 'package:uuid/uuid.dart';

import '../services/providers/coordinates_provider.dart';
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
    getUserData();
    determinePosition();
    getLocation();
    getAllDrivers();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late String currentAddress;
  late final List<MarkerData> _customMarkers = [];

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
                // FloatingActionButton(
                //     backgroundColor: Colors.white,
                //     onPressed: (() {
                //       mapController?.animateCamera(
                //           CameraUpdate.newCameraPosition(CameraPosition(
                //               bearing: 45,
                //               tilt: 40,
                //               target: LatLng(lat, long),
                //               zoom: 16)));
                //     }),
                //     child: const Icon(
                //       Icons.my_location_rounded,
                //       color: Colors.red,
                //     )),
                const SizedBox(
                  height: 15,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: (() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MessagesTab()));
                  }),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Messages')
                          .where('userId',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .where('seen', isEqualTo: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print('error');
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            )),
                          );
                        }

                        final data = snapshot.requireData;
                        return b.Badge(
                          showBadge: data.docs.isNotEmpty,
                          badgeAnimation: const b.BadgeAnimation.fade(),
                          badgeStyle: const b.BadgeStyle(
                            badgeColor: Colors.red,
                          ),
                          badgeContent: TextRegular(
                              text: data.docs.length.toString(),
                              fontSize: 12,
                              color: Colors.white),
                          child: const Icon(
                            Icons.message_outlined,
                            color: grey,
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseData().userData,
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: Text('Loading'));
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      dynamic data = snapshot.data;

                      List oldfavs = data['favorites'];

                      List favs = oldfavs.reversed.toList();
                      return FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: (() {
                            if (favs.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 100,
                                        child: Center(
                                          child: ListView.builder(
                                              itemCount: favs.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 10, 5),
                                                  child: ListTile(
                                                    title: TextRegular(
                                                        text: favs[index],
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    trailing: IconButton(
                                                      onPressed: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('Users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .update({
                                                          'favorites':
                                                              FieldValue
                                                                  .arrayRemove([
                                                            favs[index]
                                                          ]),
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      icon: const Icon(
                                                        Icons.star_rounded,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: TextRegular(
                                              text: 'Close',
                                              fontSize: 14,
                                              color: grey),
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              showToast('Your favorites are empty');
                            }
                          }),
                          child: b.Badge(
                            showBadge: favs.isNotEmpty,
                            badgeStyle: b.BadgeStyle(
                              badgeColor: Colors.amber[700]!,
                            ),
                            badgeContent: TextRegular(
                                text: favs.length.toString(),
                                fontSize: 12,
                                color: Colors.white),
                            child: const Icon(
                              Icons.star_border_rounded,
                              color: grey,
                            ),
                          ));
                    }),
                const SizedBox(
                  height: 15,
                ),
                FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: (() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const TripsPage()));
                    }),
                    child: const Icon(
                      Icons.collections_bookmark_outlined,
                      color: grey,
                    )),
                const SizedBox(
                  height: 15,
                ),
                FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: (() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                    }),
                    child: const Icon(
                      Icons.refresh,
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
              title:
                  TextRegular(text: 'PHara', fontSize: 24, color: Colors.black),
              actions: [
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseData().userData,
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: Text('Loading'));
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      dynamic data = snapshot.data;

                      List oldnotifs = data['notif'];

                      List notifs = oldnotifs.reversed.toList();
                      return PopupMenuButton(
                          icon: b.Badge(
                            showBadge: notifs.isNotEmpty,
                            badgeContent: TextRegular(
                              text: data['notif'].length.toString(),
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.notifications_rounded),
                          ),
                          itemBuilder: (context) {
                            return [
                              for (int i = 0; i < notifs.length; i++)
                                PopupMenuItem(
                                    child: ListTile(
                                  title: TextRegular(
                                      text: notifs[i]['notif'],
                                      fontSize: 14,
                                      color: Colors.black),
                                  subtitle: TextRegular(
                                      text: DateFormat.yMMMd()
                                          .add_jm()
                                          .format(notifs[i]['date'].toDate()),
                                      fontSize: 10,
                                      color: grey),
                                  leading: const Icon(
                                    Icons.notifications_active_outlined,
                                    color: grey,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        'notif':
                                            FieldValue.arrayRemove([notifs[i]]),
                                      });
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: grey,
                                    ),
                                  ),
                                )),
                            ];
                          });
                    }),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: Stack(
              children: [
                CustomGoogleMapMarkerBuilder(
                    screenshotDelay: const Duration(seconds: 5),
                    customMarkers: _customMarkers,
                    builder: (BuildContext context, Set<Marker>? markers1) {
                      if (markers1 == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return GoogleMap(
                        zoomControlsEnabled: false,
                        buildingsEnabled: true,
                        compassEnabled: true,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        markers: markers1,
                        mapType: MapType.normal,
                        initialCameraPosition: camPosition,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          setState(() {
                            mapController = controller;
                          });
                        },
                      );
                    }),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      SizedBox(
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
    _customMarkers.add(MarkerData(
        marker: Marker(
            infoWindow: const InfoWindow(
              title: 'Your Current Location',
            ),
            markerId: const MarkerId('current Location'),
            position: LatLng(lat, long)),
        child: CustomMarker(profilePicture, Colors.red)));
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
    });
    myLocationMarker(lat, long);
  }

  getAllDrivers() async {
    FirebaseFirestore.instance
        .collection('Drivers')
        .where('isActive', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        _customMarkers.add(MarkerData(
            marker: Marker(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  minRadius: 50,
                                  maxRadius: 50,
                                  backgroundImage:
                                      NetworkImage(doc['profilePicture']),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextBold(
                                        text: 'Name: ${doc['name']}',
                                        fontSize: 15,
                                        color: grey),
                                    TextRegular(
                                        text: 'Vehicle: Sniper 150',
                                        fontSize: 14,
                                        color: grey),
                                    TextRegular(
                                        text: doc['ratings'].length != 0
                                            ? 'Rating: ${(doc['stars'] / doc['ratings'].length).toStringAsFixed(2)} ★'
                                            : 'No ratings',
                                        fontSize: 14,
                                        color: Colors.amber),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: TextRegular(
                                  text: 'Close', fontSize: 12, color: grey),
                            ),
                            Consumer(builder: (context, ref, child) {
                              return ButtonWidget(
                                  opacity: 1,
                                  color: Colors.green,
                                  radius: 5,
                                  fontSize: 14,
                                  width: 100,
                                  height: 30,
                                  label: 'Book now',
                                  onPressed: () async {
                                    List<Placemark> p =
                                        await placemarkFromCoordinates(
                                            lat, long);

                                    Placemark place = p[0];

                                    final sessionToken = const Uuid().v4();

                                    // ignore: use_build_context_synchronously
                                    await showSearch(
                                        context: context,
                                        delegate:
                                            LocationsSearch(sessionToken));

                                    if (ref
                                            .read(destinationProvider.notifier)
                                            .state !=
                                        'No address specified') {
                                      // ignore: use_build_context_synchronously
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: ((context) {
                                            return BookBottomSheetWidget(
                                              driverId: doc['id'],
                                              coordinates: {
                                                'lat': lat,
                                                'long': long,
                                                'pickupLocation':
                                                    '${place.street}, ${place.locality}, ${place.administrativeArea}'
                                              },
                                            );
                                          }));
                                    }
                                  });
                            }),
                          ],
                        );
                      });
                },
                infoWindow: const InfoWindow(
                  title: 'Driver',
                ),
                markerId: MarkerId(doc['name']),
                position:
                    LatLng(doc['location']['lat'], doc['location']['long'])),
            child: CustomMarker(doc['profilePicture'], Colors.black)));
      }
    });

    setState(() {
      hasLoaded = true;
    });
  }

  String profilePicture = '';

  getUserData() {
    FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        setState(() {
          profilePicture = doc['profilePicture'];
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapController!.dispose();
  }
}
