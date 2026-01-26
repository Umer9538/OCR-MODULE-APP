import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Service for extracting text from images using Google ML Kit
/// On-device OCR - works offline, fast, and free
class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  /// Extract text from an image file
  /// Returns the extracted text or empty string if no text found
  Future<String> extractText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      // Combine all text blocks into a single string
      final StringBuffer buffer = StringBuffer();
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          buffer.writeln(line.text);
        }
        buffer.writeln(); // Add extra line between blocks
      }

      return buffer.toString().trim();
    } catch (e) {
      throw OcrException('Failed to extract text: $e');
    }
  }

  /// Dispose of the text recognizer when no longer needed
  void dispose() {
    _textRecognizer.close();
  }
}

/// Custom exception for OCR errors
class OcrException implements Exception {
  final String message;
  OcrException(this.message);

  @override
  String toString() => 'OcrException: $message';
}
