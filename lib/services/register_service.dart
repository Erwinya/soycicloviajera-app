import 'package:dio/dio.dart';

import '../config/api_config.dart';

class RegisterService {
  final Dio dio;
  RegisterService({Dio? dioClient}) : dio = dioClient ?? Dio();

  Future<Response<dynamic>> registerUser(Map<String, dynamic> data) async {
    return dio.post(
      ApiConfig.endpoint('/api/traveller/register').toString(),
      data: data,
    );
  }
}
