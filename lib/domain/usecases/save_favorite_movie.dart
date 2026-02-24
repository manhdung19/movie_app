import 'package:dartz/dartz.dart';
import '../entities/movie_entity.dart';
import '../../core/error/failures.dart/';
import '../repositories/movie_repository.dart';

class SaveFavoriteMovie {
  final MovieRepository repository;
  SaveFavoriteMovie(this.repository);
  Future<Either<Failure, void>> call(Movie movie) async {
    return await repository.saveFavoriteMovie(movie);
  }
}