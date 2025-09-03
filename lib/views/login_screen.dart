import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';

import '../services/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _visible = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedLocale = 'en'; // Default locale
  late final LoginService _loginService;
  final String _yourBackendDomain = 'YOUR_BACKEND_BASE_URL';
  final bool _isProduction = bool.fromEnvironment('dart.vm.product');
  late final String _baseUrl;

  final List<String> _languageCodes = const ['es', 'en', 'tr'];
  final Map<String, String> _languageLabels = const {
    'es': 'Español',
    'en': 'English',
    'tr': 'Türkçe',
  };

  @override
  void initState() {
    super.initState();
    _baseUrl = _isProduction
        ? 'https://$_yourBackendDomain'
        : 'http://$_yourBackendDomain';
    _loginService = LoginService(baseUrl: _baseUrl);
    _loadSelectedLocale();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkIfLoggedIn();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSelectedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');
    if (!mounted) return;
    setState(() {
      _selectedLocale = savedLocale ?? 'en';
    });
  }

  Future<void> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (!mounted) return;
    if (accessToken != null && accessToken.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/map');
    }
  }

  Future<void> _changeLang(String newLang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', newLang);
    if (!mounted) return;
    setState(() {
      _selectedLocale = newLang;
    });
  }

  // Use l10n for translations instead of manual map
  String _t(String key) {
    // Assuming you have generated AppLocalizations using flutter_localizations and intl
    // Import: import 'package:flutter_gen/gen_l10n/app_localizations.dart';
    final localizations = AppLocalizations.of(context);
    switch (key) {
      case 'account':
        return localizations?.account ?? key;
      case 'email':
        return localizations?.email ?? key;
      case 'password':
        return localizations?.password ?? key;
      case 'forgot':
        return localizations?.forgotPassword ?? key;
      case 'login':
        return localizations?.login ?? key;
      case 'signup':
        return localizations?.signUp ?? key;
      case 'fillAllFields':
        return localizations?.fillAllFields ?? key;
      case 'invalidCredentials':
        return localizations?.invalidCredentials ?? key;
      case 'loginFailedGeneric':
        return localizations?.loginFailedGeneric ?? key;
      case 'errorConnecting':
        return localizations?.errorConnecting ?? key;
      default:
        return key;
    }
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _t('fillAllFields');
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _loginService.login(
          _emailController.text, _passwordController.text);
      final statusCode = result['statusCode'];
      final data = jsonDecode(result['body']);

      if (statusCode == 200 || statusCode == 201) {
        if (data['accessToken'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', data['accessToken']);
          if (data['user'] != null) {
            await prefs.setString('user', jsonEncode(data['user']));
          }
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/map');
        } else {
          throw Exception(_t('loginFailedGeneric'));
        }
      } else if (statusCode == 401 || statusCode == 400) {
        final message = data['message'] ??
            (statusCode == 401
                ? _t('invalidCredentials')
                : _t('loginFailedGeneric'));
        throw Exception(message);
      } else {
        throw Exception('${_t('loginFailedGeneric')} (Status: $statusCode)');
      }
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
        if (_errorMessage.toLowerCase().contains('invalid') ||
            _errorMessage.toLowerCase().contains('unauthorized')) {
          _errorMessage = _t('invalidCredentials');
        }
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/hero-banner.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              width: double.infinity,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 180),
                          margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Image.asset(
                            'lib/assets/images/cicloviajera-color-2.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Account title
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _t('account'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      // Error message
                      if (_errorMessage.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              // Text değişken olduğu için const olamaz
                            ],
                          ),
                        ),

                      // Email field
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: _t('email'),
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      // Password label and forgot password
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _t('password'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/forgot-passcode');
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _t('forgot'),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Colors.blue,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: !_visible,
                        decoration: InputDecoration(
                          hintText: _t('password'),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _visible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              if (!mounted) return;
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _isLoading ? null : _login(),
                      ),

                      // Login button
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  _t('login'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      // Sign up link
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Center(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _t('signup'),
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Language buttons
                      if (_languageCodes.length > 1)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                            children: _languageCodes.map((code) {
                              return Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: OutlinedButton(
                                    onPressed: () => _changeLang(code),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: _selectedLocale == code
                                          ? Colors.blue.shade50
                                          : Colors.transparent,
                                      foregroundColor: _selectedLocale == code
                                          ? Colors.blue.shade700
                                          : Colors.black54,
                                      side: BorderSide(
                                        color: _selectedLocale == code
                                            ? Colors.blue.shade300
                                            : Colors.grey.shade300,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      _languageLabels[code] ??
                                          code.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: _selectedLocale == code
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
