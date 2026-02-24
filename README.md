**Bài tập số 2: Movie Explorer**.

Bài tập này tập trung vào việc xử lý dữ liệu thực tế từ Internet, quản lý bất đồng bộ và lưu trữ dữ liệu bền vững trên thiết bị.

---

# Bài tập thực hành số 2: Movie Explorer App

## 1. Mục tiêu bài tập

* **Networking:** Thành thạo việc sử dụng thư viện `Dio` để gọi API và xử lý dữ liệu JSON.
* **Asynchronous Programming:** Xử lý mượt mà các trạng thái Đang tải (Loading), Lỗi (Error), và Có dữ liệu (Data) bằng `Future` hoặc `Stream`.
* **Local Storage:** Sử dụng `Sqflite` để lưu trữ danh sách phim yêu thích xuống bộ nhớ máy.
* **Clean Code:** Tổ chức mã nguồn theo mô hình phân lớp (Data Layer, UI Layer, Model Layer).

---

## 2. Mô tả yêu cầu chức năng

Ứng dụng Movie Explorer cần hoàn thiện các chức năng trọng tâm sau:

### A. Màn hình Danh sách phim (Home Screen)

* **Gọi API:** Lấy dữ liệu danh sách phim từ một nguồn public API (Gợi ý: *The Movie Database - TMDB* hoặc một Mock API).
* **Hiển thị:** Sử dụng `GridView` hoặc `ListView` để hiển thị poster phim, tên phim và điểm đánh giá.
* **Trạng thái UI:** Hiển thị `CircularProgressIndicator` khi đang tải và thông báo lỗi kèm nút "Thử lại" nếu gọi API thất bại.

### B. Chức năng Tìm kiếm (Search)

* Cho phép người dùng nhập tên phim vào `TextField`.
* Cập nhật danh sách phim hiển thị dựa trên kết quả tìm kiếm từ API.

### C. Quản lý Phim yêu thích (Favorite System)

* **Tương tác:** Mỗi item phim có một nút "Tim" (Favorite).
* **Lưu trữ:** Khi nhấn chọn, thông tin phim phải được lưu vào cơ sở dữ liệu local (`Sqflite`).
* **Màn hình Favorite:** Một tab hoặc màn hình riêng biệt hiển thị danh sách các phim đã được lưu. Người dùng có thể xóa phim khỏi danh sách yêu thích tại đây.

---

## 3. Yêu cầu kỹ thuật chi tiết

| Thành phần | Yêu cầu cụ thể |
| --- | --- |
| **Model** | Tạo class `Movie` với các hàm `fromJson` và `toJson` (Serialization). |
| **Networking** | Khởi tạo một `DioClient` duy nhất (Singleton) để quản lý các request. |
| **Database** | Viết một `DatabaseHelper` để quản lý các câu lệnh SQL (Create, Insert, Query, Delete). |
| **State Management** | Khuyến khích sử dụng `Provider` hoặc `Cubit/Bloc` để tách biệt logic xử lý dữ liệu khỏi giao diện. |

---

## 4. Các bước thực hiện gợi ý

1. **Tuần 5:** Định nghĩa Model `Movie`. Cấu hình `Dio` và viết hàm gọi API lấy danh sách phim.
2. **Tuần 6:** Xây dựng UI cho màn hình chính. Xử lý logic hiển thị Loading/Error bằng `FutureBuilder`.
3. **Tuần 7:** Cấu hình `Sqflite`. Viết các hàm thêm/xóa/đọc phim yêu thích từ Database.
4. **Tuần 8:** Hoàn thiện tính năng tìm kiếm và tối ưu hóa giao diện (Mini Project 2).

## 5. Tiêu chí nghiệm thu

* Ứng dụng không bị "đơ" (crash) khi không có mạng (phải có thông báo lỗi).
* Dữ liệu phim yêu thích vẫn còn tồn tại sau khi tắt app và mở lại (đã lưu vào Database thành công).
* Code được chia thành các thư mục rõ ràng: `models/`, `services/`, `views/`, `widgets/`.

---

# Cấu trúc thư mục dự án: Movie Explorer App
```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart  # Định nghĩa các Exception (e.g., ServerException)
│   │   └── failures.dart    # Định nghĩa các Failure (e.g., ServerFailure)
│   ├── network/
│   │   └── network_info.dart # Kiểm tra kết nối mạng
│   └── usecases/
│       └── usecase.dart     # Lớp UseCase cơ sở
│
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   └── movie_local_data_source.dart # Triển khai DatabaseHelper với Sqflite
│   │   └── remote/
│   │       └── movie_remote_data_source.dart #     Triển khai DioClient để gọi API
│   ├── models/
│   │   └── movie_model.dart   # Class Movie với fromJson/toJson, kế thừa Movie Entity
│   └── repositories/
│       └── movie_repository_impl.dart # Triển khai MovieRepository
│
├── domain/
│   ├── entities/
│   │   └── movie.dart         # Đối tượng Movie thuần túy (POJO)
│   ├── repositories/
│   │   └── movie_repository.dart # Định nghĩa (abstract) các phương thức
│   └── usecases/
│       ├── get_trending_movies.dart
│       ├── search_movies.dart
│       ├── get_favorite_movies.dart
│       ├── save_favorite_movie.dart
│       └── remove_favorite_movie.dart
│
└── presentation/
    ├── bloc
    │   ├── movie_list/
    │   │   ├── movie_list_bloc.dart
    │   │   ├── movie_list_event.dart
    │   │   └── movie_list_state.dart
    │   ├── movie_search/
    │   │   └── ... (tương tự)
    │   └── favorite_movies/
    │       └── ... (tương tự)
    ├── pages/
    │   ├── home_page.dart       # Màn hình chính hiển thị danh sách phim
    │   └── search_page.dart     # Màn hình tìm kiếm
    │   └── favorites_page.dart  # Màn hình phim yêu thích
    └── widgets/
        ├── movie_card.dart      # Widget hiển thị một phim
        ├── loading_widget.dart  # Widget hiển thị CircularProgressIndicator
        └── error_display.dart   # Widget hiển thị lỗi và nút "Thử lại"
│
└── injection_container.dart     # Cấu hình Dependency Injection (e.g., get_it)
└── main.dart
```

# Lộ trình phát triển dự án "Movie Explorer" trong 4 tuần

Kế hoạch này được thiết kế để xây dựng ứng dụng theo phương pháp Clean Architecture, tập trung vào việc xây dựng nền tảng vững chắc từ trong ra ngoài (Domain -> Data -> Presentation).

---

### Tuần 1: Xây dựng Nền tảng và Lớp Domain (Trái tim của ứng dụng)

**Mục tiêu:** Định hình cấu trúc dự án và logic nghiệp vụ cốt lõi. Lớp Domain không phụ thuộc vào bất kỳ lớp nào khác, vì vậy chúng ta sẽ xây dựng nó trước tiên.

-   [ ] **Thiết lập dự án:**
    -   [ ] Tạo dự án Flutter mới.
    -   [ ] Tạo toàn bộ cấu trúc thư mục: `core`, `data`, `domain`, `presentation`.
    -   [ ] Thêm các thư viện cần thiết vào `pubspec.yaml`: `get_it`, `dartz`, `equatable`, `dio`, `sqflite`, `path_provider`, `flutter_bloc`.

-   [ ] **Xây dựng Lớp Domain:**
    -   [ ] **Entities:** Tạo file `domain/entities/movie.dart`. Đây là một class Dart đơn giản, chỉ chứa các thuộc tính của phim (`id`, `title`, `posterPath`, `overview`...) và không có hàm `fromJson`/`toJson`.
    -   [ ] **Repositories (Abstract):** Tạo file `domain/repositories/movie_repository.dart`. Đây là một `abstract class` (bản hợp đồng) định nghĩa các chức năng ứng dụng CẦN có.
        ```dart
        // domain/repositories/movie_repository.dart
        abstract class MovieRepository {
          Future<Either<Failure, List<Movie>>> getTrendingMovies();
          Future<Either<Failure, List<Movie>>> searchMovies(String query);
          // ... các hàm cho tính năng yêu thích sẽ thêm sau
        }
        ```
    -   [ ] **Use Cases:** Tạo use case đầu tiên `domain/usecases/get_trending_movies.dart`. Class này sẽ nhận `MovieRepository` vào và có một hàm `call()` để thực thi logic.

-   [ ] **Thiết lập Core:**
    -   [ ] Trong `core/error/`, định nghĩa các lớp `Failure` và `Exception` để xử lý lỗi một cách nhất quán.
    -   [ ] Thiết lập file `injection_container.dart` (Service Locator) và cấu hình `get_it` ban đầu.

**✅ Kết quả cuối tuần 1:** Bạn đã có bộ xương của ứng dụng. Lớp Domain đã hoàn chỉnh, định nghĩa rõ ràng những gì ứng dụng có thể làm, sẵn sàng cho việc triển khai lớp Data.
### **Kế hoạch chi tiết Tuần 1: Xây dựng Nền tảng và Lớp Domain**

**Mục tiêu tuần:** Hoàn thành việc thiết lập cấu trúc dự án theo Clean Architecture và định nghĩa toàn bộ lớp Domain (Entities, Repositories, Use Cases).

---

#### **Ngày 1: Khởi tạo và Định hình Cấu trúc Dự án**

*Mục tiêu:* Tạo ra "bộ khung" cho toàn bộ dự án.

- [ ] **Khởi tạo dự án Flutter:**
    - [ ] Chạy lệnh `flutter create movie_explorer` để tạo dự án mới.
- [ ] **Khởi tạo Git:**
    - [ ] Chạy `git init` trong thư mục dự án.
    - [ ] Tạo commit đầu tiên để lưu trạng thái ban đầu.
- [ ] **Thiết kế cấu trúc thư mục:**
    - [ ] Trong thư mục `lib`, tạo 3 thư mục chính:
        - `domain`: Chứa logic nghiệp vụ cốt lõi.
        - `data`: Chứa phần triển khai lấy dữ liệu (API, database).
        - `presentation`: Chứa UI và logic hiển thị (Widgets, Blocs...).
- [ ] **Thêm các thư viện cần thiết:**
    - [ ] Mở file `pubspec.yaml` và thêm các thư viện sau vào `dependencies`:
        - `equatable`: Để so sánh các đối tượng.
        - `dartz`: Để xử lý lỗi và kết quả trả về.
        - `get_it` & `injectable`: Dành cho Dependency Injection.
        - `dio`: Để gọi API.
        - `sqflite`: Để lưu trữ dữ liệu local.
        - `flutter_bloc`: Để quản lý state.

---

#### **Ngày 2: Định nghĩa Entities (Các thực thể nghiệp vụ)**

*Mục tiêu:* Xác định các đối tượng dữ liệu cốt lõi của ứng dụng.

- [ ] **Phân tích và định nghĩa Entity `Movie`:**
    - [ ] Liệt kê tất cả các thuộc tính cần thiết: `id`, `title`, `overview`, `posterPath`, `backdropPath`, `releaseDate`, `voteAverage`.
- [ ] **Tạo file cho Entity:**
    - [ ] Trong thư mục `lib/domain`, tạo thư mục con `entities`.
    - [ ] Tạo file `movie_entity.dart` và định nghĩa lớp `MovieEntity` với các thuộc tính đã liệt kê (chưa cần viết hàm, chỉ định nghĩa lớp và các trường dữ liệu).
- [ ] **Suy nghĩ về các Entities khác (nếu có):**
    - [ ] Lên danh sách các thực thể khác có thể cần đến, ví dụ: `MovieDetailEntity` (chi tiết phim), `GenreEntity` (thể loại phim).

---

#### **Ngày 3: Định nghĩa Repository Interfaces (Hợp đồng dữ liệu)**

*Mục tiêu:* Định nghĩa các "hợp đồng" quy định những gì ứng dụng có thể làm với dữ liệu, mà không cần quan tâm dữ liệu đó đến từ đâu.

- [ ] **Xác định các hành động liên quan đến phim:**
    - [ ] Lấy danh sách phim thịnh hành (Trending).
    - [ ] Lấy danh sách phim phổ biến (Popular).
    - [ ] Tìm kiếm phim theo từ khóa.
    - [ ] Lấy thông tin chi tiết của một bộ phim.
- [ ] **Tạo Repository Interface:**
    - [ ] Trong `lib/domain`, tạo thư mục con `repositories`.
    - [ ] Tạo file `movie_repository.dart`.
- [ ] **Định nghĩa lớp trừu tượng `MovieRepository`:**
    - [ ] Bên trong file, tạo `abstract class MovieRepository`.
    - [ ] Định nghĩa các phương thức trừu tượng tương ứng với các hành động trên. Ví dụ:
      ```dart
      Future<Either<Failure, List<MovieEntity>>> getTrendingMovies();
      Future<Either<Failure, List<MovieEntity>>> searchMovies(String query);
      Future<Either<Failure, MovieDetailEntity>> getMovieDetail(int id);
      ```
- [ ] **Định nghĩa lớp `Failure`:**
    - [ ] Tạo một lớp trừu tượng `Failure` để xử lý lỗi chung cho toàn ứng dụng (ví dụ: `ServerFailure`, `CacheFailure`).

---

#### **Ngày 4: Định nghĩa Use Cases (Các trường hợp sử dụng)**

*Mục tiêu:* Đóng gói từng logic nghiệp vụ cụ thể thành các lớp riêng biệt.

- [ ] **Tạo thư mục Use Cases:**
    - [ ] Trong `lib/domain`, tạo thư mục con `usecases`.
- [ ] **Tạo Use Case cho từng hành động:**
    - [ ] Với mỗi phương thức trong `MovieRepository`, tạo một file Use Case tương ứng.
    - [ ] **Ví dụ 1: `get_trending_movies.dart`**:
        - Tạo lớp `GetTrendingMovies`.
        - Lớp này nhận `MovieRepository` làm tham số đầu vào (dependency).
        - Có một phương thức `call()` hoặc `execute()` để gọi đến `repository.getTrendingMovies()`.
    - [ ] **Ví dụ 2: `search_movies.dart`**:
        - Tạo lớp `SearchMovies`.
        - Lớp này nhận `MovieRepository` làm tham số đầu vào.
        - Có một phương thức `call(String query)` để gọi đến `repository.searchMovies(query)`.
    - [ ] Làm tương tự cho các hành động còn lại.

---

#### **Ngày 5: Tổng kết, Rà soát và Lập kế hoạch cho Tuần 2**

*Mục tiêu:* Đảm bảo mọi thứ đã được định nghĩa trong tuần 1 là nhất quán, hợp lý và sẵn sàng cho việc triển khai.

- [ ] **Rà soát toàn bộ lớp Domain:**
    - [ ] Kiểm tra lại cấu trúc thư mục: `entities`, `repositories`, `usecases`.
    - [ ] Kiểm tra lại tên các lớp, các phương thức đã rõ ràng và nhất quán chưa?
    - [ ] Đảm bảo lớp Domain hoàn toàn không có sự phụ thuộc nào vào thư viện của Flutter (không có `import 'package:flutter/...'`).
- [ ] **Viết tài liệu cơ bản:**
    - [ ] Thêm các comment giải thích ngắn gọn mục đích của từng Entity, Repository và Use Case.
- [ ] **Commit lên Git:**
    - [ ] Lưu lại toàn bộ thành quả của tuần 1 với một commit message rõ ràng, ví dụ: `feat: setup project structure and define domain layer`.
- [ ] **Lập kế hoạch sơ bộ cho Tuần 2:**
    - [ ] Phác thảo các công việc cần làm cho Tuần 2 (Triển khai lớp Data: Models, Data Sources, Repository Implementation).






---

### Tuần 2: Triển khai Lớp Data (Kết nối với API)

**Mục tiêu:** Hiện thực hóa "bản hợp đồng" đã định nghĩa ở lớp Domain bằng cách lấy dữ liệu thực tế từ API của The Movie Database.

-   [ ] **Models:**
    -   [ ] Tạo file `data/models/movie_model.dart`.
    -   [ ] Class `MovieModel` này sẽ `extends Movie` (từ entity) và triển khai các hàm `fromJson`, `toJson` được yêu cầu trong `README`.

-   [ ] **Data Sources (Remote):**
    -   [ ] Tạo file `data/datasources/remote/movie_remote_data_source.dart`.
    -   [ ] Trong file này, triển khai `DioClient` dưới dạng Singleton để quản lý các request API.
    -   [ ] Viết hàm `getTrendingMovies()` để gọi API, nhận dữ liệu JSON và parse nó thành một danh sách `List<MovieModel>`. Xử lý các lỗi HTTP và ném ra `ServerException` nếu có.

-   [ ] **Repositories (Implementation):**
    -   [ ] Tạo file `data/repositories/movie_repository_impl.dart`.
    -   [ ] Class `MovieRepositoryImpl` này sẽ `implements MovieRepository` từ Domain.
    -   [ ] Nó sẽ gọi đến `MovieRemoteDataSource` để lấy dữ liệu. Bọc các cuộc gọi API trong khối `try-catch` để bắt `ServerException` và trả về `ServerFailure`.

-   [ ] **Cập nhật Dependency Injection:**
    -   [ ] Trong `injection_container.dart`, đăng ký `DioClient`, `MovieRemoteDataSource`, và `MovieRepositoryImpl` để ứng dụng có thể sử dụng chúng.

**✅ Kết quả cuối tuần 2:** Luồng dữ liệu từ API đã hoàn chỉnh. Bạn có thể gọi use case `GetTrendingMovies` và nó sẽ trả về dữ liệu phim thật hoặc một `Failure` nếu có lỗi.

# Kế hoạch hành động Tuần 2: Triển khai Lớp Data

Mục tiêu chính của tuần này là xây dựng cây cầu vững chắc giữa "yêu cầu nghiệp vụ" (Domain) và "dữ liệu thực tế" (API).

## Phần 1: Triển khai Models - "Người phiên dịch"

### Việc 1: Tạo file `movie_model.dart`
- **Hành động:** Trong thư mục `lib/data/models/`, tạo một file mới tên là `movie_model.dart`.

### Việc 2: Định nghĩa lớp `MovieModel`
- **Hành động:** Bên trong file vừa tạo, định nghĩa class `MovieModel`.
- **Yêu cầu:**
  - Class này phải kế thừa (extends) từ Movie entity mà bạn đã tạo ở lớp Domain.
  - Thêm các hàm factory `fromJson` để chuyển đổi dữ liệu JSON từ API thành một đối tượng `MovieModel`.
  - Thêm hàm `toJson` để chuyển đổi đối tượng `MovieModel` thành dạng JSON (hữu ích cho việc gửi dữ liệu đi sau này).
- **Mục đích:** Lớp này sẽ là bản đồ chi tiết, chỉ cho ứng dụng biết cách đọc dữ liệu JSON thô từ API và biến nó thành một đối tượng Movie mà ứng dụng có thể hiểu được.

## Phần 2: Triển khai Data Sources - "Người đi lấy dữ liệu"

### Việc 3: Tạo file `movie_remote_data_source.dart`
- **Hành động:** Trong thư mục `lib/data/datasources/remote/`, tạo file `movie_remote_data_source.dart`.

### Việc 4: Triển khai DioClient (hoặc HTTP Client)
- **Hành động:** Trong file trên, bạn sẽ thiết lập một client để gọi API. Sử dụng Dio là một lựa chọn phổ biến.
- **Yêu cầu:** Cấu hình nó dưới dạng Singleton để đảm bảo toàn bộ ứng dụng chỉ sử dụng một instance duy nhất, giúp quản lý kết nối, headers, và interceptors một cách tập trung.

### Việc 5: Viết hàm `getTrendingMovies()`
- **Hành động:** Tạo một lớp `MovieRemoteDataSourceImpl` để triển khai logic gọi API.
- **Yêu cầu:**
  - Viết một hàm `Future<List<MovieModel>> getTrendingMovies()`.
  - Bên trong hàm này, dùng DioClient đã tạo để gửi một GET request đến endpoint phim thịnh hành của The Movie Database.
  - Nếu request thành công (status code 200), lấy phần `results` từ JSON response, duyệt qua từng phần tử và dùng `MovieModel.fromJson` để tạo ra một danh sách `List<MovieModel>`.
  - Nếu có bất kỳ lỗi nào từ phía server (status code 4xx, 5xx), ném ra một `ServerException`.
- **Mục đích:** Đây là lớp duy nhất trong ứng dụng thực sự "nói chuyện" với API qua Internet.

## Phần 3: Triển khai Repositories - "Bếp trưởng"

### Việc 6: Tạo file `movie_repository_impl.dart`
- **Hành động:** Trong thư mục `lib/data/repositories/`, tạo file `movie_repository_impl.dart`.

### Việc 7: Định nghĩa lớp `MovieRepositoryImpl`
- **Hành động:** Bên trong file, định nghĩa class `MovieRepositoryImpl`.
- **Yêu cầu:**
  - Class này phải triển khai (implements) `MovieRepository` (lớp trừu tượng từ Domain). Điều này ép nó phải cung cấp một hàm `getTrendingMovies` đúng như "hợp đồng".
  - Nó sẽ nhận một instance của `MovieRemoteDataSource` thông qua constructor.

### Việc 8: Hiện thực hóa hàm `getTrendingMovies()`
- **Hành động:** Ghi đè (override) hàm `getTrendingMovies`.
- **Yêu cầu:**
  - Bọc lệnh gọi `remoteDataSource.getTrendingMovies()` trong một khối try-catch.
  - Trong khối try: Nếu lệnh gọi thành công và trả về danh sách phim, hãy trả về `Right(movies)`.
  - Trong khối catch: Nếu `remoteDataSource` ném ra `ServerException`, hãy bắt nó và trả về `Left(ServerFailure())`.
- **Mục đích:** Lớp này đóng vai trò điều phối viên, quyết định lấy dữ liệu từ đâu (hiện tại là từ remote) và chuyển đổi các lỗi kỹ thuật (Exception) thành các lỗi nghiệp vụ (Failure) mà các lớp phía trên có thể hiểu được.

## Phần 4: Cập nhật Dependency Injection - "Người quản lý"

### Việc 9: Đăng ký các lớp vừa tạo
- **Hành động:** Mở file `injection_container.dart`.
- **Yêu cầu:**
  - Đăng ký DioClient như một singleton.
  - Đăng ký `MovieRemoteDataSource` và `MovieRemoteDataSourceImpl`, đảm bảo "tiêm" DioClient vào cho nó.
  - Đăng ký `MovieRepository` và `MovieRepositoryImpl`, đảm bảo "tiêm" `MovieRemoteDataSource` vào cho nó.
- **Mục đích:** Để ứng dụng tự động "lắp ráp" các thành phần này lại với nhau. Khi Use Case cần một `MovieRepository`, DI sẽ tự động cung cấp một `MovieRepositoryImpl` đã được cấu hình đầy đủ.

---

### Tuần 3: Xây dựng Lớp Presentation (Hiển thị lên giao diện)

**Mục tiêu:** Hiển thị danh sách phim đã lấy được ở Tuần 2 lên màn hình và xử lý các trạng thái UI (Loading, Error, Success).

-   [ ] **State Management (Bloc/Cubit):**
    -   [ ] Tạo thư mục `presentation/bloc/movie_list/`.
    -   [ ] Bên trong, tạo các file: `movie_list_bloc.dart`, `movie_list_event.dart`, `movie_list_state.dart`.
    -   [ ] `MovieListBloc` sẽ nhận `GetTrendingMovies` use case. Khi nhận được event, nó sẽ gọi use case và `emit` các state tương ứng: `Loading`, `Loaded(List<Movie>)`, `Error(String message)`.

-   [ ] **Xây dựng Giao diện (UI):**
    -   [ ] Tạo màn hình chính `presentation/pages/home_page.dart`.
    -   [ ] Sử dụng `BlocProvider` để cung cấp `MovieListBloc` cho cây widget.
    -   [ ] Sử dụng `BlocBuilder` để lắng nghe state từ Bloc và render UI tương ứng:
        -   Nếu state là `Loading`, hiển thị một `CircularProgressIndicator`.
        -   Nếu state là `Error`, hiển thị một thông báo lỗi và nút "Thử lại".
        -   Nếu state là `Loaded`, hiển thị danh sách phim bằng `GridView` hoặc `ListView`.
    -   [ ] Tạo các widget tái sử dụng như `presentation/widgets/movie_card.dart`.

-   [ ] **Cập nhật Dependency Injection:**
    -   [ ] Đăng ký `MovieListBloc` trong `injection_container.dart`.

**✅ Kết quả cuối tuần 3:** Bạn có một ứng dụng hoàn chỉnh có thể hiển thị danh sách phim thịnh hành. Giao diện người dùng có khả năng phản ứng với các trạng thái khác nhau của dữ liệu.

---

### Tuần 4: Hoàn thiện các tính năng (Tìm kiếm và Yêu thích)

**Mục tiêu:** Triển khai các tính năng còn lại là tìm kiếm và lưu phim yêu thích vào cơ sở dữ liệu cục bộ.

-   [ ] **Tính năng Yêu thích (Sử dụng Sqflite):**
    -   [ ] **Data Layer:**
        -   [ ] Tạo `data/datasources/local/movie_local_data_source.dart`.
        -   [ ] Triển khai `DatabaseHelper` (Singleton) bên trong để quản lý Sqflite (tạo bảng, insert, query, delete).
        -   [ ] Cập nhật `MovieRepositoryImpl` để nó có thể gọi cả `local_data_source`.
    -   [ ] **Domain Layer:**
        -   [ ] Thêm các use case mới: `SaveFavoriteMovie`, `RemoveFavoriteMovie`, `GetFavoriteMovies`.
        -   [ ] Cập nhật `MovieRepository` (abstract) với các phương thức tương ứng.
    -   [ ] **Presentation Layer:**
        -   [ ] Tạo một Bloc mới (`FavoriteMoviesBloc`) để quản lý trạng thái của danh sách phim yêu thích.
        -   [ ] Tạo màn hình `FavoritesPage`.
        -   [ ] Thêm nút "yêu thích" vào `MovieCard` để gọi đến Bloc, từ đó thực thi các use case lưu/xóa.

-   [ ] **Tính năng Tìm kiếm:**
    -   [ ] **Domain:** Tạo `SearchMovies` use case.
    -   [ ] **Data:** Thêm hàm tìm kiếm vào `remote_data_source` và `repository_impl`.
    -   [ ] **Presentation:** Tạo màn hình `SearchPage` với một `TextField` và một Bloc mới (`MovieSearchBloc`) để quản lý trạng thái tìm kiếm.

-   [ ] **Hoàn thiện và Tối ưu:**
    -   [ ] Kiểm tra và tối ưu hóa code.
    -   [ ] Viết tài liệu (nếu cần).
    -   [ ] Chuẩn bị cho việc báo cáo.

**✅ Kết quả cuối tuần 4:** Ứng dụng của bạn đã hoàn thiện tất cả các tính năng chính theo yêu cầu. Cấu trúc dự án rõ ràng, dễ dàng để tối ưu hóa hoặc thêm tính năng mới trong tương lai.


