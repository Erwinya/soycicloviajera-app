// lib/l10n/app_localizations.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('tr'),
  ];

  Future<bool> load() async {
    String languageCode = locale.languageCode;

    String jsonString = await rootBundle.loadString(
        'assets/locales/$languageCode.json'
    );

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Operator overloading to make usage easier: context.l10n['key']
  String operator [](String key) => translate(key);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Extension to make usage easier in widgets
extension LocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('es'); // Default locale (fallback)

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'es';
    _locale = Locale(localeCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (locale == _locale) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);

    _locale = locale;
    notifyListeners();
  }

  // Static method to get saved locale without provider
  static Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'es';
    return Locale(localeCode);
  }
}

// lib/main.dart - Main app setup
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get saved locale before starting the app
  final savedLocale = await LocaleProvider.getSavedLocale();

  runApp(MyApp(initialLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({Key? key, required this.initialLocale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Viajeras Frontend',

            // Localization setup
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Locale resolution strategy
            localeResolutionCallback: (locale, supportedLocales) {
              // Check if the current device locale is supported
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              // Fallback to Spanish (as in your original code)
              return const Locale('es');
            },

            home: const HomeScreen(),
            routes: {
              '/invalid-token': (context) => const InvalidTokenScreen(),
              '/forgot-passcode': (context) => const ForgotPasscodeScreen(),
              '/reset-passcode': (context) => const ResetPasscodeScreen(),
            },
          );
        },
      ),
    );
  }
}

// Example usage in a widget
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n['app_title'] ?? 'Viajeras'),
        actions: [
          // Language switcher dropdown
          DropdownButton<Locale>(
            value: localeProvider.locale,
            items: AppLocalizations.supportedLocales.map((locale) {
              return DropdownMenuItem(
                value: locale,
                child: Text(locale.languageCode.toUpperCase()),
              );
            }).toList(),
            onChanged: (locale) {
              if (locale != null) {
                localeProvider.setLocale(locale);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(context.l10n['welcome_message'] ?? 'Welcome'),
            Text(context.l10n['description'] ?? 'Description'),

            // Alternative usage
            Text(context.l10n.translate('button_text')),

            ElevatedButton(
              onPressed: () {
                // Change language programmatically
                localeProvider.setLocale(const Locale('en'));
              },
              child: Text(context.l10n['change_language'] ?? 'Change Language'),
            ),
          ],
        ),
      ),
    );
  }
}