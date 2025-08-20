import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSwitcher extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;

  const LanguageSwitcher({Key? key, this.onLanguageChanged}) : super(key: key);

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  String _selectedLocale = 'en'; // Default locale

  // Language codes and their labels
  final List<String> _languageCodes = ['es', 'en', 'tr'];
  final Map<String, String> _languageLabels = {
    'es': 'Español',
    'en': 'English',
    'tr': 'Türkçe',
  };

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  // Load saved locale from SharedPreferences (equivalent to localStorage)
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString('locale');

      if (savedLocale != null && _languageCodes.contains(savedLocale)) {
        setState(() {
          _selectedLocale = savedLocale;
        });

        // Notify parent widget about the loaded locale
        if (widget.onLanguageChanged != null) {
          widget.onLanguageChanged!(Locale(savedLocale));
        }
      }
    } catch (e) {
      print('Error loading saved locale: $e');
    }
  }

  // Save locale to SharedPreferences and notify parent
  Future<void> _changeLang(String langCode) async {
    setState(() {
      _selectedLocale = langCode;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale', langCode);

      // Notify parent widget about the language change
      if (widget.onLanguageChanged != null) {
        widget.onLanguageChanged!(Locale(langCode));
      }
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _languageCodes.map((code) {
        final isSelected = _selectedLocale == code;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: OutlinedButton(
            onPressed: () => _changeLang(code),
            style: OutlinedButton.styleFrom(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              foregroundColor: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
            ),
            child: Text(
              _languageLabels[code] ?? code.toUpperCase(),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Alternative implementation using Wrap for better responsive behavior
class LanguageSwitcherWrap extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;

  const LanguageSwitcherWrap({Key? key, this.onLanguageChanged}) : super(key: key);

  @override
  State<LanguageSwitcherWrap> createState() => _LanguageSwitcherWrapState();
}

class _LanguageSwitcherWrapState extends State<LanguageSwitcherWrap> {
  String _selectedLocale = 'en';

  final List<String> _languageCodes = ['es', 'en', 'tr'];
  final Map<String, String> _languageLabels = {
    'es': 'Español',
    'en': 'English',
    'tr': 'Türkçe',
  };

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString('locale');

      if (savedLocale != null && _languageCodes.contains(savedLocale)) {
        setState(() {
          _selectedLocale = savedLocale;
        });

        if (widget.onLanguageChanged != null) {
          widget.onLanguageChanged!(Locale(savedLocale));
        }
      }
    } catch (e) {
      print('Error loading saved locale: $e');
    }
  }

  Future<void> _changeLang(String langCode) async {
    setState(() {
      _selectedLocale = langCode;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale', langCode);

      if (widget.onLanguageChanged != null) {
        widget.onLanguageChanged!(Locale(langCode));
      }
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Gap between buttons (equivalent to ga-2)
      children: _languageCodes.map((code) {
        final isSelected = _selectedLocale == code;

        return OutlinedButton(
          onPressed: () => _changeLang(code),
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            foregroundColor: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
          ),
          child: Text(
            _languageLabels[code] ?? code.toUpperCase(),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
    );
  }
}