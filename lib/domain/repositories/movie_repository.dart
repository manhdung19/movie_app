import 'package:dartz/dartz.dart';
import '../entities/movie_entity.dart';
import '../../core/error/failures.dart';
import '../entities/movie_detail_entity.dart';


typedef MovieDetail = MovieDetailEntity;

abstract class MovieRepository {
  // Lấy danh sách phim thịnh hành
  Future<Either<Failure, List<Movie>>> getTrendingMovie();

  // Lấy danh sách phim phổ biến (Popular)
  Future<Either<Failure, List<Movie>>> getPopularMovies();

  // Tìm kiếm phim dựa trên một từ khóa [query]
  Future<Either<Failure, List<Movie>>> searchMovies(String query);

  // Lấy thông tin của một bộ phim chi tiết dựa vào [id]
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);

  //Lưu một bộ phim là bộ phim yêu thích
  Future<Either<Failure, void >> saveFavoriteMovie(Movie movie);

  // Lấy danh sách tất cả các phim đã được lưu làm yêu thích.
  Future<Either<Failure, List<Movie>>> getFavoriteMovies();

  // Xóa một bộ phim khỏi danh sách yêu thích dựa vào [id].
  Future<Either<Failure, void >> deleteFavoriteMovie(int id);

  // Kiểm tra xem một bộ phim có [id] đã có trong danh sách yêu thích chưa.
  Future<Either<Failure, bool>> isFavoriteMovie(int id);

}
