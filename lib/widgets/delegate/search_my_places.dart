import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phara/services/providers/coordinates_provider.dart';
import 'package:phara/utils/colors.dart';

import '../../data/user_stream.dart';
import '../../services/place_service.dart';

class LocationsSearch extends SearchDelegate<Suggestion> {
  LocationsSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  late PlaceApiProvider apiClient;

  final box = GetStorage();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      return IconButton(
        tooltip: 'Back',
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          ref.read(destinationProvider.notifier).state = 'No address specified';
          Navigator.of(context).pop();
        },
      );
    }));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: query == ""
            ? null
            : apiClient.fetchSuggestions(
                query, Localizations.localeOf(context).languageCode),
        builder: (context, AsyncSnapshot<List> snapshot1) {
          return query == ''
              ? StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseData().userData,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Loading'));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    dynamic data = snapshot.data;

                    List favs1 = data['favorites'];
                    return ListView.builder(
                      itemBuilder: (context, index2) =>
                          Consumer(builder: ((context, ref, child) {
                        return ListTile(
                          trailing: IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                'favorites': FieldValue.arrayRemove(
                                    [data['favorites'][index2]]),
                              });
                            },
                            icon: Icon(
                              favs1.contains(data['favorites'][index2])
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: favs1.contains(data['favorites'][index2])
                                  ? Colors.amber
                                  : grey,
                            ),
                          ),
                          title: Text((data['favorites'][index2])),
                          onTap: () async {
                            List<Location> location = await locationFromAddress(
                                (data['favorites'][index2]));

                            ref.read(latProvider.notifier).state =
                                location[0].latitude;
                            ref.read(longProvider.notifier).state =
                                location[0].longitude;

                            ref.read(destinationProvider.notifier).state =
                                (data['favorites'][index2]);
                            Navigator.pop(context);
                          },
                        );
                      })),
                      itemCount: favs1.length,
                    );
                  })
              : snapshot1.hasData
                  ? StreamBuilder<DocumentSnapshot>(
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        dynamic data = snapshot.data;

                        List favs = data['favorites'];
                        return ListView.builder(
                          itemBuilder: (context, index1) =>
                              Consumer(builder: ((context, ref, child) {
                            return ListTile(
                              trailing: IconButton(
                                onPressed: () async {
                                  List<Location> location =
                                      await locationFromAddress((snapshot1
                                              .data![index1] as Suggestion)
                                          .description);
                                  if (favs.contains(
                                      (snapshot1.data![index1] as Suggestion)
                                          .description)) {
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      'favorites': FieldValue.arrayRemove([
                                        (snapshot1.data![index1] as Suggestion)
                                            .description
                                      ]),
                                    });
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      'favorites': FieldValue.arrayUnion([
                                        {
                                          'name': (snapshot1.data![index1]
                                                  as Suggestion)
                                              .description,
                                          'lat': location[0].latitude,
                                          'long': location[0].longitude
                                        }
                                      ]),
                                    });
                                  }
                                },
                                icon: Icon(
                                  favs.contains((snapshot1.data![index1]
                                              as Suggestion)
                                          .description)
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  color: favs.contains((snapshot1.data![index1]
                                              as Suggestion)
                                          .description)
                                      ? Colors.amber
                                      : grey,
                                ),
                              ),
                              title: Text(
                                  (snapshot1.data![index1] as Suggestion)
                                      .description),
                              onTap: () async {
                                List<Location> location =
                                    await locationFromAddress(
                                        (snapshot1.data![index1] as Suggestion)
                                            .description);

                                ref.read(latProvider.notifier).state =
                                    location[0].latitude;
                                ref.read(longProvider.notifier).state =
                                    location[0].longitude;

                                ref.read(destinationProvider.notifier).state =
                                    (snapshot1.data![index1] as Suggestion)
                                        .description;
                                close(context,
                                    snapshot1.data![index1] as Suggestion);
                              },
                            );
                          })),
                          itemCount: snapshot1.data!.length,
                        );
                      })
                  : const Center(child: Text('Loading...'));
        });
  }
}
