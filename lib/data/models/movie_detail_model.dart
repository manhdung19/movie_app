import '../../domain/entities/movie_detail_entity.dart';
import 'genre_model.dart';

class MovieDetailModel extends MovieDetailEntity {
  const MovieDetailModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.releaseDate,
    required super.voteAverage,
    required super.runtime,
    required List<GenreModel> super.genres,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      runtime: json['runtime'] ?? 0,
      // Xu li danh sach the loai
      genres: json['genres'] != null
          ? List<GenreModel>.from(
              (json['genres'] as List).map((x) => GenreModel.fromJson(x)),
              )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'runtime': runtime,
      'genres': (genres as List<GenreModel>).map((x) => x.toJson()).toList(),
    };
  }

}