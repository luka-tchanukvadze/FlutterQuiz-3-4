import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipes_app/app.dart';
import 'package:recipes_app/features/recipes/domain/entities/recipe.dart';
import 'package:recipes_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:recipes_app/features/recipes/presentation/providers/recipe_providers.dart';

/// In memory repository so tests never hit the network.
class _FakeRepository implements RecipeRepository {
  @override
  Future<List<Recipe>> getRecipes() async => const [];

  @override
  Future<Recipe> getRecipeById(int id) async =>
      throw UnimplementedError();
}

void main() {
  testWidgets('List screen renders its title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeRepositoryProvider.overrideWithValue(_FakeRepository()),
        ],
        child: const RecipesApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Recipes'), findsOneWidget);
  });
}
