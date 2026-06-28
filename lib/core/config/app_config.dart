/// Core application configuration.
abstract final class AppConfig {
  /// Base URL for the Spoonacular API.
  static const String spoonacularBaseUrl = 'https://api.spoonacular.com/';

  /// Spoonacular API key read from build-time environment variables.
  ///
  /// Provide this via `--dart-define=SPOONACULAR_API_KEY=your_key` during run/build.
  static const String spoonacularApiKey = String.fromEnvironment(
    'SPOONACULAR_API_KEY',
    defaultValue: 'PLACEHOLDER_API_KEY',
  );
}
