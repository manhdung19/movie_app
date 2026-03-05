/// Định nghĩa tất cả text strings trong app
/// Giúp dễ internationalization (i18n) sau này
class AppStrings {
  AppStrings._();

  // === APP GENERAL ===
  static const String appName = 'Movie Explorer';
  static const String appTagline = 'Discover & Save Your Favorites';

  // === HOME PAGE ===
  static const String homeTitle = 'Discover Amazing Movies';
  static const String homeSubtitle = 'Browse through our collection and save your favorites';
  static const String searchHint = 'Search movies by title or genre...';
  
  // === NAVIGATION ===
  static const String navBrowse = 'Browse';
  static const String navFavorites = 'Favorites';

  // === SORT OPTIONS ===
  static const String sortByRating = 'Sort by Rating';
  static const String sortByYear = 'Sort by Year';
  static const String sortByTitle = 'Sort by Title';

  // === ERROR MESSAGES ===
  static const String errorGeneral = 'Something went wrong';
  static const String errorNetwork = 'No internet connection';
  static const String errorServer = 'Server error. Please try again later.';
  static const String retryButton = 'Try Again';

  // === EMPTY STATES ===
  static const String emptyFavorites = 'No favorite movies yet';
  static const String emptySearch = 'No results found';

  // === LOADING ===
  static const String loading = 'Loading...';
}