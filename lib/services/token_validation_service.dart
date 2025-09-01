import 'package:http/http.dart' as http;
import 'dart:convert';

class TokenValidationService {
  final String baseUrl;
  TokenValidationService({required this.baseUrl});

  Future<bool> validateToken(String token) async {
    final response = await http.get(
        Uri.parse('http://$baseUrl/api/validate-reset-token?token=$token'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['valid'] == true;
    }
    return false;
  }
}
