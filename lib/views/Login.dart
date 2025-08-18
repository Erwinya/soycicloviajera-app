import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _visible = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedLocale = 'tr';

  final List<String> _languageCodes = ['es', 'en', 'tr'];
  final Map<String, String> _languageLabels = {
    'es': 'Español',
    'en': 'English',
    'tr': 'Türkçe',
  };

  @override
  void initState() {
    super.initState();
    _loadLanguageLabels();
    _checkIfLoggedIn();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loadLanguageLabels() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLocale = prefs.getString('locale') ?? 'tr';
    });
  }

  void _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      Navigator.pushReplacementNamed(context, '/map');
    }
  }

  void _changeLang(String newLang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', newLang);
    setState(() {
      _selectedLocale = newLang;
    });
  }

  String _t(String key) {
    final Map<String, Map<String, String>> translations = {
      'tr': {
        'account': 'Hesap',
        'email': 'Email',
        'password': 'Şifre',
        'forgot': 'Şifremi Unuttum',
        'login': 'Giriş Yap',
        'signup': 'Kayıt Ol',
        'fillAllFields': 'Lütfen tüm alanları doldurun',
        'invalidCredentials': 'Geçersiz email veya şifre',
      },
      'en': {
        'account': 'Account',
        'email': 'Email',
        'password': 'Password',
        'forgot': 'Forgot Password',
        'login': 'Login',
        'signup': 'Sign Up',
        'fillAllFields': 'Please fill all fields',
        'invalidCredentials': 'Invalid email or password',
      },
      'es': {
        'account': 'Cuenta',
        'email': 'Correo',
        'password': 'Contraseña',
        'forgot': 'Olvidé mi contraseña',
        'login': 'Iniciar Sesión',
        'signup': 'Registrarse',
        'fillAllFields': 'Por favor llene todos los campos',
        'invalidCredentials': 'Email o contraseña inválidos',
      },
    };

    return translations[_selectedLocale]?[key] ?? key;
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = _t('fillAllFields');
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      const baseUrl = 'your-backend-url.com'; // Replace with actual URL
      final url = Uri.parse(
          'http://$baseUrl/api/traveller?email=${Uri.encodeComponent(_emailController.text)}&passcode=${Uri.encodeComponent(_passwordController.text)}'
      );

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (!response.statusCode.toString().startsWith('2') || data['accessToken'] == null) {
        throw Exception(data['message'] ?? 'Login failed');
      }

      // Store the token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);

      // Store user data if available
      if (data['user'] != null) {
        await prefs.setString('user', jsonEncode(data['user']));
      }

      // Redirect to map
      Navigator.pushReplacementNamed(context, '/map');

    } catch (error) {
      setState(() {
        _errorMessage = error.toString().contains('Login failed')
            ? _t('invalidCredentials')
            : error.toString().replaceAll('Exception: ', '');
      });
    } finally {
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
            image: AssetImage('assets/images/hero-banner.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                          'assets/images/cicloviajera-color-2.png',
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
                          children: [
                            Icon(Icons.error, color: Colors.red.shade600, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/forgot-passcode');
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
                            _visible ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _visible = !_visible;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),

                    // Login button
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                          foregroundColor: Colors.blue.shade800,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Text(
                          _t('login'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    // Sign up link
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _t('signup'),
                                style: const TextStyle(
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
                    ),

                    // Language buttons
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Row(
                        children: _languageCodes.map((code) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: OutlinedButton(
                                onPressed: () => _changeLang(code),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedLocale == code
                                      ? Colors.blue
                                      : Colors.transparent,
                                  foregroundColor: _selectedLocale == code
                                      ? Colors.white
                                      : Colors.black87,
                                  side: BorderSide(
                                    color: _selectedLocale == code
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  _languageLabels[code] ?? code,
                                  style: const TextStyle(fontSize: 12),
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
    );
  }
}