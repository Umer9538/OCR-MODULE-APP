import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firebase_constants.dart';

/// Model class representing a health record
class HealthRecord {
  final String? id;
  final String email;
  final String imageUrl;
  final String extractedText;
  final DateTime createdAt;

  HealthRecord({
    this.id,
    required this.email,
    required this.imageUrl,
    required this.extractedText,
    required this.createdAt,
  });

  /// Create a HealthRecord from Firestore document
  factory HealthRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HealthRecord(
      id: doc.id,
      email: data[FirebaseConstants.fieldEmail] ?? '',
      imageUrl: data[FirebaseConstants.fieldImageUrl] ?? '',
      extractedText: data[FirebaseConstants.fieldExtractedText] ?? '',
      createdAt: (data[FirebaseConstants.fieldCreatedAt] as Timestamp).toDate(),
    );
  }

  /// Convert HealthRecord to Firestore document map
  Map<String, dynamic> toFirestore() {
    return {
      FirebaseConstants.fieldEmail: email,
      FirebaseConstants.fieldImageUrl: imageUrl,
      FirebaseConstants.fieldExtractedText: extractedText,
      FirebaseConstants.fieldCreatedAt: Timestamp.fromDate(createdAt),
    };
  }

  /// Create a copy of HealthRecord with optional new values
  HealthRecord copyWith({
    String? id,
    String? email,
    String? imageUrl,
    String? extractedText,
    DateTime? createdAt,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      extractedText: extractedText ?? this.extractedText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'HealthRecord(id: $id, email: $email, createdAt: $createdAt)';
  }
}
