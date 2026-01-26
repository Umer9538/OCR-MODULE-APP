/// Model class representing a health record
class HealthRecord {
  final int? id;
  final String email;
  final String imagePath;
  final String extractedText;
  final DateTime createdAt;

  HealthRecord({
    this.id,
    required this.email,
    required this.imagePath,
    required this.extractedText,
    required this.createdAt,
  });

  /// Create a HealthRecord from database map
  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'] as int?,
      email: map['email'] as String? ?? '',
      imagePath: map['image_path'] as String? ?? '',
      extractedText: map['extracted_text'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  /// Convert HealthRecord to database map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'image_path': imagePath,
      'extracted_text': extractedText,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Create a copy with optional new values
  HealthRecord copyWith({
    int? id,
    String? email,
    String? imagePath,
    String? extractedText,
    DateTime? createdAt,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      extractedText: extractedText ?? this.extractedText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'HealthRecord(id: $id, email: $email, createdAt: $createdAt)';
  }
}
