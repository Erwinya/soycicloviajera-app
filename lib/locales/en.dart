// Method 1: Using Flutter's official intl package
// File: lib/l10n/app_localizations_en.dart

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get email => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get login => 'Log In';

  @override
  String get forgot => 'Forgot login password?';

  @override
  String get warning => 'Warning: After 3 consecutive failed login attempts, your account will be temporarily locked for three hours.';

  @override
  String get signup => 'Sign up now';

  @override
  String get account => 'Account';

  @override
  String get name => 'Name';

  @override
  String get surname => 'Surname';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get telegram => 'Telegram';

  @override
  String get preferredContact => 'Preferred Contact';

  @override
  String get registerDescription => 'How am I?';

  @override
  String get successfulRegistrationMsg => 'Registration successful! You can login now.';

  @override
  String get sendResetLink => 'Recover your password';

  @override
  String get resetPasscode => 'Reset your password';

  @override
  String get newPasscode => 'Write your new password';

  @override
  String get passcodeChangeError => 'Error occurred trying to change your passcode';

  @override
  String get passcodeChangeSuccessful => 'Passcode successfully changed!';

  @override
  String get obligatedFieldMsg => 'You must enter a ';

  @override
  String get validMailErrorMsg => 'Please enter a valid email address.';

  @override
  String get resetLinkSentErrorMsg => 'Error creating password reset connection';

  @override
  String get resetLinkSentMsg => 'Passcode reset link sent';

  @override
  String get loginError => 'Invalid email or password';

  // Map nested properties
  @override
  String get mapOwner => 'Owner';

  @override
  String get mapAbout => 'About';

  @override
  String get mapOffer => 'Offer';

  @override
  String get mapContactType => 'Contact type';

  @override
  String get mapContact => 'Contact';

  @override
  String get mapUpdateLocation => 'Update';

  @override
  String get mapCancelUpdateLocation => 'Cancel';

  @override
  String get mapLogout => 'Logout';

  @override
  String get mapUpdateProfile => 'Update profile';

  @override
  String get mapSave => 'Save';

  @override
  String get mapCancel => 'Cancel';
}

// ==========================================================================
// Method 2: Using a simple Map-based approach (Alternative)
// File: lib/localization/en_strings.dart

class EnStrings {
  static const Map<String, dynamic> en = {
    'language': 'English',
    'email': 'Email address',
    'password': 'Password',
    'login': 'Log In',
    'forgot': 'Forgot login password?',
    'warning': 'Warning: After 3 consecutive failed login attempts, your account will be temporarily locked for three hours.',
    'signup': 'Sign up now',
    'account': 'Account',
    'name': 'Name',
    'surname': 'Surname',
    'phoneNumber': 'Phone Number',
    'telegram': 'Telegram',
    'preferredContact': 'Preferred Contact',
    'registerDescription': 'How am I?',
    'successfulRegistrationMsg': 'Registration successful! You can login now.',
    'sendResetLink': 'Recover your password',
    'resetPasscode': 'Reset your password',
    'newPasscode': 'Write your new password',
    'passcodeChangeError': 'Error occurred trying to change your passcode',
    'passcodeChangeSuccessful': 'Passcode successfully changed!',
    'obligatedFieldMsg': 'You must enter a ',
    'validMailErrorMsg': 'Please enter a valid email address.',
    'resetLinkSentErrorMsg': 'Error creating password reset connection',
    'resetLinkSentMsg': 'Passcode reset link sent',
    'loginError': 'Invalid email or password',
    'map': {
      'owner': 'Owner',
      'mapAbout': 'About',
      'offer': 'Offer',
      'contactType': 'Contact type',
      'contact': 'Contact',
      'updateLocation': 'Update',
      'cancelUpdateLocation': 'Cancel',
      'logout': 'Logout',
      'updateProfile': 'Update profile',
      'save': 'Save',
      'cancel': 'Cancel',
    },
  };

  // Helper methods for easier access
  static String get language => en['language'];
  static String get email => en['email'];
  static String get password => en['password'];
  static String get login => en['login'];
  static String get forgot => en['forgot'];
  static String get warning => en['warning'];
  static String get signup => en['signup'];
  static String get account => en['account'];
  static String get name => en['name'];
  static String get surname => en['surname'];
  static String get phoneNumber => en['phoneNumber'];
  static String get telegram => en['telegram'];
  static String get preferredContact => en['preferredContact'];
  static String get registerDescription => en['registerDescription'];
  static String get successfulRegistrationMsg => en['successfulRegistrationMsg'];
  static String get sendResetLink => en['sendResetLink'];
  static String get resetPasscode => en['resetPasscode'];
  static String get newPasscode => en['newPasscode'];
  static String get passcodeChangeError => en['passcodeChangeError'];
  static String get passcodeChangeSuccessful => en['passcodeChangeSuccessful'];
  static String get obligatedFieldMsg => en['obligatedFieldMsg'];
  static String get validMailErrorMsg => en['validMailErrorMsg'];
  static String get resetLinkSentErrorMsg => en['resetLinkSentErrorMsg'];
  static String get resetLinkSentMsg => en['resetLinkSentMsg'];
  static String get loginError => en['loginError'];

  // Map properties
  static Map<String, String> get map => Map<String, String>.from(en['map']);
  static String get mapOwner => map['owner']!;
  static String get mapAbout => map['mapAbout']!;
  static String get mapOffer => map['offer']!;
  static String get mapContactType => map['contactType']!;
  static String get mapContact => map['contact']!;
  static String get mapUpdateLocation => map['updateLocation']!;
  static String get mapCancelUpdateLocation => map['cancelUpdateLocation']!;
  static String get mapLogout => map['logout']!;
  static String get mapUpdateProfile => map['updateProfile']!;
  static String get mapSave => map['save']!;
  static String get mapCancel => map['cancel']!;
}

// ==========================================================================
// Method 3: Using GetX package for internationalization
// File: lib/localization/en_US.dart

import 'package:get/get.dart';

class EnUS extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'language': 'English',
      'email': 'Email address',
      'password': 'Password',
      'login': 'Log In',
      'forgot': 'Forgot login password?',
      'warning': 'Warning: After 3 consecutive failed login attempts, your account will be temporarily locked for three hours.',
      'signup': 'Sign up now',
      'account': 'Account',
      'name': 'Name',
      'surname': 'Surname',
      'phoneNumber': 'Phone Number',
      'telegram': 'Telegram',
      'preferredContact': 'Preferred Contact',
      'registerDescription': 'How am I?',
      'successfulRegistrationMsg': 'Registration successful! You can login now.',
      'sendResetLink': 'Recover your password',
      'resetPasscode': 'Reset your password',
      'newPasscode': 'Write your new password',
      'passcodeChangeError': 'Error occurred trying to change your passcode',
      'passcodeChangeSuccessful': 'Passcode successfully changed!',
      'obligatedFieldMsg': 'You must enter a ',
      'validMailErrorMsg': 'Please enter a valid email address.',
      'resetLinkSentErrorMsg': 'Error creating password reset connection',
      'resetLinkSentMsg': 'Passcode reset link sent',
      'loginError': 'Invalid email or password',
      'map_owner': 'Owner',
      'map_about': 'About',
      'map_offer': 'Offer',
      'map_contactType': 'Contact type',
      'map_contact': 'Contact',
      'map_updateLocation': 'Update',
      'map_cancelUpdateLocation': 'Cancel',
      'map_logout': 'Logout',
      'map_updateProfile': 'Update profile',
      'map_save': 'Save',
      'map_cancel': 'Cancel',
    }
  };
}

// Usage example for GetX:
// Text('login'.tr) // This will show "Log In"
// Text('map_owner'.tr) // This will show "Owner"

// ==========================================================================
// BONUS: Complete Localization Manager for all languages
// File: lib/localization/localization_manager.dart

import 'package:flutter/material.dart';

class LocalizationManager {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('tr', 'TR'),
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'tr': 'Türkçe',
  };

  static String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? 'Unknown';
  }

  static Locale? getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return const Locale('en', 'US');
      case 'es':
        return const Locale('es', 'ES');
      case 'tr':
        return const Locale('tr', 'TR');
      default:
        return null;
    }
  }
}