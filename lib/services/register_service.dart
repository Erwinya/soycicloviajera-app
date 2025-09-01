import 'package:dio/dio.dart';

/// RegisterService, kullanıcı kayıt işlemlerini yönetir.
class RegisterService {
  final Dio dio;
  RegisterService({Dio? dioClient}) : dio = dioClient ?? Dio();

  /// Kullanıcı kaydı için API çağrısı yapar.
  Future<Response> registerUser(Map<String, dynamic> data) async {
    // TODO: URL'i ortam değişkeninden veya sabitten al
    const String url = 'https://your-api-url.com/register';
    return await dio.post(url, data: data);
  }
}
