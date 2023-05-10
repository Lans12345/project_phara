import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phara/data/distance_calculations.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/appbar_widget.dart';
import 'package:phara/widgets/button_widget.dart';
import 'package:phara/widgets/drawer_widget.dart';
import 'package:phara/widgets/text_widget.dart';
import 'package:google_maps_webservice/places.dart' as location;
import 'package:google_api_headers/google_api_headers.dart';
import '../../../utils/keys.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => DeliveryPageState();
}

class DeliveryPageState extends State<DeliveryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Geolocator.getCurrentPosition().then((value) {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
        addMyMarker(lat, long);
      });
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  double lat = 0;
  double long = 0;
  bool hasLoaded = false;

  Set<Marker> markers = {};

  addMyMarker(lat1, long1) async {
    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("currentLocation"),
        position: LatLng(lat1, long1),
        infoWindow: const InfoWindow(title: 'Your Current Location')));
    setState(() {
      hasLoaded = true;
    });
  }

  GoogleMapController? mapController;

  late LatLng pickUp;
  late LatLng dropOff;

  addMyMarker1(lat1, long1) async {
    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("pickup"),
        position: LatLng(lat1, long1),
        infoWindow:
            InfoWindow(title: 'Pick-up Location', snippet: 'PU: $pickup')));
  }

  addMyMarker12(lat1, long1) async {
    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("dropOff"),
        position: LatLng(lat1, long1),
        infoWindow:
            InfoWindow(title: 'Drop-off Location', snippet: 'DO: $drop')));
  }

  late Polyline _poly = const Polyline(polylineId: PolylineId('new'));

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late String pickup = 'Search Pick-up Location';
  late String drop = 'Search Drop-off Location';

  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 18,
    );
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('Delivery'),
      body: hasLoaded
          ? Stack(
              children: [
                GoogleMap(
                  polylines: {_poly},
                  markers: markers,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  buildingsEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    _controller.complete(controller);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: DraggableScrollableSheet(
                      initialChildSize: 0.34,
                      minChildSize: 0.15,
                      maxChildSize: 0.34,
                      builder: (context, scrollController) {
                        return Card(
                          elevation: 3,
                          child: Container(
                            width: double.infinity,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextBold(
                                        text: pickup ==
                                                    'Search Pick-up Location' ||
                                                drop ==
                                                    'Search Drop-off Location'
                                            ? 'Search locations'
                                            : 'Distance: ${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude).toStringAsFixed(2)} km away',
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
                                          pickUp = LatLng(
                                              detail.result.geometry!.location
                                                  .lat,
                                              detail.result.geometry!.location
                                                  .lng);
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
                                            suffixIcon: Icon(
                                              Icons.my_location_outlined,
                                              color: pickup ==
                                                      'Search Pick-up Location'
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
                                                text: 'PU: $pickup',
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
                                                    PointLatLng(pickUp.latitude,
                                                        pickUp.longitude),
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

                                        double miny = (pickUp.latitude <=
                                                dropOff.latitude)
                                            ? pickUp.latitude
                                            : dropOff.latitude;
                                        double minx = (pickUp.longitude <=
                                                dropOff.longitude)
                                            ? pickUp.longitude
                                            : dropOff.longitude;
                                        double maxy = (pickUp.latitude <=
                                                dropOff.latitude)
                                            ? dropOff.latitude
                                            : pickUp.latitude;
                                        double maxx = (pickUp.longitude <=
                                                dropOff.longitude)
                                            ? dropOff.longitude
                                            : pickUp.longitude;

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
                                                text: 'DO: $drop',
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
                                    pickup != 'Search Pick-up Location' &&
                                            drop != 'Search Drop-off Location'
                                        ? ButtonWidget(
                                            width: 250,
                                            fontSize: 15,
                                            color: Colors.green,
                                            height: 40,
                                            radius: 100,
                                            opacity: 1,
                                            label: 'Book Delivery',
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: TextBold(
                                                          text: 'Choose driver',
                                                          fontSize: 18,
                                                          color: Colors.black),
                                                      content: SizedBox(
                                                        height: 250,
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
                                                            builder: (context,
                                                                snapshot) {
                                                              final data = snapshot
                                                                  .requireData;
                                                              return ListView
                                                                  .separated(
                                                                      itemCount: data
                                                                          .docs
                                                                          .length,
                                                                      separatorBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return const Divider();
                                                                      },
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return ListTile(
                                                                          leading:
                                                                              CircleAvatar(
                                                                            backgroundImage:
                                                                                NetworkImage(data.docs[index]['profilePicture']),
                                                                            minRadius:
                                                                                17.5,
                                                                            maxRadius:
                                                                                17.5,
                                                                          ),
                                                                          title: TextBold(
                                                                              text: data.docs[index]['name'],
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                          trailing: TextRegular(
                                                                              text: '${calculateDistance(lat, long, data.docs[index]['location']['lat'], data.docs[index]['location']['long']).toStringAsFixed(2)} km away',
                                                                              fontSize: 12,
                                                                              color: Colors.black),
                                                                          subtitle: TextRegular(
                                                                              text: data.docs[index]['vehicle'],
                                                                              fontSize: 12,
                                                                              color: Colors.grey),
                                                                        );
                                                                      });
                                                            }),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: TextRegular(
                                                              text: 'Close',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
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
                        );
                      }),
                ),
              ],
            )
          : const Center(
              child: SpinKitPulse(
                color: grey,
              ),
            ),
    );
  }

  @override
  void dispose() {
    mapController!.dispose();
    super.dispose();
  }
}


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