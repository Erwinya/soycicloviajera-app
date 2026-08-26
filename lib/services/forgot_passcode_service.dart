import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ForgotPasscodeService {
  Future<http.Response> sendResetLink(String email) async {
    return http.post(
      ApiConfig.endpoint(
        '/api/forgot-passcode',
        queryParameters: {'email': email},
      ),
      headers: {
        'accept': '*/*',
      },
    );
  }
}
