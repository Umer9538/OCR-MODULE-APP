import 'dart:io';
import 'package:flutter/material.dart';
import '../models/health_record_model.dart';
import '../services/ocr_service.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';
import '../services/image_service.dart';
import '../constants/app_strings.dart';

/// Controller for managing health record state and business logic
class HealthRecordController extends ChangeNotifier {
  // Services
  final _imageService = ImageService();
  final _ocrService = OcrService();
  final _storageService = StorageService();
  final _firestoreService = FirestoreService();

  // State
  List<HealthRecord> _records = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;
  String? _successMessage;
  String _loadingMessage = '';

  // Getters
  List<HealthRecord> get records => _records;
  bool get isLoading => _isLoading;
  bool get hasSearched => _hasSearched;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get loadingMessage => _loadingMessage;
  bool get hasRecords => _records.isNotEmpty;

  /// Validate email format
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.errorEmptyEmail;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.errorInvalidEmail;
    }
    return null;
  }

  /// Pick image from camera or gallery
  Future<File?> pickImage(ImageSourceOption source) async {
    try {
      return await _imageService.pickImage(source);
    } catch (e) {
      _setError(AppStrings.errorGeneric);
      return null;
    }
  }

  /// Process image: OCR, upload, and save
  Future<bool> processImage(File imageFile, String email) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      // Extract text
      _setLoading(true, AppStrings.extractingText);
      final extractedText = await _ocrService.extractText(imageFile);

      if (extractedText.isEmpty) {
        _setError(AppStrings.errorNoText);
      }

      // Upload image
      _setLoading(true, AppStrings.uploadingImage);
      final imageUrl = await _storageService.uploadImage(
        imageFile: imageFile,
        email: normalizedEmail,
      );

      // Save record
      _setLoading(true, AppStrings.savingRecord);
      final record = HealthRecord(
        email: normalizedEmail,
        imageUrl: imageUrl,
        extractedText: extractedText,
        createdAt: DateTime.now(),
      );
      await _firestoreService.saveRecord(record);

      _setLoading(false);
      _setSuccess(AppStrings.recordSaved);

      // Refresh records
      await fetchRecords(normalizedEmail);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  /// Fetch records by email
  Future<void> fetchRecords(String email) async {
    final normalizedEmail = email.trim().toLowerCase();

    _isLoading = true;
    _hasSearched = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _records = await _firestoreService.getRecordsByEmail(normalizedEmail);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _setError(AppStrings.errorFetch);
    }
  }

  /// Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setLoading(bool loading, [String message = '']) {
    _isLoading = loading;
    _loadingMessage = message;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }
}
