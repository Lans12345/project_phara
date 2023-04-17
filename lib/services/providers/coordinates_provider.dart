import 'package:flutter_riverpod/flutter_riverpod.dart';

final latProvider = StateProvider<double>((ref) {
  return 0;
});

final longProvider = StateProvider<double>((ref) {
  return 0;
});

final destinationProvider = StateProvider<String>((ref) {
  return 'No address specified';
});
