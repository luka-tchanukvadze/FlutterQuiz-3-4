/// Pure business object for a recipe.
///
/// The presentation layer depends only on this, never on the JSON model.
class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.difficulty,
    required this.rating,
    required this.reviewCount,
    required this.caloriesPerServing,
    required this.servings,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.tags,
    required this.mealType,
    required this.ingredients,
    required this.instructions,
  });

  final int id;
  final String name;
  final String image;
  final String cuisine;
  final String difficulty;
  final double rating;
  final int reviewCount;
  final int caloriesPerServing;
  final int servings;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final List<String> tags;
  final List<String> mealType;
  final List<String> ingredients;
  final List<String> instructions;

  /// Prep plus cook time, the figure shown on the list card.
  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;
}
