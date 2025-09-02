import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// Import your screens
import 'views/register_screen.dart';
import 'views/reset_passcode_screen.dart';
import 'views/login_screen.dart';
import 'views/forgot_passcode_screen.dart';
import 'views/map_screen.dart';
import 'views/errors/invalid_token_screen.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style (status bar, navigation bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');
    setState(() {
      _locale = Locale(savedLocale ?? 'en');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Eğer locale yüklenmediyse sadece loading göster
    if (_locale == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    // Locale yüklendiyse normal MaterialApp'ı başlat
    return MaterialApp(
      title: 'Viajeras Frontend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/login',
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const Login(),
        '/forgot-passcode': (context) => const ForgotPasscodePage(),
        '/map': (context) => const MapScreen(),
        '/invalid-token': (context) => const InvalidTokenScreen(),
      },
      onGenerateRoute: (settings) {
        debugPrint(
            'onGenerateRoute called with settings: name=${settings.name}, arguments=${settings.arguments}');
        try {
          if (settings.name == null) {
            debugPrint('Route name is null, redirecting to InvalidTokenScreen');
            return MaterialPageRoute(
              builder: (context) => const InvalidTokenScreen(),
              settings: settings,
            );
          }
          final uri = Uri.tryParse(settings.name ?? '');
          if (uri == null) {
            debugPrint(
                'Route URI could not be parsed: \'${settings.name}\', redirecting to InvalidTokenScreen');
            return MaterialPageRoute(
              builder: (context) => const InvalidTokenScreen(),
              settings: settings,
            );
          }
          if (uri.pathSegments.isNotEmpty &&
              uri.pathSegments[0] == 'reset-passcode') {
            // Hem query param hem arguments ile token gelebilir, ikisini de kontrol et
            String? token = uri.queryParameters['token'];
            if ((token == null || token.isEmpty) &&
                settings.arguments != null) {
              // arguments Map ise oradan da token almayı dene
              final args = settings.arguments;
              if (args is Map && args['token'] is String) {
                token = args['token'] as String;
              }
            }
            if (token != null && token.isNotEmpty) {
              debugPrint(
                  'Reset-passcode route called with token: $token, settings: $settings');
              return MaterialPageRoute(
                builder: (context) => ResetPasscodeScreen(token: token ?? ''),
                settings: settings,
              );
            } else {
              debugPrint(
                  'Reset-passcode route called with missing or empty token (query/arguments), redirecting to InvalidTokenScreen');
              return MaterialPageRoute(
                builder: (context) => const InvalidTokenScreen(),
                settings: settings,
              );
            }
          }
          debugPrint('Unknown route: ${settings.name}, returning null.');
          return null;
        } catch (e, stack) {
          debugPrint('onGenerateRoute error: $e\n$stack');
          return MaterialPageRoute(
            builder: (context) => const InvalidTokenScreen(),
            settings: settings,
          );
        }
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const InvalidTokenScreen(),
        );
      },
    );
  }
}

// Optional: Custom route wrapper that mimics v-app behavior
class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: child,
        ),
      ),
    );
  }
}
