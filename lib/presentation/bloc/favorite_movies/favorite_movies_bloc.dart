import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/usecases/get_favorite_movies.dart';
import '../../../domain/usecases/save_favorite_movie.dart';
import '../../../domain/usecases/delete_favorite_movie.dart';
import 'favorite_movies_event.dart';
import 'favorite_movies_state.dart';

/// FavoriteMoviesBloc quản lý logic cho màn hình phim yêu thích
///
/// Nhiệm vụ:
/// 1. Load danh sách phim yêu thích từ database local
/// 2. Thêm phim vào yêu thích
/// 3. Xóa phim khỏi yêu thích
/// 4. Sync state giữa các màn hình (khi thêm/xóa từ màn hình khác)
///
/// Tính năng đặc biệt:
/// - Auto-reload sau khi thêm/xóa
/// - Emit temporary state (Added/Removed) để show snackbar
/// - Handle empty state riêng biệt
///
/// Luồng hoạt động:
/// UI dispatch Event (Load/Add/Remove)
/// → Bloc gọi Use Case tương ứng
/// → Xử lý kết quả
/// → Emit State mới
/// → UI rebuild và có thể show snackbar
class FavoriteMoviesBloc
    extends Bloc<FavoriteMoviesEvent, FavoriteMoviesState> {
  ///Use case để lấy danh sách phim yêu thích
  final GetFavoriteMovies getFavoriteMovies;
  //Use case để thêm phim vào yêu thích
  final SaveFavoriteMovie saveFavoriteMovie;
  //Use case để xóa phim khỏi yêu thích
  final DeleteFavoriteMovie deleteFavoriteMovie;

  /// Constructor:
  /// - Nhận 3 use cases qua parameter (Dependency Injection)
  /// - Khởi tạo state ban đầu là FavoriteMoviesInitial
  /// - Đăng ký các event handler
  FavoriteMoviesBloc({
    required this.getFavoriteMovies,
    required this.saveFavoriteMovie,
    required this.deleteFavoriteMovie,
  }) : super(const FavoriteMoviesInitial()) {
    // Đăng ký handler cho event LoadFavoriteMovies
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);

    // Đăng ký handler cho event AddFavoriteMovie
    on<AddFavoriteMovie>(_onAddFavoriteMovie);

    // Đăng ký handler cho event RemoveFavoriteMovie
    on<RemoveFavoriteMovie>(_onRemoveFavoriteMovie);

    // Đăng ký handler cho event ToggleFavoriteMovie
    on<ToggleFavoriteMovie>(_onToggleFavoriteMovie);
  }

  /// Handler xử lý event LoadFavoriteMovies
  ///
  /// Được gọi khi:
  /// - User vào màn hình Favorites
  /// - Sau khi thêm/xóa phim (để refresh list)
  ///
  /// @param event: LoadFavoriteMovies event
  /// @param emit: Function để emit state mới
  Future<void> _onLoadFavoriteMovies(
    LoadFavoriteMovies event,
    Emitter<FavoriteMoviesState> emit,
  ) async {
    //Load UI
    emit(const FavoriteMoviesLoading());

    // BƯỚC 2: Gọi Use Case để lấy danh sách từ database local
    // getFavoriteMovies() không cần params
    // Trả về Either<Failure, List<Movie>>
    final Either<Failure, List<Movie>> failureOrMovies =
        await getFavoriteMovies();

    //Bước 3: Xử lí kết quả
    failureOrMovies.fold(
      (failure) {
        final errorMessage = _mapFailureToMessage(failure);
        emit(FavoriteMoviesError(errorMessage: errorMessage));
      },
      //TH2: thành công(Right)
      (movies) {
        //Kiểm tra danh sách có rổng không
        if (movies.isEmpty) {
          //Danh sách rỗng -> Emit Empty state
          emit(const FavoriteMoviesEmpty());
        } else {
          // Có phim → Emit Loaded state với danh sách
          emit(FavoriteMoviesLoaded(movies: movies));
        }
      },
    );
  }

  /// Handler xử lý event AddFavoriteMovie
  ///
  /// Được gọi khi:
  /// - User bấm icon trái tim để thêm vào yêu thích
  ///
  /// Flow:
  /// 1. Gọi SaveFavoriteMovie use case
  /// 2. Nếu thành công → Emit FavoriteMovieAdded (để show snackbar)
  /// 3. Tự động reload danh sách
  ///
  /// @param event: AddFavoriteMovie event (chứa Movie object)
  /// @param emit: Function để emit state mới
  Future<void> _onAddFavoriteMovie(
    AddFavoriteMovie event,
    Emitter<FavoriteMoviesState> emit,
  ) async {
    // BƯỚC 1: Gọi Use Case để lưu phim vào database
    // saveFavoriteMovie(movie) trả về Either<Failure, void>
    final Either<Failure, void> failureOrSuccess = await saveFavoriteMovie(
      event.movie,
    );

    // BƯỚC 2: Xử lý kết quả
    await failureOrSuccess.fold(
      // TH1: Có lỗi (Left)
      (failure) async {
        final errorMessage = _mapFailureToMessage(failure);
        emit(FavoriteMoviesError(errorMessage: errorMessage));
      },

      // TH2: Thành công (Right)
      (_) async {
        // BƯỚC 2.1: Load lại danh sách yêu thích để lấy data mới nhất
        final Either<Failure, List<Movie>> updatedFavorites =
            await getFavoriteMovies();
        updatedFavorites.fold(
          // Nếu load lại bị lỗi → emit Error
          (failure) {
            final errorMessage = _mapFailureToMessage(failure);
            emit(FavoriteMoviesError(errorMessage: errorMessage));
          },

          // Nếu load lại thành công → emit Added state TẠM THỜI
          (movies) {
            // Emit state Added để UI show snackbar "Đã thêm vào yêu thích"
            emit(
              FavoriteMovieAdded(movie: event.movie, currentFavorites: movies),
            );
            // SAU ĐÓ: Emit state Loaded bình thường
            // (Hoặc UI sẽ tự động dispatch LoadFavoriteMovies)
            // emit(FavoriteMoviesLoaded(movies: movies));
          },
        );
      },
    );
  }

  /// Handler xử lý event RemoveFavoriteMovie
  ///
  /// Được gọi khi:
  /// - User bấm icon trái tim đã fill (bỏ yêu thích)
  /// - User swipe để xóa trong màn hình Favorites
  ///
  /// Flow tương tự AddFavoriteMovie
  ///
  /// @param event: RemoveFavoriteMovie event (chứa movieId)
  /// @param emit: Function để emit state mới
  Future<void> _onRemoveFavoriteMovie(
    RemoveFavoriteMovie event,
    Emitter<FavoriteMoviesState> emit,
  ) async {
    // BƯỚC 1: Gọi Use Case để xóa phim khỏi database
    // deleteFavoriteMovie(id) trả về Either<Failure, void>
    final Either<Failure, void> failureOrSuccess = await deleteFavoriteMovie(
      event.movieId,
    );
    // BƯỚC 2: Xử lý kết quả
    await failureOrSuccess.fold(
      // TH1: Có lỗi (Left)
      (failure) async {
        final errorMessage = _mapFailureToMessage(failure);
        emit(FavoriteMoviesError(errorMessage: errorMessage));
      },

      // TH2: Thành công (Right)
      (_) async {
        // BƯỚC 2.1: Load lại danh sách yêu thích
        final Either<Failure, List<Movie>> updatedFavorites =
            await getFavoriteMovies();

        updatedFavorites.fold(
          // Nếu load lại bị lỗi → emit Error
          (failure) {
            final errorMessage = _mapFailureToMessage(failure);
            emit(FavoriteMoviesError(errorMessage: errorMessage));
          },

          // Nếu load lại thành công → emit Removed state TẠM THỜI
          (movies) {
            // Emit state Removed để UI show snackbar "Đã xóa khỏi yêu thích"
            emit(
              FavoriteMovieRemoved(
                movieId: event.movieId,
                currentFavorites: movies,
              ),
            );

            // SAU ĐÓ: Kiểm tra list có rỗng không
            // Nếu rỗng → emit Empty
            // Nếu còn phim → emit Loaded
            // (Hoặc UI sẽ tự động dispatch LoadFavoriteMovies)
          },
        );
      },
    );
  }


/// Handler xử lý event ToggleFavoriteMovie
  ///
  /// Logic đơn giản:
  /// - Nếu isFavorite = true → Gọi RemoveFavoriteMovie
  /// - Nếu isFavorite = false → Gọi AddFavoriteMovie
  ///
  /// @param event: ToggleFavoriteMovie event
  /// @param emit: Function để emit state mới
  Future<void> _onToggleFavoriteMovie(
    ToggleFavoriteMovie event,
    Emitter<FavoriteMoviesState> emit,
  ) async {
    if (event.isFavorite) {
      // Đang là favorite → Xóa
      add(RemoveFavoriteMovie(event.movie.id));
    } else {
      // Chưa là favorite → Thêm
      add(AddFavoriteMovie(event.movie));
    }
  }

  // Helper method: Convert Failure → User-friendly error message
  ///
  /// @param failure: Object Failure từ domain layer
  /// @return: String message dễ hiểu cho người dùng
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      // case NetworkFailure:
      //   return 'Không có kết nối Internet. Vui lòng kiểm tra lại.';
      case CacheFailure:
        return 'Lỗi lưu trữ dữ liệu. Vui lòng kiểm tra bộ nhớ thiết bị.';
      default:
        return 'Đã xảy ra lỗi không mong muốn.';
    }
  }
}
