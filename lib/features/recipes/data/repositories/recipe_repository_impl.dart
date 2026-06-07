import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_data_source.dart';

/// Implements the domain contract and maps network errors to [AppException].
class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this._remote);

  final RecipeRemoteDataSource _remote;

  @override
  Future<List<Recipe>> getRecipes() async {
    try {
      return await _remote.fetchRecipes();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }

  @override
  Future<Recipe> getRecipeById(int id) async {
    try {
      return await _remote.fetchRecipeById(id);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }
}
