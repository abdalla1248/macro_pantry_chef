import 'package:dio/dio.dart';
import 'package:macro_pantry_chef/features/pantry/data/models/macro_targets.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.spoonacular.com/'));
  
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      print('=== REQUEST SENT ===');
      print('ENDPOINT: ${options.path}');
      print('URL: ${options.uri}');
      print('HEADERS: ${options.headers}');
      print('QUERY PARAMETERS: ${options.queryParameters}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      print('=== API RESPONSE ===');
      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.data}');
      return handler.next(response);
    },
    onError: (DioException e, handler) {
      print('=== API ERROR ===');
      print('STATUS CODE: ${e.response?.statusCode}');
      print('RESPONSE BODY: ${e.response?.data}');
      return handler.next(e);
    },
  ));

  // Simulate exactly what NutritionRepositoryImpl does
  final targets = const MacroTargets(
    protein: 180,
    carbs: 270,
    fat: 67,
    calories: 2400,
  );
  
  // Calculate +/- 30% tolerance bounds as per current code
  final minProtein = (targets.protein * 0.7).round();
  final maxProtein = (targets.protein * 1.3).round();
  final minCarbs = (targets.carbs * 0.7).round();
  final maxCarbs = (targets.carbs * 1.3).round();
  final minFat = (targets.fat * 0.7).round();
  final maxFat = (targets.fat * 1.3).round();
  final minCalories = (targets.calories * 0.7).round();
  final maxCalories = (targets.calories * 1.3).round();

  final queryParameters = {
    'apiKey': 'YOUR_API_KEY_HERE', // Using placeholder to see request structure
    'minProtein': minProtein,
    'maxProtein': maxProtein,
    'minCarbs': minCarbs,
    'maxCarbs': maxCarbs,
    'minFat': minFat,
    'maxFat': maxFat,
    'minCalories': minCalories,
    'maxCalories': maxCalories,
    'fillIngredients': true,
    'addRecipeInformation': true,
    'addRecipeNutrition': true,
    'number': 10,
    'includeIngredients': 'Chicken,Rice',
  };

  try {
    await dio.get('recipes/complexSearch', queryParameters: queryParameters);
  } catch (e) {
    // Error caught by interceptor
  }
}
