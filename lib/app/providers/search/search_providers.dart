import 'package:flutter_riverpod/flutter_riverpod.dart';

final isSearchProvider = StateProvider<bool> ((ref) => false);
final textSearchValueProvider = StateProvider<String> ((ref) => '');