import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Widget hiển thị LOADING INDICATOR
/// 
/// Chức năng:
/// - Hiển thị CircularProgressIndicator (vòng tròn xoay)
/// - Có text "Loading..." phía dưới
/// - Dùng khi Bloc emit state Loading
/// 
/// Được sử dụng ở:
/// - MovieGrid: Khi đang fetch danh sách phim
/// - SearchPage: Khi đang search
/// - FavoritesPage: Khi đang load favorites
class LoadingWidget extends StatelessWidget {
  /// Text hiển thị dưới loading indicator
  /// Default: "Loading..." từ AppStrings
  final String? message;
  const LoadingWidget ({
    Key? key,
    this.message,
  }) : super(key:key);

  @override
    Widget build(BuildContext context){
      return Center(
         // Center: Căn giữa màn hình theo cả 2 chiều
        child: Column(
        // Column: Sắp xếp các widget theo chiều dọc
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisAlignment.center: Căn giữa theo trục chính (vertical)
        crossAxisAlignment: CrossAxisAlignment.center,
        // crossAxisAlignment.center: Căn giữa theo trục phụ (horizontal)

        children: [
          // ==Loading indicator
          const CircularProgressIndicator(
            // CircularProgressIndicator: Vòng tròn xoay Material Design
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.textPrimary,
          ),
          strokeWidth: 3.0,
          // strokeWidth: Độ dày của vòng tròn (3px)
          ),
          const SizedBox(height: 16),
          // SizedBox: Tạo khoảng cách giữa indicator và text (16px)

          //Loading text
          Text(
            message ?? AppStrings.loading,
            // Hiển thị text:
            // - Nếu có message truyền vào → dùng message
            // - Nếu không → dùng AppStrings.loading ("Loading...")
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              // Lấy style bodyMedium từ Theme (đã config ở app_theme.dart)
              color: AppColors.textSecondary,
              // Override màu text: Xám (textSecondary)
           ),
          ),
        ],
      ),
    );
  }
}


/// Widget hiển thị SHIMMER LOADING (Loading đẹp hơn)
/// 
/// Chức năng:
/// - Hiển thị placeholder với hiệu ứng shimmer (sáng di chuyển)
/// - Giống Facebook, Instagram khi load content
/// - Dùng khi muốn UX mượt hơn CircularProgressIndicator
/// 
/// Sử dụng package: shimmer ^3.0.0
class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // GridView: Tạo grid giống movie grid
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // 2 cột (giống movie grid)
        childAspectRatio: 2 / 3,
        // Tỷ lệ W:H = 2:3 (giống poster phim)
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      // Hiển thị 6 placeholder cards
      itemBuilder: (context, index) {
        return _ShimmerCard();
        // Mỗi item là 1 shimmer card
      },
    );
  }
}
class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // Nền trắng
        borderRadius: BorderRadius.circular(12),
        // Bo góc 12px (giống MovieCard)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === POSTER PLACEHOLDER ===
          Expanded(
            flex: 4,
            // flex: 4 → chiếm 4 phần (poster cao hơn)
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE5E7EB),
                // Màu xám nhạt (placeholder)
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: Colors.grey[400],
                  // Icon ảnh làm placeholder
                ),
              ),
            ),
          ),

          // === INFO SECTION PLACEHOLDER ===
          Expanded(
            flex: 1,
            // flex: 1 → chiếm 1 phần (info thấp hơn)
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Subtitle placeholder
                  Container(
                    width: 80,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}