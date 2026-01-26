import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../constants/firebase_constants.dart';

/// Service for uploading images to Firebase Storage
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Upload an image file to Firebase Storage
  /// Returns the download URL of the uploaded image
  Future<String> uploadImage({
    required File imageFile,
    required String email,
  }) async {
    try {
      // Create a unique filename using timestamp and UUID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueId = _uuid.v4().substring(0, 8);
      final fileName = '${timestamp}_$uniqueId.jpg';

      // Sanitize email for use in path (replace special characters)
      final sanitizedEmail = _sanitizeEmail(email);

      // Create the storage reference
      final ref = _storage.ref().child(
            '${FirebaseConstants.healthRecordsStoragePath}/$sanitizedEmail/$fileName',
          );

      // Upload the file
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'email': email,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get and return the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw StorageException('Firebase Storage error: ${e.message}');
    } catch (e) {
      throw StorageException('Failed to upload image: $e');
    }
  }

  /// Sanitize email for use in storage path
  String _sanitizeEmail(String email) {
    return email.replaceAll(RegExp(r'[.#$\[\]]'), '_').toLowerCase();
  }

  /// Delete an image from Firebase Storage by URL
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw StorageException('Failed to delete image: ${e.message}');
    }
  }
}

/// Custom exception for Storage errors
class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
