import 'package:dio/dio.dart';

class ResetPasscodeService {
  final Dio dio;
  final String baseUrl;
  ResetPasscodeService({Dio? dioClient, required this.baseUrl})
      : dio = dioClient ?? Dio();

  Future<Response> resetPasscode(
      {required String token, required String passcode}) async {
    final url = 'http://$baseUrl/api/reset-passcode/$token';
    return await dio.post(
      url,
      data: '',
      queryParameters: {'passcode': passcode},
    );
  }
}
