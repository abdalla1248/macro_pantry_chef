import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.spoonacular.com/',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
  );

  final String apiKey = String.fromEnvironment(
    'SPOONACULAR_API_KEY',
    defaultValue: 'PLACEHOLDER_API_KEY', // I'll also try a query directly. Wait, the app uses whatever is in AppConfig.
  );

  print('API Key being used: \$apiKey');

  try {
    final response = await dio.get(
      'recipes/complexSearch',
      queryParameters: {
        'apiKey': apiKey,
        'minProtein': 100,
        'maxProtein': 200,
        'fillIngredients': true,
        'addRecipeInformation': true,
        'addRecipeNutrition': true,
        'number': 1,
      },
    );
    print('Status code: \${response.statusCode}');
    print('Data: \${response.data}');
  } on DioException catch (e) {
    print('Dio Error: \${e.message}');
    if (e.response != null) {
      print('Response Status: \${e.response?.statusCode}');
      print('Response Data: \${e.response?.data}');
    }
  }
}
