import '../entities/recipe.dart';

/// Contract the presentation layer depends on.
///
/// Keeping this abstract means the data source can be swapped (for example
/// for tests or a cache) without touching the UI.
abstract interface class RecipeRepository {
  /// Fetches the list of recipes.
  Future<List<Recipe>> getRecipes();

  /// Fetches a single recipe by its id.
  Future<Recipe> getRecipeById(int id);
}
