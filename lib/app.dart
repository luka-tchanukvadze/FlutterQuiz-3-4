import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/recipes/presentation/screens/recipes_list_screen.dart';

/// Root widget. Holds the theme and the first route.
class RecipesApp extends StatelessWidget {
  const RecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const RecipesListScreen(),
    );
  }
}
