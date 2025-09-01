import 'package:http/http.dart' as http;

class ForgotPasscodeService {
  final String baseUrl;
  ForgotPasscodeService({required this.baseUrl});

  Future<http.Response> sendResetLink(String email) async {
    final url = Uri.parse(
        'http://$baseUrl/api/forgot-passcode?email=${Uri.encodeComponent(email)}');
    return await http.post(
      url,
      headers: {
        'accept': '*/*',
      },
    );
  }
}
