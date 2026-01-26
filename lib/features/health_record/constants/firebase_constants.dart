/// Firebase collection and storage path constants
/// These can be easily modified when integrating into the main app
class FirebaseConstants {
  FirebaseConstants._();

  // Firestore Collection Names
  static const String healthRecordsCollection = 'health_records';

  // Firebase Storage Paths
  static const String healthRecordsStoragePath = 'health_records';

  // Field Names (for Firestore documents)
  static const String fieldEmail = 'email';
  static const String fieldImageUrl = 'imageUrl';
  static const String fieldExtractedText = 'extractedText';
  static const String fieldCreatedAt = 'createdAt';
}
