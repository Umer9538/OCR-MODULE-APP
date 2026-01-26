import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

/// Service for local file storage operations
class LocalStorageService {
  static const String _folderName = 'health_records';
  final _uuid = const Uuid();

  /// Get the storage directory for health records
  Future<Directory> _getStorageDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final storageDir = Directory(path.join(appDir.path, _folderName));
    if (!await storageDir.exists()) {
      await storageDir.create(recursive: true);
    }
    return storageDir;
  }

  /// Save image to local storage and return the path
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

    await imageFile.copy(savedPath);
    return savedPath;
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
}
