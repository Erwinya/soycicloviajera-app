import 'package:flutter/material.dart';
import '../services/forgot_passcode_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasscodePage extends StatefulWidget {
  const ForgotPasscodePage({Key? key}) : super(key: key);

  @override
  State<ForgotPasscodePage> createState() => _ForgotPasscodePageState();
}

class _ForgotPasscodePageState extends State<ForgotPasscodePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  String _successMessage = '';
  String _errorMessage = '';
  final String _baseUrl = 'your-backend-url.com'; // Replace with actual URL
  late final ForgotPasscodeService _forgotPasscodeService;

  @override
  void initState() {
    super.initState();
    _forgotPasscodeService = ForgotPasscodeService(baseUrl: _baseUrl);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  String _t(String key) {
    final Map<String, Map<String, String>> translations = {
      'tr': {
        'email': 'Email',
        'sendResetLink': 'Sıfırlama Bağlantısı Gönder',
        'resetLinkSentMsg':
            'Şifre sıfırlama bağlantısı email adresinize gönderildi',
        'resetLinkSentErrorMsg':
            'Şifre sıfırlama bağlantısı gönderilirken hata oluştu',
        'obligatedFieldMsg': 'Bu alan zorunludur: ',
        'validMailErrorMsg': 'Geçerli bir email adresi giriniz',
      },
      'en': {
        'email': 'Email',
        'sendResetLink': 'Send Reset Link',
        'resetLinkSentMsg': 'Password reset link has been sent to your email',
        'resetLinkSentErrorMsg': 'Error occurred while sending reset link',
        'obligatedFieldMsg': 'This field is required: ',
        'validMailErrorMsg': 'Please enter a valid email address',
      },
      'es': {
        'email': 'Correo',
        'sendResetLink': 'Enviar Enlace de Restablecimiento',
        'resetLinkSentMsg':
            'El enlace de restablecimiento de contraseña ha sido enviado a su correo',
        'resetLinkSentErrorMsg':
            'Error al enviar el enlace de restablecimiento',
        'obligatedFieldMsg': 'Este campo es obligatorio: ',
        'validMailErrorMsg': 'Por favor ingrese una dirección de correo válida',
      },
    };
    final locale = Localizations.localeOf(context).languageCode;
    return translations[locale]?[key] ?? key;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '${_t('obligatedFieldMsg')}${_t('email')}';
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return _t('validMailErrorMsg');
    }

    return null;
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_emailController.text.isEmpty ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
            .hasMatch(_emailController.text)) {
      return;
    }

    setState(() {
      _loading = true;
      _successMessage = '';
      _errorMessage = '';
    });

    try {
      final response =
          await _forgotPasscodeService.sendResetLink(_emailController.text);
      if (!response.statusCode.toString().startsWith('2')) {
        throw Exception(response.body);
      }
      setState(() {
        _successMessage = _t('resetLinkSentMsg');
      });
    } catch (err) {
      setState(() {
        _errorMessage = _t('resetLinkSentErrorMsg');
      });
    } finally {
      setState(() {
        _loading = false;
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        constraints: const BoxConstraints(maxWidth: 180),
                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                        child: Image.asset(
                          'lib/assets/images/cicloviajera-color-2.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Email field
                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        decoration: InputDecoration(
                          labelText: _t('email'),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _t('sendResetLink'),
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      ),

                      // Success alert
                      if (_successMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            border: Border(
                              left: BorderSide(
                                color: Colors.green.shade400,
                                width: 4,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _successMessage,
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Error alert
                      if (_errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border(
                              left: BorderSide(
                                color: Colors.red.shade400,
                                width: 4,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.red.shade600,
                                size: 20,
                              ),
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
                      ],
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
