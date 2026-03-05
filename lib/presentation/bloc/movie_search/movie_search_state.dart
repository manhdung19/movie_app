import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie_entity.dart';

/// Abstract class đại diện cho tất cả các trạng thái (State)
/// mà UI tìm kiếm có thể nhận được từ MovieSearchBloc
/// Sử dụng Equatable để Flutter biết khi nào cần rebuild widget
abstract class MovieSearchState extends Equatable {
  const MovieSearchState();
  @override 
  List<Object?> get props => [];
}
/// State BAN ĐẦU khi chưa có hành động tìm kiếm nào
/// UI sẽ hiển thị:
/// - Placeholder: "Nhập tên phim để tìm kiếm..."
/// - Hoặc: Gợi ý phim phổ biến
class MovieSearchInitial extends MovieSearchState{
  const MovieSearchInitial();
}
/// State khi đang GỌI API để tìm kiếm phim
/// UI sẽ hiển thị:
/// - CircularProgressIndicator (loading indicator)
/// - Có thể giữ kết quả cũ phía dưới (nếu muốn UX mượt hơn)
class MovieSearchLoading extends MovieSearchState {
  const MovieSearchLoading();
}

/// State khi TÌM THẤY kết quả phù hợp với từ khóa
///
/// Chứa:
/// - movies: Danh sách phim tìm được
/// - query: Từ khóa đã tìm (để hiển thị "Kết quả cho: {query}")
///
/// UI sẽ hiển thị:
/// - ListView/GridView với các movie card
/// - Header: "Tìm thấy {movies.length} kết quả cho '{query}'"
class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> movies;
  final String query;
  const MovieSearchLoaded({
    required this.movies,
    required this.query,
  });
  @override 
  List<Object?> get props => [movies, query];
}

/// State khi KHÔNG TÌM THẤY kết quả nào
///
/// Khác với MovieSearchLoaded (có kết quả)
/// State này xảy ra khi:
/// - API trả về list rỗng []
/// - Từ khóa không khớp với phim nào
///
/// UI sẽ hiển thị:
/// - Icon tìm kiếm với dấu X
/// - Text: "Không tìm thấy kết quả cho '{query}'"
/// - Gợi ý: "Thử tìm với từ khóa khác"
class MovieSearchEmpty extends MovieSearchState {
  ///Từ khóa không tìm thấy kết quả
  final String query;

  const MovieSearchEmpty(this.query);
  @override
  List<Object?> get props => [query];
}




/// State khi CÓ LỖI xảy ra trong quá trình tìm kiếm
///
/// Có thể do:
/// - Mất kết nối Internet
/// - API server lỗi
/// - Timeout
///
/// UI sẽ hiển thị:
/// - Icon lỗi
/// - Message lỗi chi tiết
/// - Nút "Thử lại"
class MovieSearchError extends MovieSearchState {
  final String errorMessage;
  const MovieSearchError({required this.errorMessage});

  @override 
  List<Object?> get props => [errorMessage];
}


  

