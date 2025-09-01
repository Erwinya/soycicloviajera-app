import 'package:http/http.dart' as http;
import 'dart:convert';

class MapService {
  Future<void> updateLocationDescription(String token, double latitude,
      double longitude, String newDescription) async {
    final response = await http.patch(
      Uri.parse('http://$baseUrl/api/locations'),
      headers: {
        'accept': '*/*',
        'X-Token': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'description': newDescription,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    if (!response.statusCode.toString().startsWith('2')) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Update failed');
    }
  }

  final String baseUrl;
  MapService({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetchLocations(String token) async {
    final response = await http.get(
      Uri.parse('http://$baseUrl/api/locations'),
      headers: {
        'accept': '*/*',
        'X-Token': token,
      },
    );
    if (!response.statusCode.toString().startsWith('2')) {
      throw Exception('Failed to fetch locations');
    }
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }

  Future<bool> updateProfile(String token, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('http://$baseUrl/api/profile'),
      headers: {
        'accept': '*/*',
        'X-Token': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode.toString().startsWith('2');
  }
}
