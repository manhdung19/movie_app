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
            'api_key':'', // add api key in here
            'language':'vi-VN',
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
