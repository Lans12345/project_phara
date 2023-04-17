import 'package:flutter_riverpod/flutter_riverpod.dart';

final latProvider = StateProvider<double>((ref) {
  return 0;
});

final longProvider = StateProvider<double>((ref) {
  return 0;
});

final addressProvider = StateProvider<String>((ref) {
  return 'Search location';
});
