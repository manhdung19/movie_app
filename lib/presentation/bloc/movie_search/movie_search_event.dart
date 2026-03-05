import 'package:equatable/equatable.dart';

/// Abstract class đại diện cho tất cả các sự kiện (Event)
/// mà MovieSearchBloc có thể nhận từ UI tìm kiếm
///
/// Sử dụng Equatable để so sánh events, tránh xử lý trùng lặp
abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event được trigger khi người dùng NHẬP từ khóa vào ô tìm kiếm
///
/// Được gọi mỗi khi:
/// - User gõ thêm/xóa ký tự trong TextField
/// - Bloc sẽ tự động debounce (chờ 500ms) trước khi search thật
///
/// Ví dụ:nhưn
/// User gõ "spider" → Bloc nhận 6 events:
/// "s" → "sp" → "spi" → "spid" → "spide" → "spider"
/// Nhưng chỉ search 1 lần sau khi user ngừng gõ 500ms
class SearchMovies extends MovieSearchEvent {
  final String query;
  const SearchMovies(this.query);
  @override 
  List<Object?> get props => [query];
}

/// Event được trigger khi người dùng XÓA nội dung tìm kiếm
///
/// Được gọi khi:
/// - User bấm nút "X" trên ô tìm kiếm
/// - User xóa hết text trong TextField
/// Kết quả: Reset về state ban đầu (MovieSearchInitial)
class ClearSearch extends MovieSearchEvent {
  const ClearSearch();
}