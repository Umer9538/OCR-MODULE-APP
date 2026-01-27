import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

/// Service for local file storage operations
class LocalStorageService {
  static const String _folderName = 'health_records';
  static const int _compressionQuality = 70;
  final _uuid = const Uuid();

  /// Get the storage directory for health records (App Support - private, not backed up)
  Future<Directory> _getStorageDirectory() async {
    final appDir = await getApplicationSupportDirectory();
    final storageDir = Directory(path.join(appDir.path, _folderName));
    if (!await storageDir.exists()) {
      await storageDir.create(recursive: true);
    }
    return storageDir;
  }

  /// Save image to local storage with compression and return the path
  /// Also cleans up the original temp file after saving
  Future<String> saveImage({
    required File imageFile,
    required String email,
  }) async {
    final storageDir = await _getStorageDirectory();
    final sanitizedEmail = email.replaceAll(RegExp(r'[^\w]'), '_');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueId = _uuid.v4().substring(0, 8);
    final fileName = '${sanitizedEmail}_${timestamp}_$uniqueId.jpg';
    final savedPath = path.join(storageDir.path, fileName);

    // Store original path for cleanup
    final originalPath = imageFile.path;

    try {
      // Compress and save directly to permanent storage
      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        savedPath,
        quality: _compressionQuality,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result == null) {
        // If compression fails, copy original file
        await imageFile.copy(savedPath);
      }

      // Clean up temp file if it's in temp directory
      await _cleanupTempFile(originalPath);

      return savedPath;
    } catch (e) {
      // Fallback: copy without compression
      await imageFile.copy(savedPath);
      await _cleanupTempFile(originalPath);
      return savedPath;
    }
  }

  /// Delete temp file if it exists in temp directory
  Future<void> _cleanupTempFile(String filePath) async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (filePath.startsWith(tempDir.path)) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          debugPrint('Cleaned up temp file: $filePath');
        }
      }
    } catch (e) {
      debugPrint('Failed to cleanup temp file: $e');
    }
  }

  /// Delete image from local storage
  Future<void> deleteImage(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Check if image exists
  Future<bool> imageExists(String imagePath) async {
    return await File(imagePath).exists();
  }

  /// Get storage directory path
  Future<String> getStoragePath() async {
    final dir = await _getStorageDirectory();
    return dir.path;
  }

  /// Clean up all temp files in temp directory related to this app
  Future<void> cleanupAllTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();
      for (final file in files) {
        if (file is File && file.path.contains('compressed_')) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Failed to cleanup temp files: $e');
    }
  }
}
