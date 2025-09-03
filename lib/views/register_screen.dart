import 'package:flutter/material.dart';
import '../services/register_service.dart';
import '../l10n/app_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Şimdilik yorum satırı

class RegisterScreen extends StatefulWidget {
  final void Function(Locale)? onLocaleChanged;
  const RegisterScreen({Key? key, this.onLocaleChanged}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final RegisterService _registerService = RegisterService();

  // Controllers
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _telegramController = TextEditingController();
  final _descriptionController = TextEditingController();

  // State variables
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _showSuccessMessage = false;
  String _selectedPreferredContact = 'EMAIL';

  final List<String> _contactOptions = [
    'PHONE',
    'EMAIL',
    'WHATSAPP',
    'TELEGRAM'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _telegramController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'You must enter a $fieldName.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'You must enter an email.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _showSuccessMessage = false;
    });

    final data = {
      'name': _nameController.text,
      'surname': _surnameController.text,
      'phoneNumber': _phoneController.text,
      'email': _emailController.text,
      'description': _descriptionController.text,
      'passcode': _passwordController.text,
      'telegramID': _telegramController.text,
      'preferredContact': _selectedPreferredContact,
    };

    try {
      final response = await _registerService.registerUser(data);
      if (response.statusCode == 204) {
        setState(() {
          _showSuccessMessage = true;
        });
        // Clear form after successful registration
        _formKey.currentState?.reset();
        _nameController.clear();
        _surnameController.clear();
        _passwordController.clear();
        _phoneController.clear();
        _emailController.clear();
        _telegramController.clear();
        _descriptionController.clear();
        _selectedPreferredContact = 'EMAIL';
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.registrationError ??
                'An error occurred during registration.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        margin: const EdgeInsets.only(bottom: 32, top: 16),
                        child: Image.asset(
                          'lib/assets/images/cicloviajera-color-2.png',
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.name,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            _validateRequired(value, l10n.name),
                      ),
                      const SizedBox(height: 16),

                      // Surname Field
                      TextFormField(
                        controller: _surnameController,
                        decoration: InputDecoration(
                          labelText: l10n.surname,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            _validateRequired(value, l10n.surname),
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) =>
                            _validateRequired(value, l10n.password),
                      ),
                      const SizedBox(height: 16),

                      // Phone Number Field
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: l10n.phoneNumber,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            _validateRequired(value, l10n.phoneNumber),
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),

                      // Telegram Field (Optional)
                      TextFormField(
                        controller: _telegramController,
                        decoration: InputDecoration(
                          labelText: l10n.telegram,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Preferred Contact Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedPreferredContact,
                        decoration: InputDecoration(
                          labelText: l10n.preferredContact,
                          border: const OutlineInputBorder(),
                        ),
                        items: _contactOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedPreferredContact = newValue;
                            });
                          }
                        },
                        validator: (value) =>
                            _validateRequired(value, l10n.preferredContact),
                      ),
                      const SizedBox(height: 16),

                      // Description Field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.registerDescription,
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 6,
                        minLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                                  l10n.signup,
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      ),

                      // Success Message
                      if (_showSuccessMessage) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF66BB6A),
                              ),
                            ),
                          ),
                          // ...other child widgets if needed...
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
