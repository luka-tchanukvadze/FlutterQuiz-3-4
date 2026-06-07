import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/recipe_remote_data_source.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';

/// Dependency graph, wired top to bottom with Riverpod.
final dioProvider = Provider<Dio>((ref) => DioClient.create());

final recipeRemoteDataSourceProvider = Provider<RecipeRemoteDataSource>(
  (ref) => RecipeRemoteDataSource(ref.watch(dioProvider)),
);

final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => RecipeRepositoryImpl(ref.watch(recipeRemoteDataSourceProvider)),
);

/// The recipe list shown on the first screen.
final recipesListProvider = FutureProvider<List<Recipe>>(
  (ref) => ref.watch(recipeRepositoryProvider).getRecipes(),
);

/// A single recipe by id, used by the detail screen.
final recipeDetailProvider = FutureProvider.family<Recipe, int>(
  (ref, id) => ref.watch(recipeRepositoryProvider).getRecipeById(id),
);
