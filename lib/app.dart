import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viajeras Frontend',
      debugShowCheckedModeBanner: false,

      // Theme configuration
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

      // Localization (uncomment when ready)

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // Initial route
      initialRoute: '/register',

      // Route configuration

      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const Login(),
        '/forgot-passcode': (context) => const ForgotPasscodePage(),
        '/map': (context) => const MapScreen(),
        '/invalid-token': (context) => const InvalidTokenScreen(),
      },

      // Handle dynamic routes (like reset-passcode with token)
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');

        // Handle reset-passcode route with token parameter
        if (uri.pathSegments.isNotEmpty &&
            uri.pathSegments[0] == 'reset-passcode') {
          final token = uri.queryParameters['token'];
          return MaterialPageRoute(
            builder: (context) => ResetPasscodeScreen(token: token),
            settings: settings,
          );
        }

        // Handle other dynamic routes here if needed

        // Return null to use the default route handling
        return null;
      },

      // 404 fallback
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
      // This ensures full screen usage like v-app
      body: SafeArea(
        // Set to false if you want full screen including status bar area
        top: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white, // Equivalent to background-color: white
          child: child,
        ),
      ),
    );
  }
}
