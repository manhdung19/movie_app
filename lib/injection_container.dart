import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'data/datasources/remote/movie_remote_data_source.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/repositories/movie_repository.dart';

// Tạo một biến toàn cục 'sl' (viết tắt của Service Locator) để gọi ở mọi nơi
final sl = GetIt.instance;

Future<void> init() async {
  // Đăng ký DioClient như một singleton, nghĩa là sẽ chỉ có một instance duy nhất trong suốt vòng đời của ứng dụng
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Đăng ký MovieRemoteDataSourceImpl, nó sẽ tự động lấy instance của DioClient đã đăng ký ở trên
  sl.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(dio: sl<DioClient>().dio,
      ),
    );

  // Đăng kí repository, nó sẽ tự động lấy instance của MovieRemoteDataSourceImpl đã đăng ký ở trên
  sl.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(remoteDataSource: sl(),
      ),
    );
}