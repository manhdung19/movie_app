//lib/core/error/failures.dart

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;
  const Failure({this.message = 'Đã có lỗi xảy ra. Vui lòng thử lại.'});

  @override
  List<Object> get props => [message];
}

//ServerFailure: Đại diện cho các lỗi xảy ra khi giao tiếp với API từ xa.
class ServerFailure extends Failure{
  const ServerFailure({String message = 'Lỗi máy chủ. Vui lòng thử lại sau.'})
  : super(message: message);
}

//CacheFailure: Đại diện cho các lỗi xảy ra khi tương tác với dữ liệu local.
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Lỗi truy xuất dữ liệu cục bộ.'})
  : super(message: message);
}

//GeneralFailure: Dành cho các lỗi không xác định khác
class GeneralFailure extends Failure {
  const GeneralFailure({String message = 'Đã có lỗi không mong muốn xảy ra.'})
  : super(message : message);
}
