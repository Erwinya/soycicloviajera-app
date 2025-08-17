import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cicloviajera Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedLanguage = 'en';

  final List<String> _languageCodes = ['es', 'en', 'tr'];
  final Map<String, String> _languageLabels = {
    'es': 'ES',
    'en': 'EN',
    'tr': 'TR',
  };

  // Translation keys
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'account': 'Account',
      'email': 'Email',
      'password': 'Password',
      'forgot': 'Forgot Password?',
      'login': 'Log In',
      'signup': 'Sign up',
      'fillAllFields': 'Please fill all fields',
      'invalidCredentials': 'Invalid email or password',
      'loginFailed': 'Login failed',
      'language': 'EN',
    },
    'es': {
      'account': 'Cuenta',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'forgot': '¿Olvidaste tu contraseña?',
      'login': 'Iniciar sesión',
      'signup': 'Registrarse',
      'fillAllFields': 'Por favor llena todos los campos',
      'invalidCredentials': 'Email o contraseña inválidos',
      'loginFailed': 'Fallo en el inicio de sesión',
      'language': 'ES',
    },
    'tr': {
      'account': 'Hesap',
      'email': 'E-posta',
      'password': 'Şifre',
      'forgot': 'Şifreni mi unuttun?',
      'login': 'Giriş Yap',
      'signup': 'Kayıt Ol',
      'fillAllFields': 'Lütfen tüm alanları doldurun',
      'invalidCredentials': 'Geçersiz e-posta veya şifre',
      'loginFailed': 'Giriş başarısız',
      'language': 'TR',
    },
  };

  String t(String key) {
    return _translations[_selectedLanguage]?[key] ?? key;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = t('fillAllFields');
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate API call (replace this with actual API call when http package is added)
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock login validation (replace with real API call)
      if (_emailController.text.contains('@') && _passwordController.text.length >= 6) {
        // Mock successful login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to next page (you would implement this)
        // Navigator.pushReplacementNamed(context, '/map');

      } else {
        throw Exception(t('invalidCredentials'));
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString().contains('Exception:')
            ? error.toString().replaceAll('Exception: ', '')
            : t('invalidCredentials');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeLanguage(String langCode) {
    setState(() {
      _selectedLanguage = langCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?ixlib=rb-4.0.3'), // Placeholder image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        width: 180,
                        height: 80,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'CICLOVIAJERA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),

                      // Account title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          t('account'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Error message
                      if (_errorMessage.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Email field
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: t('email'),
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Password label and forgot link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t('password'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to forgot password page
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  t('forgot'),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward, size: 12, color: Colors.blue),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: t('password'),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(
                            t('login'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign up link
                      TextButton(
                        onPressed: () {
                          // Navigate to register page
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              t('signup'),
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, color: Colors.blue),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Language selection
                      Row(
                        children: _languageCodes.map((code) {
                          final isSelected = _selectedLanguage == code;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: code != _languageCodes.last ? 8 : 0,
                              ),
                              child: OutlinedButton(
                                onPressed: () => _changeLanguage(code),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
                                  foregroundColor: isSelected ? Colors.blue : Colors.grey[700],
                                  side: BorderSide(
                                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                                  ),
                                ),
                                child: Text(
                                  _languageLabels[code] ?? code.toUpperCase(),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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