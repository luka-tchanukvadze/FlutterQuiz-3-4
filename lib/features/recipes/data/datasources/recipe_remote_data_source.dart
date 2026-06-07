import 'package:dio/dio.dart';

import '../../../../core/network/api_config.dart';
import '../models/recipe_model.dart';

/// Talks to the network. Returns parsed models or throws [DioException].
class RecipeRemoteDataSource {
  RecipeRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<RecipeModel>> fetchRecipes() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiConfig.recipes);
    final list = (response.data?['recipes'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    return list.map(RecipeModel.fromJson).toList();
  }

  Future<RecipeModel> fetchRecipeById(int id) async {
    final response =
        await _dio.get<Map<String, dynamic>>(ApiConfig.recipeById(id));
    return RecipeModel.fromJson(response.data ?? const {});
  }
}
