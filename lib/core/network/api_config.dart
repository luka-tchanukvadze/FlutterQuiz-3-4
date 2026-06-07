/// Static configuration for the DummyJSON recipes API.
class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = 'https://dummyjson.com';

  /// List of recipes. Supports `limit` and `skip` query parameters.
  static const String recipes = '/recipes';

  /// Single recipe by id, e.g. `/recipes/1`.
  static String recipeById(int id) => '/recipes/$id';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
