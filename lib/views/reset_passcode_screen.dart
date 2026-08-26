import 'package:flutter/material.dart';
import '../services/reset_passcode_service.dart';

class ResetPasscodeScreen extends StatefulWidget {
  final String token;

  const ResetPasscodeScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<ResetPasscodeScreen> createState() => _ResetPasscodeScreenState();
}

class _ResetPasscodeScreenState extends State<ResetPasscodeScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('ResetPasscodeScreen: token="${widget.token}"');
    debugPrint('ResetPasscodeScreen build: widget.token="${widget.token}"');
    // Token null olamaz, sadece boşluk kontrolü yapıyoruz
    if (widget.token.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Invalid or missing token. Please use the link from your email.',
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text('Go back to Login'),
              ),
            ],
          ),
        ),
      );
    }
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
                    children: <Widget>[
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text('Go back to Login'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text('Go back to Login'),
                      ),
                      const Text(
                        'Reset Passcode',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _newPasscodeController,
                        obscureText: !_isPasscodeVisible,
                        decoration: InputDecoration(
                          labelText: 'New Passcode',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasscodeVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasscodeVisible = !_isPasscodeVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) =>
                            _validateRequired(value, 'new passcode'),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _resetPasscode,
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
                              : const Text(
                                  'Reset Passcode',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      if (_showSuccessMessage) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
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
                                  'Passcode changed successfully!',
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (_showErrorMessage) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
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
                                  'Passcode change error. Please try again.',
                                  style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontWeight: FontWeight.w500,
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

  final _formKey = GlobalKey<FormState>();
  final _newPasscodeController = TextEditingController();
  bool _isPasscodeVisible = false;
  bool _isLoading = false;
  bool _showSuccessMessage = false;
  bool _showErrorMessage = false;
  late final ResetPasscodeService _resetPasscodeService =
      ResetPasscodeService();

  @override
  void dispose() {
    _newPasscodeController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName.';
    }
    return null;
  }

  Future<void> _resetPasscode() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (widget.token.isEmpty) {
      setState(() {
        _showErrorMessage = true;
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _showErrorMessage = false;
      _showSuccessMessage = false;
    });
    try {
      final response = await _resetPasscodeService.resetPasscode(
        token: widget.token,
        passcode: _newPasscodeController.text,
      );
      if (response.statusCode == 200) {
        setState(() {
          _showSuccessMessage = true;
        });
      } else {
        setState(() {
          _showErrorMessage = true;
        });
      }
    } catch (e) {
      setState(() {
        _showErrorMessage = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
