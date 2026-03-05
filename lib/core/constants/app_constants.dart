/// Các hằng số cấu hình cho app
class AppConstants {
  AppConstants._();

  // === TMDB API ===
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  
  // Image sizes từ TMDB
  static const String posterSizeW500 = 'w500';
  static const String posterSizeW342 = 'w342';
  static const String posterSizeOriginal = 'original';
  static const String backdropSizeW780 = 'w780';

  // === UI CONSTANTS ===
  static const double movieCardAspectRatio = 2 / 3;  // Poster ratio
  static const int gridCrossAxisCount = 2;            // 2 columns on mobile
  static const int gridCrossAxisCountTablet = 4;      // 4 columns on tablet
  static const double gridSpacing = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;

  // === ANIMATION ===
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);
}

/// Helper để build image URL từ TMDB
class ImageHelper {
  /// Build full poster URL
  /// 
  /// [posterPath]: Path từ API (đã có / ở đầu)
  /// [size]: w500, w342, original... (default: w500)
  static String getPosterUrl(String posterPath, {String size = AppConstants.posterSizeW500}) {
    return '${AppConstants.tmdbImageBaseUrl}/$size$posterPath';
  }

  /// Build full backdrop URL
  static String getBackdropUrl(String backdropPath, {String size = AppConstants.backdropSizeW780}) {
    return '${AppConstants.tmdbImageBaseUrl}/$size$backdropPath';
  }
}