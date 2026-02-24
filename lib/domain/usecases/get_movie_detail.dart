import 'package:dartz/dartz.dart';
import 'package:movie_app/domain/entities/movie_entity.dart';
import '../entities/movie_detail_entity.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class GetMovieDetail {
  final MovieRepository repository;
  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetailEntity>> call(int id) async {
    return await repository.getMovieDetail(id);
  }
}