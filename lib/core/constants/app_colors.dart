import 'package:flutter/material.dart';

/// Định nghĩa tất cả màu sắc sử dụng trong app
/// Giúp dễ maintain và consistent về màu sắc
class AppColors {
  // Private constructor để prevent instantiation
  AppColors._();

  // === PRIMARY COLORS (Purple Gradient) ===
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color primaryPink = Color(0xFFEC4899);
  
  // Gradient cho button, logo...
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // === BACKGROUND COLORS ===
  static const Color scaffoldBackground = Color(0xFFF5F5F5); // Light gray
  static const Color cardBackground = Colors.white;
  
  // === TEXT COLORS ===
  static const Color textPrimary = Color(0xFF1F2937);     // Dark gray
  static const Color textSecondary = Color(0xFF6B7280);   // Medium gray
  static const Color textLight = Color(0xFF9CA3AF);       // Light gray

  // === ACCENT COLORS ===
  static const Color ratingYellow = Color(0xFFFBBF24);    // Star rating
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);

  // === ICON COLORS ===
  static const Color iconGray = Color(0xFF9CA3AF);
  static const Color iconActive = primaryPurple;
  static const Color favoriteRed = Color(0xFFEF4444);

  // === BORDER COLORS ===
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
}