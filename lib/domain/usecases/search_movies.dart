import 'package:dartz/dartz.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call(String query) async {
    return await repository.searchMovies(query);
  }
}