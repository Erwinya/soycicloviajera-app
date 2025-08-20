import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ResetPasscodeScreen extends StatefulWidget {
  final String? token;

  const ResetPasscodeScreen({Key? key, this.token}) : super(key: key);

  @override
  State<ResetPasscodeScreen> createState() => _ResetPasscodeScreenState();
}

class _ResetPasscodeScreenState extends State<ResetPasscodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dio = Dio();

  // Controllers
  final _newPasscodeController = TextEditingController();

  // State variables
  bool _isPasscodeVisible = false;
  bool _isLoading = false;
  bool _showSuccessMessage = false;
  bool _showErrorMessage = false;

  @override
  void dispose() {
    _newPasscodeController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'You must enter a $fieldName.';
    }
    return null;
  }

  Future<void> _resetPasscode() async {
    // Reset messages
    setState(() {
      _showErrorMessage = false;
      _showSuccessMessage = false;
    });

    if (!_formKey.currentState!.validate() || widget.token == null) {
      setState(() {
        _showErrorMessage = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with your actual backend URL
      const baseUrl = String.fromEnvironment('BACKEND_BASE_URL', defaultValue: 'localhost:3000');

      final response = await _dio.post(
        'http://$baseUrl/api/reset-passcode/${widget.token}',
        data: '', // empty body
        queryParameters: {
          'passcode': _newPasscodeController.text,
        },
      );

      if (response.statusCode == 204) {
        setState(() {
          _showSuccessMessage = true;
          _newPasscodeController.clear();
        });
      } else {
        setState(() {
          _showErrorMessage = true;
        });
      }
    } catch (error) {
      print('Error resetting passcode: $error');
      setState(() {
        _showErrorMessage = true;
      });
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
                      // Title
                      const Text(
                        'Reset Passcode',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // New Passcode Field
                      TextFormField(
                        controller: _newPasscodeController,
                        obscureText: !_isPasscodeVisible,
                        decoration: InputDecoration(
                          labelText: 'New Passcode', // newPasscode
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasscodeVisible ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasscodeVisible = !_isPasscodeVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) => _validateRequired(value, 'new passcode'),
                      ),
                      const SizedBox(height: 24),

                      // Reset Button
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
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text(
                            'Reset Passcode', // resetPasscode
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      // Success Message
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
                                  'Passcode changed successfully!', // passcodeChangeSuccessful
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

                      // Error Message
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
                                  'Passcode change error. Please try again.', // passcodeChangeError
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
}