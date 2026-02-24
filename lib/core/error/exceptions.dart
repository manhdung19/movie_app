class ServerException implements Exception {
  final String message;

  ServerException({this.message = "Đã xảy ra lỗi kết nối với máy chủ"});
  @override
  String toString() => "ServerException: $message";
}
/// Bắn ra khi có lỗi liên quan đến Database local (Dùng cho phần Yêu thích sau này)
class CacheException implements Exception {
  final String message;

  CacheException({this.message = "Đã xảy ra lỗi khi đọc/ghi bộ nhớ tạm."});
  
  @override
  String toString() => "CacheException: $message";
}

