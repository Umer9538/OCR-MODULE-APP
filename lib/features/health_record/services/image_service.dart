import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// Enum representing the image source options
enum ImageSourceOption { camera, gallery }

/// Service for picking and compressing images
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the specified source
  /// Returns a compressed File or null if cancelled
  Future<File?> pickImage(ImageSourceOption source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source == ImageSourceOption.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      // Compress the image for faster upload
      final compressedFile = await _compressImage(File(pickedFile.path));
      return compressedFile;
    } catch (e) {
      throw ImageServiceException('Failed to pick image: $e');
    }
  }

  /// Compress an image file to reduce size for upload
  Future<File> _compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result == null) {
        // If compression fails, return original file
        return file;
      }

      return File(result.path);
    } catch (e) {
      // If compression fails, return original file
      debugPrint('Image compression failed: $e');
      return file;
    }
  }
}

/// Custom exception for ImageService errors
class ImageServiceException implements Exception {
  final String message;
  ImageServiceException(this.message);

  @override
  String toString() => 'ImageServiceException: $message';
}
