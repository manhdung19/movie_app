import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import '../../../domain/entities/movie_entity.dart';

/// Abstract class đại diện cho tất cả các sự kiện (Event)
/// mà FavoriteMoviesBloc có thể nhận từ UI
/// Sử dụng Equatable để so sánh events, tránh xử lý trùng lặp
abstract class FavoriteMoviesEvent extends Equatable{
  const FavoriteMoviesEvent();
  @override 
  List<Object?> get props => [];
}

/// Event được trigger khi người dùng MỞ màn hình Favorites
/// để load danh sách phim yêu thích từ database local
///
/// Được gọi khi:
/// - User vào tab/page "Yêu thích"
/// - Cần refresh lại danh sách sau khi thêm/xóa phim
/// Kết quả: Emit FavoriteMoviesLoaded hoặc FavoriteMoviesEmpty
class LoadFavoriteMovies extends FavoriteMoviesEvent{
  const LoadFavoriteMovies();
}

/// Event được trigger khi người dùng THÊM phim vào danh sách yêu thích
/// Được gọi khi:
/// - User bấm icon trái tim ở movie card
/// - User bấm nút "Thêm vào yêu thích" ở màn hình chi tiết
/// Flow:
/// 1. Gọi SaveFavoriteMovie use case để lưu vào DB
/// 2. Nếu thành công → Emit FavoriteMovieAdded (để show snackbar)
/// 3. Tự động reload danh sách (dispatch LoadFavoriteMovies)
class AddFavoriteMovie extends FavoriteMoviesEvent {
  ///Object Movie cần thêm vào yêu thích
  ///Bao gồm đầy đủ thông tin: id, title
  final Movie movie;
  const AddFavoriteMovie(this.movie);

  @override
  List<Object?> get props => [movie];
}

/// Event được trigger khi người dùng XÓA phim khỏi danh sách yêu thích
///
/// Được gọi khi:
/// - User bấm icon trái tim đã được fill (bỏ yêu thích)
/// - User swipe để xóa trong màn hình Favorites
/// - User bấm nút "Xóa khỏi yêu thích"
///
/// Flow:
/// 1. Gọi DeleteFavoriteMovie use case
/// 2. Nếu thành công → Emit FavoriteMovieRemoved
/// 3. Tự động reload danh sách
class RemoveFavoriteMovie extends FavoriteMoviesEvent{
  ///ID của phim cần xóa 
  ///Chỉ cần ID là đủ để xóa trong database 
  final int movieId;
  const RemoveFavoriteMovie(this.movieId);
  @override 
  List<Object?> get props => [movieId];
}

/// Event để TOGGLE trạng thái yêu thích
/// (Thêm nếu chưa có, Xóa nếu đã có)
///
/// Tiện lợi khi:
/// - User bấm icon trái tim mà không biết trạng thái hiện tại
/// - Bloc sẽ tự động check và thực hiện hành động phù hợp
///
/// OPTIONAL: Có thể không dùng, thay vào đó UI tự check và dispatch
/// AddFavoriteMovie hoặc RemoveFavoriteMovie
class ToggleFavoriteMovie extends FavoriteMoviesEvent{
  ///Object Movie để toggle 
  final Movie movie;
  /// Flag cho biết phim hiện tại có đang là favorite không
  /// true = đang favorite → sẽ xóa
  /// false = chưa favorite → sẽ thêm
  final bool isFavorite;
  const ToggleFavoriteMovie({
    required this.movie,
    required this.isFavorite,
  });
  @override 
  List<Object?> get props => [movie,isFavorite];
}
 


