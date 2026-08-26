import 'package:dio/dio.dart';

import '../config/api_config.dart';

class ResetPasscodeService {
  final Dio dio;
  ResetPasscodeService({Dio? dioClient}) : dio = dioClient ?? Dio();

  Future<Response<dynamic>> resetPasscode({
    required String token,
    required String passcode,
  }) async {
    return dio.post(
      ApiConfig.endpoint('/api/reset-passcode/$token').toString(),
      data: '',
      queryParameters: {'passcode': passcode},
    );
  }
}
