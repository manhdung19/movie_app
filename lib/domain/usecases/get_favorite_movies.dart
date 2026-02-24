import 'package:dartz/dartz.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class GetFavoriteMovies {
  final MovieRepository repository;

  GetFavoriteMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call() async {
    return await repository.getFavoriteMovies();
  }
}