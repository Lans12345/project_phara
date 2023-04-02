import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';

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
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
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
        builder: (context, AsyncSnapshot<List> snapshot) {
          return query == ''
              ? Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text('Search for Location'),
                )
              : snapshot.hasData
                  ? ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                            (snapshot.data![index] as Suggestion).description),
                        onTap: () async {
                          List<Location> location = await locationFromAddress(
                              (snapshot.data![index] as Suggestion)
                                  .description);

                          // ref.read(latProvider.notifier).state =
                          //     location[0].latitude;
                          // ref.read(longProvider.notifier).state =
                          //     location[0].longitude;

                          // ref.read(addressProvider.notifier).state =
                          //     (snapshot.data![index] as Suggestion)
                          //         .description;
                          close(context, snapshot.data![index] as Suggestion);
                        },
                      ),
                      itemCount: snapshot.data!.length,
                    )
                  : const Center(child: Text('Loading...'));
        });
  }
}
