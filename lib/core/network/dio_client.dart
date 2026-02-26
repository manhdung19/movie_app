import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;
  
  // Khởi tạo Singleton Pattern 
  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: "https://api.themoviedb.org/3",
          // Mọi request gọi qua client này sẽ tự động gắn các param dưới đây
          queryParameters: {
            'api_key':'7f4a2567963ad3242cd6c5c90e6ae6db', // add api key in here
            'language':'en-US',
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
    ){
      // Interceptor: Giúp bạn in ra log trong console để dễ debug API\
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: false,
        responseBody: true,
        responseHeader: false,
        error: true,
      ));
  }
}
