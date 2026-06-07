import '../../domain/entities/recipe.dart';

/// JSON aware version of [Recipe]. Lives in the data layer only.
class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.image,
    required super.cuisine,
    required super.difficulty,
    required super.rating,
    required super.reviewCount,
    required super.caloriesPerServing,
    required super.servings,
    required super.prepTimeMinutes,
    required super.cookTimeMinutes,
    required super.tags,
    required super.mealType,
    required super.ingredients,
    required super.instructions,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: _asInt(json['id']),
      name: json['name'] as String? ?? 'Untitled recipe',
      image: json['image'] as String? ?? '',
      cuisine: json['cuisine'] as String? ?? 'Unknown',
      difficulty: json['difficulty'] as String? ?? 'Unknown',
      rating: _asDouble(json['rating']),
      reviewCount: _asInt(json['reviewCount']),
      caloriesPerServing: _asInt(json['caloriesPerServing']),
      servings: _asInt(json['servings']),
      prepTimeMinutes: _asInt(json['prepTimeMinutes']),
      cookTimeMinutes: _asInt(json['cookTimeMinutes']),
      tags: _asStringList(json['tags']),
      mealType: _asStringList(json['mealType']),
      ingredients: _asStringList(json['ingredients']),
      instructions: _asStringList(json['instructions']),
    );
  }

  static int _asInt(Object? value) =>
      value is int ? value : int.tryParse('$value') ?? 0;

  static double _asDouble(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

  static List<String> _asStringList(Object? value) =>
      value is List ? value.map((e) => '$e').toList() : const [];
}
