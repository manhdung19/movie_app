import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/usecases/search_movies.dart' as usecase; 
import 'movie_search_event.dart';
import 'movie_search_state.dart';

/// MovieSearchBloc quản lý logic tìm kiếm phim
///
/// Tính năng đặc biệt:
/// 1. DEBOUNCE: Chờ user ngừng gõ 500ms mới search (tránh spam API)
/// 2. VALIDATION: Không search nếu query < 3 ký tự
/// 3. EMPTY HANDLING: Phân biệt "không tìm thấy" vs "chưa search"
///
/// Luồng hoạt động:
/// User gõ "spider man" →
/// → Bloc nhận nhiều events: "s", "sp", "spi"...
/// → Debounce chờ 500ms sau lần gõ cuối
/// → Validate: query.length >= 3?
/// → Gọi SearchMovies use case
/// → Emit state phù hợp (Loaded/Empty/Error)

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  // Use Case để tìm kiếm phim theo từ khóa
  /// Được inject từ Dependency Injection
  final usecase.SearchMovies searchMovies;

  /// Constructor:
  /// - Nhận searchMovies use case
  /// - Khởi tạo state ban đầu là MovieSearchInitial
  /// - Đăng ký event handlers với DEBOUNCE
  MovieSearchBloc({
    required this.searchMovies,
  }) : super(const MovieSearchInitial()) {
    // Đăng ký handler cho SearchMovies event với DEBOUNCE 500ms
    // transformEvents: Áp dụng RxDart debounce trước khi xử lý event
    on<SearchMovies>(
      _onSearchMovies,
      // DEBOUNCE: Chờ 500ms sau khi user ngừng gõ mới xử lý
      transformer: debounce(const Duration(microseconds: 500)),
    );
    // Đăng ký handler cho ClearSearch event (không cần debounce)
    on<ClearSearch>(_onClearSearch);
  }

  /// Handler xử lý event SearchMovies
  ///
  /// Được gọi khi:
  /// - User nhập từ khóa vào TextField
  /// - Sau khi debounce 500ms
  ///
  /// @param event: Chứa query (từ khóa tìm kiếm)
  /// @param emit: Function để emit state mới
  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query.trim();

    //VALIDATION 1: Nếu query trống → Reset về Initial
    if  (query.isEmpty){
      emit(const MovieSearchInitial());
      return;
    }
    
    // VALIDATION 2: Nếu query < 3 ký tú → Không search (tránh kết quả quá nhiều)
    if (query.length < 3 ){
      //giữ nguyên state hiện tại (không làm gì)
      return;
    }

    // BƯỚC 1: Emit Loading để UI hiển thị loading indicator
    emit(const MovieSearchLoading());

    // BƯỚC 2: Gọi Use Case để search
    // searchMovies(query) trả về Either<Failure, List<Movie>>
    final Either<Failure, List<Movie>> failureOrMovies =
      await searchMovies(query);
      
    //Bước 3: Xử lý kết quả
    failureOrMovies.fold(
      //TH1: Có lỗi (Left)
      (failure){
        final errorMessage = _mapFailureToMessage(failure);
        emit(MovieSearchError(errorMessage: errorMessage));
      },

      //TH2: Thành công (Right)
      (movies){
        //Kiểm tra list có rổng không 
        if (movies.isEmpty){
          emit(MovieSearchEmpty(query));
        } else {
          //Tìm thấy kết quả 
          emit(MovieSearchLoaded(movies: movies, query: query));
        }
      },
    );
  }

  /// Handler xử lý event ClearSearch
  ///
  /// Được gọi khi:
  /// - User bấm nút "X" xóa ô tìm kiếm
  /// - User clear text trong TextField
  ///
  /// Kết quả: Reset về state ban đầu
  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(const MovieSearchInitial());
  }

    /// Helper method: Convert Failure → User-friendly error message
  ///
  /// @param failure: Object Failure từ domain layer
  /// @return: String message dễ hiểu cho người dùng
String _mapFailureToMessage(Failure failure){
  switch (failure.runtimeType){
    case ServerFailure:
      return 'Lỗi máy chủ. Vui lòng thử lại sau';
    case CacheFailure:
      return 'Lỗi tải dữ liệu. Vui lòng thử lại.';
    case GeneralFailure:
      return 'Đã có lỗi. Vui lòng thử lại';
    default:
      return 'Đã xảy ra lỗi không mong muốn';
  }
}

/// EventTransformer để apply debounce cho event stream
///
/// Cách hoạt động:
/// - Nhận stream các events từ UI
/// - Chỉ emit event cuối cùng sau khi user ngừng gõ {duration}
/// - Bỏ qua các events trung gian
///
/// Ví dụ với duration = 500ms:
/// User gõ: s(0ms) → p(100ms) → i(200ms) → d(300ms) → e(400ms) → r(500ms)
/// → Chỉ emit 1 event "spider" sau 1000ms (500ms sau lần gõ cuối)
EventTransformer<T> debounce<T>(Duration duration){
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
}





