import 'package:dartz/dartz.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class DeleteFavoriteMovie {
  final MovieRepository repository;

  DeleteFavoriteMovie(this.repository);
  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteFavoriteMovie(id);
  }
}