import 'package:dartz/dartz.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class GetTrendingMovies{
  final MovieRepository repository;
  GetTrendingMovies(this.repository);

  // Khi gọi hàm class này như một hàm, nó sẽ thực thi phương thức này.
  Future<Either<Failure, List<Movie>>> call() async {
    return await repository.getTrendingMovie();
  }
}

