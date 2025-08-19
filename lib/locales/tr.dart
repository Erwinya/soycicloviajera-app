// Method 1: Using Flutter's official intl package
// File: lib/l10n/app_localizations_tr.dart

import 'app_localizations.dart';

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

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
// File: lib/localization/tr_strings.dart

class TrStrings {
  static const Map<String, dynamic> tr = {
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
  static String get language => tr['language'];
  static String get email => tr['email'];
  static String get password => tr['password'];
  static String get login => tr['login'];
  static String get forgot => tr['forgot'];
  static String get warning => tr['warning'];
  static String get signup => tr['signup'];
  static String get account => tr['account'];
  static String get name => tr['name'];
  static String get surname => tr['surname'];
  static String get phoneNumber => tr['phoneNumber'];
  static String get telegram => tr['telegram'];
  static String get preferredContact => tr['preferredContact'];
  static String get registerDescription => tr['registerDescription'];
  static String get successfulRegistrationMsg => tr['successfulRegistrationMsg'];
  static String get sendResetLink => tr['sendResetLink'];
  static String get resetPasscode => tr['resetPasscode'];
  static String get newPasscode => tr['newPasscode'];
  static String get passcodeChangeError => tr['passcodeChangeError'];
  static String get passcodeChangeSuccessful => tr['passcodeChangeSuccessful'];
  static String get obligatedFieldMsg => tr['obligatedFieldMsg'];
  static String get validMailErrorMsg => tr['validMailErrorMsg'];
  static String get resetLinkSentErrorMsg => tr['resetLinkSentErrorMsg'];
  static String get resetLinkSentMsg => tr['resetLinkSentMsg'];
  static String get loginError => tr['loginError'];

  // Map properties
  static Map<String, String> get map => Map<String, String>.from(tr['map']);
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
// File: lib/localization/tr_TR.dart

import 'package:get/get.dart';

class TrTR extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'tr_TR': {
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