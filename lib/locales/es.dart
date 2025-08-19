// Method 1: Using Flutter's official intl package
// File: lib/l10n/app_localizations_es.dart

import 'app_localizations.dart';

/// The translations for Spanish (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language => 'Español';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get forgot => '¿Olvidaste tu contraseña?';

  @override
  String get warning => 'Advertencia: Después de 3 intentos fallidos, tu cuenta se bloqueará durante tres horas.';

  @override
  String get signup => 'Regístrate ahora';

  @override
  String get account => 'Cuenta';

  @override
  String get name => 'Nombre';

  @override
  String get surname => 'Apellido';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get telegram => 'Telegram';

  @override
  String get preferredContact => 'Contacto preferido';

  @override
  String get registerDescription => '¿Quién soy yo?';

  @override
  String get successfulRegistrationMsg => '¡Registro exitoso! Ahora puedes iniciar sesión.!';

  @override
  String get sendResetLink => 'Enviar enlace de restablecimiento';

  @override
  String get resetPasscode => 'Restablece tu contraseña';

  @override
  String get newPasscode => 'Introduce tu nueva contraseña';

  @override
  String get passcodeChangeError => 'Se ha producido un error al intentar cambiar el código de acceso';

  @override
  String get passcodeChangeSuccessful => 'La contraseña se ha modificado correctamente!';

  @override
  String get obligatedFieldMsg => 'Debes introducir un ';

  @override
  String get validMailErrorMsg => 'Por favor, introduce un correo electrónico valido';

  @override
  String get resetLinkSentErrorMsg => 'Error al crear la conexión de restablecimiento de contraseña';

  @override
  String get resetLinkSentMsg => 'Enlace de restablecimiento de contraseña enviado';

  @override
  String get loginError => 'Correo electrónico o contraseña invalido';

  // Map nested properties
  @override
  String get mapOwner => 'Soy';

  @override
  String get mapAbout => 'Más sobre mi';

  @override
  String get mapOffer => 'Que ofrezco';

  @override
  String get mapContactType => 'Tipo de contacto';

  @override
  String get mapContact => 'Contacto';

  @override
  String get mapUpdateLocation => 'Actualizar';

  @override
  String get mapCancelUpdateLocation => 'Cancelar';

  @override
  String get mapLogout => 'Cerrar sesión';

  @override
  String get mapUpdateProfile => 'Actualizar perfil';

  @override
  String get mapSave => 'Guardar';

  @override
  String get mapCancel => 'Cancelar';
}

// ==========================================================================
// Method 2: Using a simple Map-based approach (Alternative)
// File: lib/localization/es_strings.dart

class EsStrings {
  static const Map<String, dynamic> es = {
    'language': 'Español',
    'email': 'Correo electrónico',
    'password': 'Contraseña',
    'login': 'Iniciar sesión',
    'forgot': '¿Olvidaste tu contraseña?',
    'warning': 'Advertencia: Después de 3 intentos fallidos, tu cuenta se bloqueará durante tres horas.',
    'signup': 'Regístrate ahora',
    'account': 'Cuenta',
    'name': 'Nombre',
    'surname': 'Apellido',
    'phoneNumber': 'Número de teléfono',
    'telegram': 'Telegram',
    'preferredContact': 'Contacto preferido',
    'registerDescription': '¿Quién soy yo?',
    'successfulRegistrationMsg': '¡Registro exitoso! Ahora puedes iniciar sesión.!',
    'sendResetLink': 'Enviar enlace de restablecimiento',
    'resetPasscode': 'Restablece tu contraseña',
    'newPasscode': 'Introduce tu nueva contraseña',
    'passcodeChangeError': 'Se ha producido un error al intentar cambiar el código de acceso',
    'passcodeChangeSuccessful': 'La contraseña se ha modificado correctamente!',
    'obligatedFieldMsg': 'Debes introducir un ',
    'validMailErrorMsg': 'Por favor, introduce un correo electrónico valido',
    'resetLinkSentErrorMsg': 'Error al crear la conexión de restablecimiento de contraseña',
    'resetLinkSentMsg': 'Enlace de restablecimiento de contraseña enviado',
    'loginError': 'Correo electrónico o contraseña invalido',
    'map': {
      'owner': 'Soy',
      'about': 'Más sobre mi',
      'offer': 'Que ofrezco',
      'contactType': 'Tipo de contacto',
      'contact': 'Contacto',
      'updateLocation': 'Actualizar',
      'cancelUpdateLocation': 'Cancelar',
      'logout': 'Cerrar sesión',
      'updateProfile': 'Actualizar perfil',
      'save': 'Guardar',
      'cancel': 'Cancelar',
    },
  };

  // Helper methods for easier access
  static String get language => es['language'];
  static String get email => es['email'];
  static String get password => es['password'];
  static String get login => es['login'];
  static String get forgot => es['forgot'];
  static String get warning => es['warning'];
  static String get signup => es['signup'];
  static String get account => es['account'];
  static String get name => es['name'];
  static String get surname => es['surname'];
  static String get phoneNumber => es['phoneNumber'];
  static String get telegram => es['telegram'];
  static String get preferredContact => es['preferredContact'];
  static String get registerDescription => es['registerDescription'];
  static String get successfulRegistrationMsg => es['successfulRegistrationMsg'];
  static String get sendResetLink => es['sendResetLink'];
  static String get resetPasscode => es['resetPasscode'];
  static String get newPasscode => es['newPasscode'];
  static String get passcodeChangeError => es['passcodeChangeError'];
  static String get passcodeChangeSuccessful => es['passcodeChangeSuccessful'];
  static String get obligatedFieldMsg => es['obligatedFieldMsg'];
  static String get validMailErrorMsg => es['validMailErrorMsg'];
  static String get resetLinkSentErrorMsg => es['resetLinkSentErrorMsg'];
  static String get resetLinkSentMsg => es['resetLinkSentMsg'];
  static String get loginError => es['loginError'];

  // Map properties
  static Map<String, String> get map => Map<String, String>.from(es['map']);
  static String get mapOwner => map['owner']!;
  static String get mapAbout => map['about']!;
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
// File: lib/localization/es_ES.dart

import 'package:get/get.dart';

class EsES extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'es_ES': {
      'language': 'Español',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'login': 'Iniciar sesión',
      'forgot': '¿Olvidaste tu contraseña?',
      'warning': 'Advertencia: Después de 3 intentos fallidos, tu cuenta se bloqueará durante tres horas.',
      'signup': 'Regístrate ahora',
      'account': 'Cuenta',
      'name': 'Nombre',
      'surname': 'Apellido',
      'phoneNumber': 'Número de teléfono',
      'telegram': 'Telegram',
      'preferredContact': 'Contacto preferido',
      'registerDescription': '¿Quién soy yo?',
      'successfulRegistrationMsg': '¡Registro exitoso! Ahora puedes iniciar sesión.!',
      'sendResetLink': 'Enviar enlace de restablecimiento',
      'resetPasscode': 'Restablece tu contraseña',
      'newPasscode': 'Introduce tu nueva contraseña',
      'passcodeChangeError': 'Se ha producido un error al intentar cambiar el código de acceso',
      'passcodeChangeSuccessful': 'La contraseña se ha modificado correctamente!',
      'obligatedFieldMsg': 'Debes introducir un ',
      'validMailErrorMsg': 'Por favor, introduce un correo electrónico valido',
      'resetLinkSentErrorMsg': 'Error al crear la conexión de restablecimiento de contraseña',
      'resetLinkSentMsg': 'Enlace de restablecimiento de contraseña enviado',
      'loginError': 'Correo electrónico o contraseña invalido',
      'map_owner': 'Soy',
      'map_about': 'Más sobre mi',
      'map_offer': 'Que ofrezco',
      'map_contactType': 'Tipo de contacto',
      'map_contact': 'Contacto',
      'map_updateLocation': 'Actualizar',
      'map_cancelUpdateLocation': 'Cancelar',
      'map_logout': 'Cerrar sesión',
      'map_updateProfile': 'Actualizar perfil',
      'map_save': 'Guardar',
      'map_cancel': 'Cancelar',
    }
  };
}

// Usage example for GetX:
// Text('login'.tr) // This will show "Iniciar sesión"
// Text('map_owner'.tr) // This will show "Soy"