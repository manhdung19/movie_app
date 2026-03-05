import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/usecases/get_trending_movies.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';

/// MovieListBloc là trung tâm quản lý State cho màn hình danh sách phim
/// 
/// Nhiệm vụ:
/// 1. Nhận Event từ UI (FetchTrendingMovies, RefreshMovies)
/// 2. Gọi Use Case để lấy data (GetTrendingMovies)
/// 3. Xử lý kết quả (Success/Failure)
/// 4. Emit State tương ứng để UI cập nhật
/// 
/// Luồng hoạt động:
/// UI dispatch Event → Bloc nhận Event → Gọi Use Case 
/// → Nhận kết quả → Emit State → UI rebuild theo State mới

class MovieListBloc extends Bloc<MovieListEvent, MovieListState>{
  final GetTrendingMovies getTrendingMovies;
  MovieListBloc({
    required this.getTrendingMovies,
  }) : super(const MovieListInitial()) {
    // Đăng ký handler cho event FetchTrendingMovies
    on<FetchTrendingMovies>(_onFetchTrendingMovies);

    //Đăng kí handler cho event RefreshMovies
    on<RefreshMovies>(_onRefreshMovies);
  } 

 /// Handler xử lý event FetchTrendingMovies
  /// 
  /// Được gọi khi:
  /// - User mở màn hình lần đầu
  /// - User bấm nút "Thử lại" khi có lỗi
  /// 
  /// @param event: Event được dispatch từ UI
  /// @param emit: Function để phát (emit) state mới
Future<void> _onFetchTrendingMovies(
  FetchTrendingMovies event,
  Emitter<MovieListState> emit,
) async {
  // BƯỚC 1: Emit state Loading để UI hiển thị loading indicator
  emit(const MovieListLoading());

  // BƯỚC 2: Gọi Use Case để lấy dữ liệu từ Repository
  // getTrendingMovies() trả về Either<Failure, List<Movie>>
  // - Left: Nếu có lỗi (Failure)
  // - Right: Nếu thành công (List<Movie>)
  final Either<Failure, List<Movie>> failureOrMovies = 
      await getTrendingMovies();

  // BƯỚC 3: Xử lý kết quả bằng fold
  failureOrMovies.fold(
    //TH1: Có lỗi(Left side của Either)
    (failure){
      //Covert Failure object thành error message dễ hiểu
      final errorMessage = _mapFailureToMessage(failure);
      
      //Emit state Error với message để UI hiển thị
      emit(MovieListError(errorMessage: errorMessage));
    },
    //TH2: Thành công (Right side của Either)
    (movies) {
      // Emit state Loaded với danh sách phim để UI hiển thị
      emit(MovieListLoaded(movies: movies));
    },
  );  
}
  /// Handler xử lý event RefreshMovies
  /// 
  /// Được gọi khi:
  /// - User kéo xuống để refresh (Pull to Refresh)
  /// 
  /// Logic tương tự _onFetchTrendingMovies
  /// Có thể customize thêm (ví dụ: không hiển thị loading toàn màn hình)
  Future<void> _onRefreshMovies(
    RefreshMovies event,
    Emitter<MovieListState> emit,
  ) async {
    // Với refresh, có thể giữ nguyên data cũ và chỉ show loading nhỏ
    // Nhưng ở đây làm đơn giản: emit Loading như bình thường
    emit(const MovieListLoading());

    final Either<Failure, List<Movie>> failureOrMovies = 
      await getTrendingMovies();
    failureOrMovies.fold(
      (failure){
        final errorMessage = _mapFailureToMessage(failure);
        emit(MovieListError(errorMessage: errorMessage));
      },
      (movies){
        emit(MovieListLoaded(movies: movies));
      },
    );
  }
  /// Helper method để convert Failure object thành error message
  /// dễ hiểu cho người dùng
  /// 
  /// @param failure: Object Failure từ domain layer
  /// @return: String message phù hợp với từng loại lỗi
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      // Lỗi từ server (API error 4xx, 5xx)
      case ServerFailure:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      
      // Lỗi kết nối Internet
      // case NetworkFailure:
      //   return 'Không có kết nối Internet. Vui lòng kiểm tra lại.';
      
      // Lỗi từ database local
      case CacheFailure:
        return 'Lỗi tải dữ liệu. Vui lòng thử lại.';
      
      // Các lỗi khác chưa xác định
      default:
        return 'Đã xảy ra lỗi không mong muốn.';
    }
  }
}
  

    


  







