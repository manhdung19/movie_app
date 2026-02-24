import '../../domain/entities/movie_entity.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.backdropPath,
    required super.overview,
    required super.releaseDate,
    required super.voteAverage,
  });
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      // Xử lí trường hợp API trả về null cho hình ảnh poster
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      // Ép kiểu double cho voteAverage
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
    );
  }

}
  