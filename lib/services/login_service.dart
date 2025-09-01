import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  final String baseUrl;
  LoginService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String passcode) async {
    final url = Uri.parse('$baseUrl/api/traveller/login');
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
