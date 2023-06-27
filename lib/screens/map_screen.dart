import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:badges/badges.dart' as b;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart' as location;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phara/data/user_stream.dart';
import 'package:phara/plugins/my_location.dart';
import 'package:phara/screens/pages/driver_profile_page.dart';
import 'package:phara/screens/pages/notif_page.dart';
import 'package:phara/screens/pages/trips_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/drawer_widget.dart';
import 'package:phara/widgets/text_widget.dart';

import '../data/distance_calculations.dart';
import '../utils/keys.dart';
import '../widgets/book_bottomsheet_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/toast_widget.dart';
import 'pages/messages_tab.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    getMyBookings();
    getUserData();
    determinePosition();
    getLocation();

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

  late LatLng dropOff;

  addMyMarker1(lat1, long1) async {
    markers.add(Marker(
        draggable: true,
        onDragEnd: (value) {
          setState(() {
            lat = value.latitude;
            long = value.longitude;
          });
        },
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("pickup"),
        position: LatLng(lat1, long1),
        infoWindow: const InfoWindow(title: 'Pick-up Location')));
  }

  addMyMarker12(lat1, long1) async {
    markers.add(Marker(
        draggable: true,
        onDragEnd: (value) {
          setState(() {
            dropOff = value;
          });
        },
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("dropOff"),
        position: LatLng(lat1, long1),
        infoWindow: const InfoWindow(title: 'Drop-off Location')));
  }

  late Polyline _poly = const Polyline(polylineId: PolylineId('new'));

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late String pickup = 'My Location';
  late String drop = 'Search Drop-off Location';

  final receiverController = TextEditingController();
  final receiverNumberController = TextEditingController();
  final itemController = TextEditingController();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late String currentAddress;

  late double lat = 0;
  late double long = 0;

  var hasLoaded = false;

  GoogleMapController? mapController;

  Set<Marker> markers = {};

  List<String> driversId = [];

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

  Color dialColor = Colors.black;
  String nearestDriverId = '';

  @override
  Widget build(BuildContext context) {
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
    final CameraPosition camPosition = CameraPosition(
        target: LatLng(lat, long), zoom: 16, bearing: 45, tilt: 40);
    return hasLoaded && lat != 0 && long != 0
        ? Scaffold(
            drawer: const Drawer(
              child: DrawerWidget(),
            ),
            appBar: AppBar(
              centerTitle: true,
              foregroundColor: grey,
              backgroundColor: Colors.white,
              title: TextRegular(
                text: 'Map',
                fontSize: 24,
                color: grey,
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
                            child: const Icon(Icons.notifications_rounded)),
                      );
                    }),
              ],
            ),
            body: Stack(
              children: [
                GoogleMap(
                  onCameraMove: (position) {},
                  polylines: {_poly},
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  buildingsEnabled: true,
                  compassEnabled: true,
                  markers: markers,
                  mapType: MapType.normal,
                  initialCameraPosition: camPosition,
                  onMapCreated: (controller) {
                    _controller.complete(controller);

                    setState(() {
                      mapController = controller;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.5, right: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: dialWidget(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height:
                                drop != 'Search Drop-off Location' ? 210 : 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextBold(
                                        text: pickup == 'My Location' ||
                                                drop ==
                                                    'Search Drop-off Location'
                                            ? 'Search locations'
                                            : 'Distance: ${calculateDistance(lat, long, dropOff.latitude, dropOff.longitude).toStringAsFixed(2)} km away',
                                        fontSize: 18,
                                        color: grey),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        location.Prediction? p =
                                            await PlacesAutocomplete.show(
                                                mode: Mode.overlay,
                                                context: context,
                                                apiKey: kGoogleApiKey,
                                                language: 'en',
                                                strictbounds: false,
                                                types: [""],
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Search Pick-up Location',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white))),
                                                components: [
                                                  location.Component(
                                                      location
                                                          .Component.country,
                                                      "ph")
                                                ]);

                                        location.GoogleMapsPlaces places =
                                            location.GoogleMapsPlaces(
                                                apiKey: kGoogleApiKey,
                                                apiHeaders:
                                                    await const GoogleApiHeaders()
                                                        .getHeaders());

                                        location.PlacesDetailsResponse detail =
                                            await places.getDetailsByPlaceId(
                                                p!.placeId!);

                                        addMyMarker1(
                                            detail
                                                .result.geometry!.location.lat,
                                            detail
                                                .result.geometry!.location.lng);

                                        mapController!.animateCamera(
                                            CameraUpdate.newLatLngZoom(
                                                LatLng(
                                                    detail.result.geometry!
                                                        .location.lat,
                                                    detail.result.geometry!
                                                        .location.lng),
                                                18.0));

                                        setState(() {
                                          pickup = detail.result.name;
                                          // pickUp = LatLng(
                                          //     detail.result.geometry!.location
                                          //         .lat,
                                          //     detail.result.geometry!.location
                                          //         .lng);
                                          lat = detail
                                              .result.geometry!.location.lat;
                                          long = detail
                                              .result.geometry!.location.lng;
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: TextFormField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.looks_one_outlined,
                                              color: grey,
                                            ),
                                            suffixIcon: const Icon(
                                              Icons.my_location_outlined,
                                              color: Colors.red,
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1, color: grey),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1, color: grey),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            label: TextRegular(
                                                text: pickup,
                                                fontSize: 14,
                                                color: Colors.black),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _poly = const Polyline(
                                              polylineId: PolylineId('new'));
                                        });
                                        location.Prediction? p =
                                            await PlacesAutocomplete.show(
                                                mode: Mode.overlay,
                                                context: context,
                                                apiKey: kGoogleApiKey,
                                                language: 'en',
                                                strictbounds: false,
                                                types: [""],
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Search Drop-off Location',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white))),
                                                components: [
                                                  location.Component(
                                                      location
                                                          .Component.country,
                                                      "ph")
                                                ]);

                                        location.GoogleMapsPlaces places =
                                            location.GoogleMapsPlaces(
                                                apiKey: kGoogleApiKey,
                                                apiHeaders:
                                                    await const GoogleApiHeaders()
                                                        .getHeaders());

                                        location.PlacesDetailsResponse detail =
                                            await places.getDetailsByPlaceId(
                                                p!.placeId!);

                                        addMyMarker12(
                                            detail
                                                .result.geometry!.location.lat,
                                            detail
                                                .result.geometry!.location.lng);

                                        setState(() {
                                          drop = detail.result.name;

                                          dropOff = LatLng(
                                              detail.result.geometry!.location
                                                  .lat,
                                              detail.result.geometry!.location
                                                  .lng);
                                        });

                                        PolylineResult result =
                                            await polylinePoints
                                                .getRouteBetweenCoordinates(
                                                    kGoogleApiKey,
                                                    PointLatLng(lat, long),
                                                    PointLatLng(
                                                        detail.result.geometry!
                                                            .location.lat,
                                                        detail.result.geometry!
                                                            .location.lng));
                                        if (result.points.isNotEmpty) {
                                          polylineCoordinates = result.points
                                              .map((point) => LatLng(
                                                  point.latitude,
                                                  point.longitude))
                                              .toList();
                                        }
                                        setState(() {
                                          _poly = Polyline(
                                              color: Colors.red,
                                              polylineId:
                                                  const PolylineId('route'),
                                              points: polylineCoordinates,
                                              width: 4);
                                        });

                                        mapController!.animateCamera(
                                            CameraUpdate.newLatLngZoom(
                                                LatLng(
                                                    detail.result.geometry!
                                                        .location.lat,
                                                    detail.result.geometry!
                                                        .location.lng),
                                                18.0));

                                        double miny = (lat <= dropOff.latitude)
                                            ? lat
                                            : dropOff.latitude;
                                        double minx =
                                            (long <= dropOff.longitude)
                                                ? long
                                                : dropOff.longitude;
                                        double maxy = (lat <= dropOff.latitude)
                                            ? dropOff.latitude
                                            : lat;
                                        double maxx =
                                            (long <= dropOff.longitude)
                                                ? dropOff.longitude
                                                : long;

                                        double southWestLatitude = miny;
                                        double southWestLongitude = minx;

                                        double northEastLatitude = maxy;
                                        double northEastLongitude = maxx;

                                        // Accommodate the two locations within the
                                        // camera view of the map
                                        mapController!.animateCamera(
                                          CameraUpdate.newLatLngBounds(
                                            LatLngBounds(
                                              northeast: LatLng(
                                                northEastLatitude,
                                                northEastLongitude,
                                              ),
                                              southwest: LatLng(
                                                southWestLatitude,
                                                southWestLongitude,
                                              ),
                                            ),
                                            100.0,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: TextFormField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.looks_two_outlined,
                                              color: grey,
                                            ),
                                            suffixIcon: Icon(
                                              Icons.sports_score_outlined,
                                              color: drop ==
                                                      'Search Drop-off Location'
                                                  ? grey
                                                  : Colors.red,
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1, color: grey),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1, color: grey),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            label: TextRegular(
                                                text: drop,
                                                fontSize: 14,
                                                color: Colors.black),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    drop != 'Search Drop-off Location'
                                        ? ButtonWidget(
                                            width: 250,
                                            fontSize: 15,
                                            color: Colors.green,
                                            height: 40,
                                            radius: 100,
                                            opacity: 1,
                                            label: 'Book Now',
                                            onPressed: () async {
                                              List<Placemark> p =
                                                  await placemarkFromCoordinates(
                                                      lat, long);

                                              Placemark place = p[0];

                                              // ignore: use_build_context_synchronously

                                              // ignore: use_build_context_synchronously

                                              showModalBottomSheet(
                                                  //     isScrollControlled: true,
                                                  //     context: context,
                                                  context: context,
                                                  builder: (context) {
                                                    return SizedBox(
                                                      height: 275,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: TextButton
                                                                  .icon(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          ((context) {
                                                                        return BookBottomSheetWidget(
                                                                          locationData: {
                                                                            'pickuplat':
                                                                                lat,
                                                                            'pickuplong':
                                                                                long,
                                                                            'pickup':
                                                                                pickup,
                                                                            'destinationlat':
                                                                                dropOff.latitude,
                                                                            'destinationlong':
                                                                                dropOff.longitude,
                                                                            'dropoff':
                                                                                drop
                                                                          },
                                                                          driverId:
                                                                              nearestDriverId,
                                                                          coordinates: {
                                                                            'lat':
                                                                                lat,
                                                                            'long':
                                                                                long,
                                                                            'pickupLocation':
                                                                                '${place.street}, ${place.locality}, ${place.administrativeArea}'
                                                                          },
                                                                        );
                                                                      }));
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .my_location,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                label:
                                                                    TextRegular(
                                                                  text:
                                                                      'Select nearest',
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: StreamBuilder<
                                                                    QuerySnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Drivers')
                                                                    .where(
                                                                        'isActive',
                                                                        isEqualTo:
                                                                            true)
                                                                    .snapshots(),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            QuerySnapshot>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                      .hasError) {
                                                                    print(snapshot
                                                                        .error);
                                                                    return const Center(
                                                                        child: Text(
                                                                            'Error'));
                                                                  }
                                                                  if (snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return const Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 50),
                                                                      child: Center(
                                                                          child: CircularProgressIndicator(
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                    );
                                                                  }

                                                                  final data =
                                                                      snapshot
                                                                          .requireData;
                                                                  final sortedData =
                                                                      List<QueryDocumentSnapshot>.from(
                                                                          data.docs);

                                                                  WidgetsBinding
                                                                      .instance
                                                                      .addPostFrameCallback(
                                                                          (timeStamp) {
                                                                    sortedData
                                                                        .sort((a,
                                                                            b) {
                                                                      nearestDriverId = data
                                                                          .docs[
                                                                              0]
                                                                          .id;
                                                                      final double
                                                                          lat1 =
                                                                          a['location']
                                                                              [
                                                                              'lat'];
                                                                      final double
                                                                          long1 =
                                                                          a['location']
                                                                              [
                                                                              'long'];
                                                                      final double
                                                                          lat2 =
                                                                          b['location']
                                                                              [
                                                                              'lat'];
                                                                      final double
                                                                          long2 =
                                                                          b['location']
                                                                              [
                                                                              'long'];

                                                                      final double
                                                                          distance1 =
                                                                          calculateDistance(
                                                                              lat,
                                                                              long,
                                                                              lat1,
                                                                              long1);
                                                                      final double
                                                                          distance2 =
                                                                          calculateDistance(
                                                                              lat,
                                                                              long,
                                                                              lat2,
                                                                              long2);

                                                                      return distance1
                                                                          .compareTo(
                                                                              distance2);
                                                                    });
                                                                  });

                                                                  return SizedBox(
                                                                    height: 220,
                                                                    child: ListView.builder(
                                                                        itemCount: sortedData.length,
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemBuilder: (context, index) {
                                                                          return Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                10,
                                                                                20,
                                                                                10,
                                                                                20),
                                                                            child:
                                                                                Card(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Column(
                                                                                          children: [
                                                                                            CircleAvatar(
                                                                                              minRadius: 25,
                                                                                              maxRadius: 25,
                                                                                              backgroundImage: NetworkImage(data.docs[index]['profilePicture']),
                                                                                            ),
                                                                                            TextButton(
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).push(MaterialPageRoute(
                                                                                                    builder: (context) => DriverProfilePage(
                                                                                                          driverId: data.docs[index].id,
                                                                                                        )));
                                                                                              },
                                                                                              child: TextBold(
                                                                                                text: 'Reviews',
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
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: 120,
                                                                                              child: TextBold(text: 'Name: ${data.docs[index]['name']}', fontSize: 12, color: grey),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 120,
                                                                                              child: TextRegular(text: 'Vehicle: ${data.docs[index]['vehicle']}', fontSize: 11, color: grey),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 120,
                                                                                              child: TextRegular(text: 'Plate No.: ${data.docs[index]['plateNumber']}', fontSize: 11, color: grey),
                                                                                            ),
                                                                                            TextRegular(text: data.docs[index]['ratings'].length != 0 ? 'Rating: ${(data.docs[index]['stars'] / data.docs[index]['ratings'].length).toStringAsFixed(2)} ★' : 'No ratings', fontSize: 11, color: Colors.amber),
                                                                                            TextRegular(text: '${calculateDistance(lat, long, data.docs[index]['location']['lat'], data.docs[index]['location']['long']).toStringAsFixed(2)} kms away', fontSize: 11, color: Colors.grey),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    ButtonWidget(
                                                                                      width: 125,
                                                                                      height: 30,
                                                                                      fontSize: 11,
                                                                                      label: 'Select Driver',
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                        showModalBottomSheet(
                                                                                            isScrollControlled: true,
                                                                                            context: context,
                                                                                            builder: ((context) {
                                                                                              return BookBottomSheetWidget(
                                                                                                locationData: {
                                                                                                  'pickuplat': lat,
                                                                                                  'pickuplong': long,
                                                                                                  'pickup': pickup,
                                                                                                  'destinationlat': dropOff.latitude,
                                                                                                  'destinationlong': dropOff.longitude,
                                                                                                  'dropoff': drop
                                                                                                },
                                                                                                driverId: data.docs[index].id,
                                                                                                coordinates: {
                                                                                                  'lat': lat,
                                                                                                  'long': long,
                                                                                                  'pickupLocation': '${place.street}, ${place.locality}, ${place.administrativeArea}'
                                                                                                },
                                                                                              );
                                                                                            }));
                                                                                      },
                                                                                      opacity: 1,
                                                                                      radius: 100,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                  );
                                                                }),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
      hasLoaded = true;
    });

    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("mylocation"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'My Location')));
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

  // Future<void> _createTutorial() async {
  //   final targets = [
  //     TargetFocus(
  //       identify: 'notif',
  //       keyTarget: keyOne,
  //       alignSkip: Alignment.topCenter,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.bottom,
  //           builder: (context, controller) => SafeArea(
  //             child: TextRegular(
  //               text:
  //                   "Stay in the loop! Get real-time updates on your booking status through our notifications",
  //               fontSize: 18,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     TargetFocus(
  //       identify: 'messages',
  //       keyTarget: key2,
  //       alignSkip: Alignment.topCenter,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.bottom,
  //           builder: (context, controller) => SafeArea(
  //             child: TextRegular(
  //               text:
  //                   "Stay connected with PARA! Use our messaging feature to easily communicate and exchange messages with drivers, keeping you in touch and engaged at all times.",
  //               fontSize: 18,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     TargetFocus(
  //       identify: 'favs',
  //       keyTarget: key3,
  //       alignSkip: Alignment.topCenter,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.top,
  //           builder: (context, controller) => SafeArea(
  //             child: TextRegular(
  //               text:
  //                   "Discover and access your favorite places with ease! PARA's Favorites feature lets you save and conveniently access your preferred locations, ensuring you can quickly navigate to the places you love with just a few taps.",
  //               fontSize: 18,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     TargetFocus(
  //       identify: 'trips',
  //       keyTarget: key4,
  //       alignSkip: Alignment.topCenter,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.top,
  //           builder: (context, controller) => SafeArea(
  //             child: TextRegular(
  //               text:
  //                   "Relive your past adventures with PARA's Trips or History feature! Easily access and review your previous trips, allowing you to reminisce, track your travel history, and plan future journeys based on your favorite destinations.",
  //               fontSize: 18,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     TargetFocus(
  //       identify: 'refresh',
  //       keyTarget: key5,
  //       alignSkip: Alignment.topCenter,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.top,
  //           builder: (context, controller) => SafeArea(
  //             child: TextRegular(
  //               text:
  //                   "Stay up-to-date with the latest available drivers! Just tap the Refresh button in PARA to instantly get the most current list of drivers, ensuring you have access to a wide selection and can quickly find a driver that suits your needs.",
  //               fontSize: 18,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   ];

  //   final tutorial = TutorialCoachMark(
  //     hideSkip: true,
  //     targets: targets,
  //   );

  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     tutorial.show(context: context);
  //   });

  //   box.write('shown', true);
  // }

  Widget dialWidget() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: SpeedDial(
        elevation: 0,
        buttonSize: const Size(35, 35),
        direction: SpeedDialDirection.down,
        onOpen: () {
          setState(() {
            dialColor = Colors.red;
          });
        },
        backgroundColor: Colors.white,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(color: dialColor),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        closeManually: false,
        children: [
          SpeedDialChild(
              onTap: () {
                mapController?.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        bearing: 45,
                        tilt: 40,
                        target: LatLng(lat, long),
                        zoom: 16)));
              },
              label: 'My Location',
              labelStyle: const TextStyle(
                  fontFamily: 'QBold', fontSize: 12, color: Colors.red),
              child: const Icon(
                Icons.my_location_rounded,
                color: Colors.red,
              )),
          SpeedDialChild(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MessagesTab()));
            },
            label: 'Messages',
            labelStyle: const TextStyle(
                fontFamily: 'QBold', fontSize: 12, color: Colors.black),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      repeat: true,
                      child: const Icon(
                        Icons.message_outlined,
                        color: grey,
                      ),
                    ),
                  );
                }),
          ),
          SpeedDialChild(
            label: 'Favorites',
            labelStyle: const TextStyle(
                fontFamily: 'QBold', fontSize: 12, color: Colors.black),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseData().userData,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
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
                                                      'favorites': FieldValue
                                                          .arrayRemove(
                                                              [favs[index]]),
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
          ),
          SpeedDialChild(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MapScreen()));
              },
              label: 'Refresh',
              labelStyle: const TextStyle(
                  fontFamily: 'QBold', fontSize: 12, color: Colors.black),
              child: const Icon(
                Icons.refresh,
                color: grey,
              )),
          SpeedDialChild(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TripsPage()));
              },
              label: 'History',
              labelStyle: const TextStyle(
                  fontFamily: 'QBold', fontSize: 12, color: Colors.black),
              child: const Icon(
                Icons.collections_bookmark_outlined,
                color: grey,
              )),
        ],
      ),
    );
  }
}
