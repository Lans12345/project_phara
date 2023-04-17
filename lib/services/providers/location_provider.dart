import 'package:riverpod/riverpod.dart';

final destinationProvider = StateProvider.autoDispose<String>((ref) {
  return 'Destination Location';
});

final pickupProvider = StateProvider.autoDispose<String>((ref) {
  return 'Your current location';
});
