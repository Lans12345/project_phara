import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:phara/plugins/my_location.dart';
import 'package:phara/screens/map_screen.dart';
import 'package:phara/screens/pages/delivery/delivery_page.dart';
import 'package:phara/screens/pages/driver_profile_page.dart';
import 'package:phara/screens/pages/messages_tab.dart';
import 'package:phara/screens/pages/trips_page.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/button_widget.dart';

import '../data/distance_calculations.dart';
import '../data/user_stream.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/text_widget.dart';
import 'pages/notif_page.dart';
import 'package:badges/badges.dart' as b;

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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      mainHome(),
      const MessagesTab(),
      const NotifTab(),
      const MapScreen(),
      const TripsPage(),
    ];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: const Drawer(
        child: DrawerWidget(),
      ),
      appBar: _currentIndex == 0
          ? AppBar(
              centerTitle: true,
              foregroundColor: grey,
              backgroundColor: Colors.white,
              title: TextRegular(
                text: 'HOME',
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
            )
          : null,
      body: hasLoaded
          ? children[_currentIndex]
          : const Center(
              child: SpinKitPulse(
                color: grey,
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontFamily: 'QBold', fontSize: 10),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'QBold', fontSize: 10),
        selectedItemColor: grey,
        unselectedItemColor: Colors.grey[400],
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email_outlined),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_location),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark_outlined),
            label: 'History',
          ),
        ],
      ),
    );
  }

  late double lat = 0;

  late double long = 0;

  bool hasLoaded = false;

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      long = position.longitude;
      hasLoaded = true;
    });
  }

  List imageLinks = [
    'illu.png',
    'illu1.png',
    'illu2.png',
  ];

  Widget mainHome() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: CarouselSlider.builder(
                unlimitedMode: true,
                slideBuilder: (index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      height: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/${imageLinks[index]}'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
                enableAutoSlider: true,
                scrollPhysics: const BouncingScrollPhysics(),
                slideIndicator: CircularSlideIndicator(
                  indicatorRadius: 3,
                  currentIndicatorColor: Colors.black,
                  indicatorBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.only(bottom: 32),
                ),
                itemCount: 3),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: TextBold(
              text: 'Our Services',
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 125,
                width: 175,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextBold(
                          text: 'Book a\nRide',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ButtonWidget(
                          color: Colors.white,
                          textcolor: Colors.black,
                          radius: 100,
                          opacity: 1,
                          fontSize: 10,
                          width: 60,
                          height: 25,
                          label: 'Ride now',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MapScreen()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 125,
                width: 175,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextBold(
                          text: 'Book a\nDelivery',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ButtonWidget(
                          radius: 100,
                          opacity: 1,
                          fontSize: 10,
                          color: Colors.white,
                          textcolor: Colors.black,
                          width: 60,
                          height: 25,
                          label: 'Book now',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const DeliveryPage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 125,
                width: 175,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextBold(
                          text: 'Pabili',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ButtonWidget(
                          radius: 100,
                          opacity: 1,
                          fontSize: 10,
                          color: Colors.white,
                          textcolor: Colors.black,
                          width: 60,
                          height: 25,
                          label: 'Coming soon',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 125,
                width: 175,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextBold(
                          text: 'Food\nDelivery',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ButtonWidget(
                          radius: 100,
                          opacity: 1,
                          fontSize: 10,
                          color: Colors.white,
                          textcolor: Colors.black,
                          width: 60,
                          height: 25,
                          label: 'Coming soon',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextBold(
              text: 'Riders Nearby',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Center(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Drivers')
                    .where('isActive', isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                    );
                  }

                  final data = snapshot.requireData;
                  final sortedData =
                      List<QueryDocumentSnapshot>.from(data.docs);

                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    sortedData.sort((a, b) {
                      final double lat1 = a['location']['lat'];
                      final double long1 = a['location']['long'];
                      final double lat2 = b['location']['lat'];
                      final double long2 = b['location']['long'];

                      final double distance1 =
                          calculateDistance(lat, long, lat1, long1);
                      final double distance2 =
                          calculateDistance(lat, long, lat2, long2);

                      return distance1.compareTo(distance2);
                    });
                  });
                  for (int i = 0; i < sortedData.length; i++) {
                    print(sortedData[i]['name']);
                  }

                  return SizedBox(
                    height: 140,
                    child: ListView.builder(
                        itemCount: sortedData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              minRadius: 25,
                                              maxRadius: 25,
                                              backgroundImage: NetworkImage(
                                                  data.docs[index]
                                                      ['profilePicture']),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DriverProfilePage(
                                                              driverId: data
                                                                  .docs[index]
                                                                  .id,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              child: TextBold(
                                                  text:
                                                      'Name: ${data.docs[index]['name']}',
                                                  fontSize: 12,
                                                  color: grey),
                                            ),
                                            SizedBox(
                                              width: 120,
                                              child: TextRegular(
                                                  text:
                                                      'Vehicle: ${data.docs[index]['vehicle']}',
                                                  fontSize: 11,
                                                  color: grey),
                                            ),
                                            SizedBox(
                                              width: 120,
                                              child: TextRegular(
                                                  text:
                                                      'Plate No.: ${data.docs[index]['plateNumber']}',
                                                  fontSize: 11,
                                                  color: grey),
                                            ),
                                            TextRegular(
                                                text: data
                                                            .docs[index]
                                                                ['ratings']
                                                            .length !=
                                                        0
                                                    ? 'Rating: ${(data.docs[index]['stars'] / data.docs[index]['ratings'].length).toStringAsFixed(2)} ★'
                                                    : 'No ratings',
                                                fontSize: 11,
                                                color: Colors.amber),
                                            TextRegular(
                                                text:
                                                    '${calculateDistance(lat, long, data.docs[index]['location']['lat'], data.docs[index]['location']['long']).toStringAsFixed(2)} kms away',
                                                fontSize: 11,
                                                color: Colors.grey),
                                          ],
                                        ),
                                      ],
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
  }
}
