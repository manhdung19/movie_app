import 'package:dartz/dartz.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class IsFavoriteMovie {
  final MovieRepository repository;

  IsFavoriteMovie(this.repository);

  Future<Either<Failure, bool>> call(int id) async {
    return await repository.isFavoriteMovie(id);
  }
}