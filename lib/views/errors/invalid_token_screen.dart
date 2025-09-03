import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class InvalidTokenScreen extends StatefulWidget {
  const InvalidTokenScreen({Key? key}) : super(key: key);

  @override
  State<InvalidTokenScreen> createState() => _InvalidTokenScreenState();
}

class _InvalidTokenScreenState extends State<InvalidTokenScreen> {
  @override
  void initState() {
    super.initState();
    // Token kontrolü gereksiz, sadece ekran açılıyor
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
            image: AssetImage('lib/assets/images/hero-banner.png'),
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
                        const SizedBox(height: 8),
                        const SizedBox(
                          height: 180,
                          child: Image(
                            image: AssetImage(
                                'lib/assets/images/cicloviajera-color-2.png'),
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
                                border: const Border(
                                  left: BorderSide(
                                    color: Colors.red,
                                    width: 4,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)
                                                ?.invalidOrExpiredToken ??
                                            'Invalid or expired reset token.',
                                        style: const TextStyle(
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
                            child: Text(
                              AppLocalizations.of(context)?.backToReset ??
                                  'Back to Reset',
                              style: const TextStyle(
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
