import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  // ProviderScope makes the Riverpod dependency graph available to the app.
  runApp(const ProviderScope(child: RecipesApp()));
}
