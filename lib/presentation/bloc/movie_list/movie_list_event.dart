import 'package:equatable/equatable.dart';       

/// Abstract class đại diện cho tất cả các sự kiện (Event) 
/// mà MovieListBloc có thể nhận từ UI
/// 
/// Sử dụng Equatable để so sánh các event với nhau,
/// tránh xử lý event trùng lặp

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}


/// Event được trigger khi người dùng KÉO XUỐNG (Pull to Refresh)
/// để làm mới danh sách phim
/// 
/// Khác với FetchTrendingMovies ở chỗ:
/// - FetchTrendingMovies: Load lần đầu (có thể show loading toàn màn hình)
/// - RefreshMovies: Refresh (chỉ show loading ở trên cùng, giữ nguyên data cũ)
class FetchTrendingMovies extends MovieListEvent {
  const FetchTrendingMovies();
}

/// Event được trigger khi người dùng KÉO XUỐNG (Pull to Refresh)
/// để làm mới danh sách phim
/// 
/// Khác với FetchTrendingMovies ở chỗ:
/// - FetchTrendingMovies: Load lần đầu (có thể show loading toàn màn hình)
/// - RefreshMovies: Refresh (chỉ show loading ở trên cùng, giữ nguyên data cũ)

class RefreshMovies extends MovieListEvent {
  const RefreshMovies();
}


