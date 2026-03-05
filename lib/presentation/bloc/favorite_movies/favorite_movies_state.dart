import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import '../../../domain/entities/movie_entity.dart';

/// Abstract class đại diện cho tất cả các trạng thái (State)
/// mà UI Favorites có thể nhận được từ FavoriteMoviesBloc
///
/// Sử dụng Equatable để Flutter biết khi nào cần rebuild widget
abstract class FavoriteMoviesState extends Equatable {
  const FavoriteMoviesState();

  @override
  List<Object?> get props => [];
}

/// State BAN ĐẦU khi Bloc vừa được khởi tạo
/// Chưa load danh sách yêu thích
///
/// UI sẽ hiển thị:
/// - Màn hình trắng hoặc placeholder
/// - Hoặc tự động dispatch LoadFavoriteMovies ngay khi vào màn hình
class FavoriteMoviesInitial extends FavoriteMoviesState {
  const FavoriteMoviesInitial();
}

/// State khi đang LOAD danh sách phim yêu thích từ database
///
/// UI sẽ hiển thị:
/// - CircularProgressIndicator (loading indicator)
/// - Hoặc Shimmer effect
class FavoriteMoviesLoading extends FavoriteMoviesState {
  const FavoriteMoviesLoading();
}

/// State khi ĐÃ LOAD XONG danh sách phim yêu thích
/// và có ít nhất 1 phim
///
/// Chứa danh sách movies để UI hiển thị
///
/// UI sẽ hiển thị:
/// - ListView/GridView với các movie card
/// - Có nút xóa trên mỗi card
/// - Header: "Bạn có {movies.length} phim yêu thích"
class FavoriteMoviesLoaded extends FavoriteMoviesState {
  /// Danh sách các phim yêu thích
  final List<Movie> movies;

  const FavoriteMoviesLoaded({required this.movies});

  @override
  List<Object?> get props => [movies];
}

/// State khi danh sách yêu thích RỖNG (chưa có phim nào)
///
/// Khác với FavoriteMoviesLoaded (có phim)
/// State này xảy ra khi:
/// - User chưa thêm phim yêu thích nào
/// - User đã xóa hết phim yêu thích
///
/// UI sẽ hiển thị:
/// - Icon trái tim rỗng
/// - Text: "Chưa có phim yêu thích"
/// - Text phụ: "Hãy thêm phim bạn thích vào đây!"
/// - Có thể có nút "Khám phá phim" dẫn về HomePage
class FavoriteMoviesEmpty extends FavoriteMoviesState {
  const FavoriteMoviesEmpty();
}

/// State khi CÓ LỖI xảy ra
///
/// Có thể do:
/// - Lỗi đọc/ghi database local
/// - Storage đầy
///
/// UI sẽ hiển thị:
/// - Icon lỗi
/// - Message lỗi
/// - Nút "Thử lại"
class FavoriteMoviesError extends FavoriteMoviesState {
  /// Thông báo lỗi chi tiết
  final String errorMessage;

  const FavoriteMoviesError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

/// State đặc biệt: Khi THÊM phim thành công
///
/// Mục đích:
/// - Để UI biết và hiển thị SnackBar: "Đã thêm vào yêu thích"
/// - Sau đó tự động chuyển sang FavoriteMoviesLoaded
///
/// Lưu ý: Đây là state TẠM THỜI, chỉ emit 1 lần
/// để trigger UI action (show snackbar), sau đó emit Loaded ngay
class FavoriteMovieAdded extends FavoriteMoviesState {
  ///Phim vừa được thêm
  final Movie movie;

  /// Danh sách yêu thích hiện tại(sau khi thêm)
  final List<Movie> currentFavorites;
  const FavoriteMovieAdded({
    required this.movie,
    required this.currentFavorites,
  }); 

  @override 
  List<Object?> get props => [movie, currentFavorites];
}

/// State đặc biệt: Khi XÓA phim thành công
///
/// Mục đích:
/// - Để UI biết và hiển thị SnackBar: "Đã xóa khỏi yêu thích"
/// - Có thể có nút "Hoàn tác" trong snackbar
/// - Sau đó tự động chuyển sang FavoriteMoviesLoaded hoặc Empty
///
/// Lưu ý: State TẠM THỜI, emit để trigger UI action
class FavoriteMovieRemoved extends FavoriteMoviesState {
  /// ID phim vừa bị xóa
  final int movieId;

  /// Danh sách yêu thích hiện tại (sau khi xóa)
  final List<Movie> currentFavorites;

  const FavoriteMovieRemoved({
    required this.movieId,
    required this.currentFavorites,
  });

  @override
  List<Object?> get props => [movieId, currentFavorites];
}