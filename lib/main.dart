// file: main.dart
import 'package:dio/dio.dart';
import 'core/network/dio_client.dart'; // Import lớp DioClient bạn vừa tạo

// Hàm main phải là async để có thể sử dụng await
Future<void> main() async {
  // BƯỚC 1: Khởi tạo DioClient
  // Một khi đã khởi tạo, bạn có thể tái sử dụng instance này ở nhiều nơi
  final dioClient = DioClient();

  // BƯỚC 2: Định nghĩa ID của phim bạn muốn lấy thông tin
  // Ví dụ: 550 là ID của phim "Fight Club"
  final int movieId = 550;

  print('Đang tiến hành gọi API để lấy thôn g tin phim có ID: $movieId...');

  try {
    // BƯỚC 3: Thực hiện gọi API
    // Sử dụng instance dio từ dioClient để gọi phương thức GET
    // Endpoint để lấy chi tiết phim là '/movie/{movie_id}'
    // Bạn không cần truyền api_key hay language vì DioClient đã tự động thêm vào
    final Response response = await dioClient.dio.get('/movie/$movieId');

    // BƯỚC 4: Xử lý kết quả trả về
    if (response.statusCode == 200) {
      // Dio tự động giải mã JSON, nên response.data đã là một Map
      final Map<String, dynamic> movieData = response.data;

      // Lấy giá trị của 'poster_path' từ Map
      final String? posterPath = movieData['poster_path'];

      if (posterPath != null) {
        print('\n---------------- KẾT QUẢ ----------------');
        print('Lấy poster path thành công!');
        print('Poster Path: $posterPath');
        print('------------------------------------------');

        // URL đầy đủ để xem ảnh sẽ là:
        print('URL ảnh đầy đủ (ví dụ size w500): https://image.tmdb.org/t/p/w500$posterPath');
      } else {
        print('Phim này không có poster path.');
      }
    } else {
      // Xử lý các trường hợp status code không phải 200 (ví dụ: 404 Not Found)
      print('Lỗi: API trả về status code ${response.statusCode}');
    }
  } on DioException catch (e) {
    // Xử lý các lỗi liên quan đến Dio (ví dụ: timeout, không có mạng, 401, 404, 500)
    print('\nĐã xảy ra lỗi Dio:');
    print('Message: ${e.message}');
    if (e.response != null) {
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
    }
  } catch (e) {
    // Xử lý các lỗi khác không lường trước được
    print('Đã xảy ra lỗi không xác định: $e');
  }
}