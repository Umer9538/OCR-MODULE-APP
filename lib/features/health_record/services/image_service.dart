import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Enum representing the image source options
enum ImageSourceOption { camera, gallery }

/// Service for picking images
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Allowed image extensions
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

  /// Maximum file size in bytes (10MB)
  static const int maxFileSizeBytes = 10 * 1024 * 1024;

  /// Pick an image from the specified source
  /// Returns a File or null if cancelled
  /// Throws exception if file type or size is invalid
  Future<File?> pickImage(ImageSourceOption source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source == ImageSourceOption.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (pickedFile == null) return null;

      final file = File(pickedFile.path);

      // Validate file type
      if (!_isValidImageType(pickedFile.path)) {
        throw ImageServiceException(
          'Invalid file type. Only images (${_allowedExtensions.join(", ")}) are allowed.',
        );
      }

      // Validate file size
      final fileSize = await file.length();
      if (fileSize > maxFileSizeBytes) {
        throw ImageServiceException(
          'File too large. Maximum size is ${maxFileSizeBytes ~/ (1024 * 1024)}MB.',
        );
      }

      return file;
    } catch (e) {
      if (e is ImageServiceException) rethrow;
      throw ImageServiceException('Failed to pick image: $e');
    }
  }

  /// Check if file has valid image extension
  bool _isValidImageType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return _allowedExtensions.contains(extension);
  }
}

/// Custom exception for ImageService errors
class ImageServiceException implements Exception {
  final String message;
  ImageServiceException(this.message);

  @override
  String toString() => message;
}
