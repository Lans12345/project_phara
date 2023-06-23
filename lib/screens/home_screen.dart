import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:badges/badges.dart' as b;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phara/data/distance_calculations.dart';
import 'package:phara/data/user_stream.dart';
import 'package:phara/plugins/my_location.dart';
import 'package:phara/screens/pages/driver_profile_page.dart';
import 'package:phara/screens/pages/notif_page.dart';
import 'package:phara/screens/pages/trips_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/book_bottomsheet_widget.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/custom_marker.dart';
import 'package:phara/widgets/drawer_widget.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:phara/widgets/toast_widget.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
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
    getMyBookings();
    getUserData();
    determinePosition();
    getLocation();

    getAllDrivers();

    Timer.periodic(const Duration(minutes: 5), (timer) {
      Geolocator.getCurrentPosition().then((position) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'location': {'lat': position.latitude, 'long': position.longitude},
        });
      }).catchError((error) {
        print('Error getting location: $error');
      });
    });

    FirebaseFirestore.instance
        .collection('Bookings')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      for (var element in event.docChanges) {
        if (element.type == DocumentChangeType.modified) {
          InAppNotifications.show(
            title: 'Your Booking Response was ${element.doc['status']}',
            leading: Image.asset('assets/images/logo.png'),
            description:
                'The rider has responded to your booking!\nView your notifications for more details',
          );
        }
      }
    });

    FirebaseFirestore.instance
        .collection('Delivery')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      for (var element in event.docChanges) {
        if (element.type == DocumentChangeType.modified) {
          InAppNotifications.show(
            title: 'Your Delivery Booking was ${element.doc['status']}',
            leading: Image.asset('assets/images/logo.png'),
            description:
                'The rider has responded to your delivery booking!\nView your notifications for more details',
          );
        }
      }
    });

    FirebaseFirestore.instance
        .collection('Messages')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      for (var element in event.docChanges) {
        print(element.doc['messages'].length);

        if (element.type == DocumentChangeType.modified) {
          if (element.doc['seen'] == false &&
              element.doc['messages'][element.doc['messages'].length - 1]
                      ['sender'] !=
                  FirebaseAuth.instance.currentUser!.uid) {
            InAppNotifications.show(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MessagesTab()));
              },
              duration: const Duration(seconds: 5),
              title: '${element.doc['driverName']} has sent you a message!',
              leading: Image.network(element.doc['driverProfile']),
              description: element.doc['lastMessage'],
            );
          }
        }
      }
    });
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

  List<String> driversId = [];

  final keyOne = GlobalKey();
  final key2 = GlobalKey();
  final key3 = GlobalKey();
  final key4 = GlobalKey();
  final key5 = GlobalKey();

  getMyBookings() async {
    FirebaseFirestore.instance
        .collection('Bookings')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: 'Pending')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        driversId.add(doc['driverId']);
      }
    });
  }

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final CameraPosition camPosition = CameraPosition(
        target: LatLng(lat, long), zoom: 16, bearing: 45, tilt: 40);
    return hasLoaded && lat != 0 && long != 0
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
                          return const SizedBox();
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
                          child: AvatarGlow(
                            animate: data.docs.isNotEmpty,
                            glowColor: Colors.red,
                            endRadius: 60.0,
                            duration: const Duration(milliseconds: 2000),
                            repeatPauseDuration:
                                const Duration(milliseconds: 100),
                            repeat: true,
                            child: Icon(
                              key: key2,
                              Icons.message_outlined,
                              color: grey,
                            ),
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
                        return const SizedBox();
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox();
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
                                        width: 500,
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
                            child: Icon(
                              key: key3,
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
                    child: Icon(
                      key: key4,
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
                    child: Icon(
                      key: key5,
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
              title: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'QBold',
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('PARA',
                        textStyle: const TextStyle(
                            fontFamily: 'QBold',
                            color: Colors.black,
                            fontSize: 24)),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),
              ),
              actions: [
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseData().userData,
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      dynamic data = snapshot.data;

                      List oldnotifs = data['notif'];

                      List notifs = oldnotifs.reversed.toList();
                      return IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const NotifTab()));
                        },
                        icon: b.Badge(
                            showBadge: notifs.isNotEmpty,
                            badgeContent: TextRegular(
                              text: data['notif'].length.toString(),
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            child:
                                Icon(key: keyOne, Icons.notifications_rounded)),
                      );
                    }),
              ],
            ),
            body: Stack(
              children: [
                CustomGoogleMapMarkerBuilder(
                    screenshotDelay: const Duration(seconds: 2),
                    customMarkers: _customMarkers,
                    builder: (BuildContext context, Set<Marker>? markers1) {
                      if (markers1 == null) {
                        return const Center(
                            child: SpinKitPulse(
                          color: grey,
                        ));
                      }

                      return GoogleMap(
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        buildingsEnabled: true,
                        compassEnabled: true,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        markers: markers1,
                        mapType: MapType.normal,
                        initialCameraPosition: camPosition,
                        onMapCreated: (controller) {
                          if (box.read('shown') == false ||
                              box.read('shown') == null) {
                            _createTutorial();
                          }
                          _controller.complete(controller);

                          setState(() {
                            mapController = controller;
                          });
                        },
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 0,
                          color: Colors.white.withOpacity(0.3),
                          child: SizedBox(
                            height: 35,
                            width: 200,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.account_circle_outlined,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Drivers')
                                          .where('isActive', isEqualTo: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          print('error');
                                          return const Center(
                                              child: Text('Error'));
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox();
                                        }

                                        final data = snapshot.requireData;
                                        return TextRegular(
                                          text: data.docs.isNotEmpty
                                              ? '${data.docs.length} Riders on Duty'
                                              : 'No Riders Available',
                                          fontSize: 12,
                                          color: Colors.green,
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        : const Scaffold(
            body: Center(
              child: SpinKitPulse(
                color: grey,
              ),
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

  getAllDrivers() async {
    // _customMarkers.add(MarkerData(
    //     marker: Marker(
    //         infoWindow: const InfoWindow(
    //           title: 'Your current location',
    //         ),
    //         markerId: const MarkerId('current Location'),
    //         position: LatLng(lat, long)),
    //     child: CustomMarker(profilePicture, Colors.red)));
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
                                Column(
                                  children: [
                                    CircleAvatar(
                                      minRadius: 50,
                                      maxRadius: 50,
                                      backgroundImage:
                                          NetworkImage(doc['profilePicture']),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DriverProfilePage(
                                                      driverId: doc.id,
                                                    )));
                                      },
                                      child: TextBold(
                                        text: 'View Profile',
                                        fontSize: 12,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      child: TextBold(
                                          text: 'Name: ${doc['name']}',
                                          fontSize: 15,
                                          color: grey),
                                    ),
                                    SizedBox(
                                      width: 140,
                                      child: TextRegular(
                                          text: 'Vehicle: ${doc['vehicle']}',
                                          fontSize: 14,
                                          color: grey),
                                    ),
                                    SizedBox(
                                      width: 140,
                                      child: TextRegular(
                                          text:
                                              'Plate No.: ${doc['plateNumber']}',
                                          fontSize: 14,
                                          color: grey),
                                    ),
                                    TextRegular(
                                        text: doc['ratings'].length != 0
                                            ? 'Rating: ${(doc['stars'] / doc['ratings'].length).toStringAsFixed(2)} ★'
                                            : 'No ratings',
                                        fontSize: 14,
                                        color: Colors.amber),
                                    TextRegular(
                                        text:
                                            '${calculateDistance(lat, long, doc['location']['lat'], doc['location']['long']).toStringAsFixed(2)} kms away',
                                        fontSize: 12,
                                        color: Colors.grey),
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
                                    if (driversId.contains(doc['id'])) {
                                      Navigator.pop(context);
                                      showToast(
                                          "Youre booking for this drivers is still pending! Please wait for driver's response");
                                    } else {
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
                                              .read(
                                                  destinationProvider.notifier)
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
                                    }
                                  });
                            }),
                          ],
                        );
                      });
                },
                infoWindow: InfoWindow(
                  title: doc['name'],
                  snippet: '${doc['vehicle']}',
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

  Future<void> _createTutorial() async {
    final targets = [
      TargetFocus(
        identify: 'notif',
        keyTarget: keyOne,
        alignSkip: Alignment.topCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => SafeArea(
              child: TextRegular(
                text:
                    "Stay in the loop! Get real-time updates on your booking status through our notifications",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'messages',
        keyTarget: key2,
        alignSkip: Alignment.topCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => SafeArea(
              child: TextRegular(
                text:
                    "Stay connected with PARA! Use our messaging feature to easily communicate and exchange messages with drivers, keeping you in touch and engaged at all times.",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'favs',
        keyTarget: key3,
        alignSkip: Alignment.topCenter,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => SafeArea(
              child: TextRegular(
                text:
                    "Discover and access your favorite places with ease! PARA's Favorites feature lets you save and conveniently access your preferred locations, ensuring you can quickly navigate to the places you love with just a few taps.",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'trips',
        keyTarget: key4,
        alignSkip: Alignment.topCenter,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => SafeArea(
              child: TextRegular(
                text:
                    "Relive your past adventures with PARA's Trips or History feature! Easily access and review your previous trips, allowing you to reminisce, track your travel history, and plan future journeys based on your favorite destinations.",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'refresh',
        keyTarget: key5,
        alignSkip: Alignment.topCenter,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => SafeArea(
              child: TextRegular(
                text:
                    "Stay up-to-date with the latest available drivers! Just tap the Refresh button in PARA to instantly get the most current list of drivers, ensuring you have access to a wide selection and can quickly find a driver that suits your needs.",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ];

    final tutorial = TutorialCoachMark(
      hideSkip: true,
      targets: targets,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      tutorial.show(context: context);
    });

    box.write('shown', true);
  }
}
