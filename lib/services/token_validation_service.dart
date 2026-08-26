import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/api_config.dart';

class TokenValidationService {
  Future<bool> validateToken(String token) async {
    final response = await http.get(
      ApiConfig.endpoint(
        '/api/validate-reset-token',
        queryParameters: {'token': token},
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['valid'] == true;
    }
    return false;
  }
}
