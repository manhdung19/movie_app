import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/remote/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  //Constructor nhận vào RemoteDataSource instance để gọi API
  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getTrendingMovie() async {
    try {
      // Lấy dữ liêu từ RemoteDataSource
      final remoteMovies = await remoteDataSource.getTrendingMovies();
      // Trả về Right chứa danh sách Movie nếu thành công
      return Right(remoteMovies);
    } on ServerException catch (e) {
      // Nếu DataSource ném ra ServerException, chúng ta sẽ bắt và trả về Left chứa ServerFailure
      return Left(ServerFailure(message: e.message));
    }
  }

  @override 
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    // TODO: Triển khai ở Tuần 4
    throw UnimplementedError();
  }
  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async {
    // TODO: Triển khai ở Tuần 4
    throw UnimplementedError();
  }
  @override
  Future<Either<Failure, void>> saveFavoriteMovie(Movie movie) async {
    // TODO: Triển khai ở Tuần 4
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies() async {
    // TODO: Triển khai ở Tuần 4
    throw UnimplementedError();
  }
  @override
  Future<Either<Failure, void>> deleteFavoriteMovie(int id) async {
    // TODO: Triển khai ở Tuần 4
    throw UnimplementedError();
  }
  @override
  Future<Either<Failure, bool>> isFavoriteMovie(int id) async {
    // TODO: Triển khai ở Tuần 4
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    // TODO: Triển khai ở Tuần 4
    throw UnimplementedError();
  }
}
