import 'package:flutter/material.dart';

/// Responsive utilities for adapting UI to different screen sizes
class ResponsiveUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late bool isTablet;
  static late bool isSmallPhone;
  static late bool isLargePhone;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    // Create block sizes for percentage-based sizing
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    // Account for safe areas
    final safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    final safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;

    // Determine device type
    isTablet = screenWidth >= 600;
    isSmallPhone = screenWidth < 360;
    isLargePhone = screenWidth >= 400 && screenWidth < 600;
  }

  /// Get responsive font size
  static double fontSize(double size) {
    final scaleFactor = screenWidth / 375; // Base width (iPhone 8)
    return (size * scaleFactor).clamp(size * 0.8, size * 1.3);
  }

  /// Get responsive spacing
  static double spacing(double size) {
    final scaleFactor = screenWidth / 375;
    return (size * scaleFactor).clamp(size * 0.7, size * 1.5);
  }

  /// Get responsive icon size
  static double iconSize(double size) {
    final scaleFactor = screenWidth / 375;
    return (size * scaleFactor).clamp(size * 0.8, size * 1.4);
  }

  /// Get responsive width percentage
  static double wp(double percentage) => screenWidth * (percentage / 100);

  /// Get responsive height percentage
  static double hp(double percentage) => screenHeight * (percentage / 100);

  /// Get number of columns for grid based on screen width
  static int getGridColumns() {
    if (screenWidth >= 900) return 3;
    if (screenWidth >= 600) return 2;
    return 1;
  }

  /// Get horizontal padding based on screen size
  static double get horizontalPadding {
    if (isTablet) return 32;
    if (isSmallPhone) return 12;
    return 20;
  }

  /// Get card border radius based on screen size
  static double get cardRadius {
    if (isTablet) return 24;
    if (isSmallPhone) return 16;
    return 20;
  }

  /// Get thumbnail size based on screen size
  static double get thumbnailSize {
    if (isTablet) return 100;
    if (isSmallPhone) return 60;
    return 80;
  }

  /// Get button height based on screen size
  static double get buttonHeight {
    if (isTablet) return 56;
    if (isSmallPhone) return 44;
    return 52;
  }
}

/// Extension for easy responsive sizing
extension ResponsiveExtension on num {
  double get w => ResponsiveUtils.wp(toDouble());
  double get h => ResponsiveUtils.hp(toDouble());
  double get sp => ResponsiveUtils.fontSize(toDouble());
  double get r => ResponsiveUtils.spacing(toDouble());
}
