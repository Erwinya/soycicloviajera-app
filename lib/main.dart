import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

// Import your screens
import 'views/register_screen.dart';
import 'views/reset_passcode_screen.dart';
import 'views/login_screen.dart';
import 'views/forgot_passcode_screen.dart';
import 'views/map_screen.dart';
import 'views/errors/invalid_token_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');
    if (!mounted) return;
    setState(() {
      _locale = Locale(savedLocale ?? 'es');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: ValueKey(_locale?.languageCode ?? 'es'),
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
      locale: _locale ?? const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        // Her zaman İspanyolca başlat
        return const Locale('es');
      },

      // Eğer locale yüklenmediyse loading göster
      home: _locale == null
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : LoginScreen(
              onLocaleChanged: setLocale,
            ),

      routes: {
        '/register': (context) => const RegisterScreen(),
        '/forgot-passcode': (context) => const ForgotPasscodePage(),
        '/map': (context) => const MapScreen(),
        '/invalid-token': (context) => const InvalidTokenScreen(),
      },

      onGenerateRoute: (settings) {
        debugPrint(
            'onGenerateRoute: name=${settings.name}, arguments=${settings.arguments}');
        final routeName = settings.name ?? '';

        final uri = Uri.tryParse(routeName);
        if (uri != null && uri.pathSegments.isNotEmpty) {
          if (uri.pathSegments[0] == 'reset-passcode') {
            String token = uri.queryParameters['token'] ?? '';
            if (token.isEmpty && settings.arguments is Map) {
              final args = settings.arguments as Map<String, dynamic>?;
              if (args != null &&
                  args['token'] is String &&
                  (args['token'] as String).isNotEmpty) {
                token = args['token'] as String;
              }
            }
            if (token.isNotEmpty) {
              return MaterialPageRoute(
                builder: (context) => ResetPasscodeScreen(token: token),
                settings: settings,
              );
            }
          }
        }

        return MaterialPageRoute(
          builder: (context) => const InvalidTokenScreen(),
          settings: settings,
        );
      },

      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const InvalidTokenScreen(),
      ),
    );
  }
}
