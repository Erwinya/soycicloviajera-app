/// Backend connection settings for the Soy Cicloviajera API.
///
/// Override at build/run time:
/// `flutter run --dart-define=API_HOST=api.example.com --dart-define=API_USE_HTTPS=true`
class ApiConfig {
  ApiConfig._();

  /// Host with optional port, e.g. `api.soycicloviajera.com` or `localhost:8080`.
  static const String host = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'localhost:8080',
  );

  static const bool useHttps = bool.fromEnvironment(
    'API_USE_HTTPS',
    defaultValue: false,
  );

  static String get origin {
    const scheme = useHttps ? 'https' : 'http';
    return '$scheme://$host';
  }

  static Uri endpoint(String path, {Map<String, String>? queryParameters}) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$origin$normalized')
        .replace(queryParameters: queryParameters);
  }
}
