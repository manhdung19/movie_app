import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie_entity.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();

  @override 
  List<Object?> get props =>[];
}


/// State BAN ĐẦU khi Bloc vừa được khởi tạo
/// Chưa có bất kỳ hành động nào được thực hiện
/// 
/// UI sẽ hiển thị: Màn hình trắng hoặc placeholder
class MovieListInitial extends MovieListState {
  const MovieListInitial();
}

///State khi đang gọi API để lấy danh sách phim 
///UI sẽ hiển thị 
/// /// - CircularProgressIndicator (vòng tròn xoay)
class MovieListLoading extends MovieListState {
  const MovieListLoading();
}

//State khi đã lấy được dữ liệu thành công
///UI sẽ hiển thị danh sách phim
///UI sẽ hiển thị: GridView/ListView với các movie card
class MovieListLoaded extends MovieListState {
  ///Danh sách các phim thịnh hành
  final List<Movie> movies;

  const MovieListLoaded({required this.movies});

  @override
  List<Object?> get props => [movies];
  }

  /// State khi CÓ LỖI xảy ra trong quá trình lấy dữ liệu
/// Có thể do:
/// - Mất kết nối Internet
/// - API server lỗi (500, 404...)
/// - Timeout
/// 
/// UI sẽ hiển thị:
/// - Icon lỗi
/// - Message lỗi (từ errorMessage)
/// - Nút "Thử lại" để retry
class MovieListError extends MovieListState {
  final String errorMessage;
  const MovieListError({required this.errorMessage});   
}









