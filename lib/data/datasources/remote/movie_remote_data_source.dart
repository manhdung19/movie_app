import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../models/movie_model.dart';

abstract class MovieRemoteDataSource {
    /// Gọi API endpoint: /trending/movie/week
    /// Bắn ra [ServerException] cho mọi mã lỗi.
    Future<List<MovieModel>> getTrendingMovies();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
    final Dio dio;

    MovieRemoteDataSourceImpl({required this.dio});

    @override
    Future<List<MovieModel>> getTrendingMovies() async {
        try {
            // Gọi API endpoint: /trending/movie/week
            final response = await dio.get('/trending/movie/week');

            if (response.statusCode == 200) {
                // TMDB trả về danh sách phim nằm trong key 'results'
                final List<dynamic> data = response.data['results'];
                //Map từng object Json thành MovieModel và trả về danh sách MovieModel
                return data.map((json) => MovieModel.fromJson(json)).toList();
            } else {
                throw ServerException(
                    message: 'Lỗi server với mã lỗi: ${response.statusCode}');
            }
        } on DioException catch (e) {
            // Bắt các lỗi cụ thể của Dio như lỗi kết nối, timeout, v.v.
            throw ServerException(
                message: e.message ?? 'Lỗi kết nối mạng');
        } catch (e) {
            throw ServerException(message: 'Lỗi không xác định: ${e.toString()}');
        }
    }
}



