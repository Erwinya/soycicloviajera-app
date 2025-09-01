import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvalidTokenScreen extends StatefulWidget {
  final String? token;

  const InvalidTokenScreen({Key? key, this.token}) : super(key: key);

  @override
  State<InvalidTokenScreen> createState() => _InvalidTokenScreenState();
}

class _InvalidTokenScreenState extends State<InvalidTokenScreen> {
  @override
  void initState() {
    super.initState();
    _validateToken();
  }

  Future<void> _validateToken() async {
    if (widget.token == null || widget.token!.isEmpty) {
      setState(() {});
      return;
    }

    // Environment variable'dan base URL'i alın
    const String baseUrl = String.fromEnvironment('BACKEND_BASE_URL',
        defaultValue: 'localhost:3000'); // varsayılan değer

    try {
      final response = await http.get(Uri.parse(
          'http://$baseUrl/api/validate-reset-token?token=${widget.token}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['valid'] == true) {
          // Reset passcode sayfasına yönlendir
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/reset-passcode',
                arguments: {'token': widget.token});
          }
        } else {
          setState(() {});
        }
      } else {
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    }
  }

  void _navigateToForgotPasscode() {
    Navigator.pushReplacementNamed(context, '/forgot-passcode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hero-banner.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 48,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          constraints: const BoxConstraints(maxWidth: 180),
                          margin: const EdgeInsets.only(top: 8, bottom: 16),
                          child: Image.asset(
                            'assets/cicloviajera-color-2.png',
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Error Alert
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Card(
                            color: Colors.red.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Colors.red.shade300,
                                width: 1,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.red,
                                    width: 4,
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Invalid or expired reset token.',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Back to Reset Button
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _navigateToForgotPasscode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Back to Reset',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
      ),
    );
  }
}
