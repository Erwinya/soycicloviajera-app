import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/api_config.dart';

class LoginService {
  Future<Map<String, dynamic>> login(String email, String passcode) async {
    final url = ApiConfig.endpoint('/api/traveller/login');
    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'passcode': passcode,
          }),
        )
        .timeout(const Duration(seconds: 15));

    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }
}
