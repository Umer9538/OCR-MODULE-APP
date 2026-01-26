import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/health_record_model.dart';
import '../constants/firebase_constants.dart';

/// Service for storing and retrieving health records from Firestore
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get reference to the health records collection
  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirebaseConstants.healthRecordsCollection);

  /// Save a new health record to Firestore
  /// Returns the document ID of the saved record
  Future<String> saveRecord(HealthRecord record) async {
    try {
      final docRef = await _collection.add(record.toFirestore());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw FirestoreException('Failed to save record: ${e.message}');
    }
  }

  /// Retrieve all health records for a given email
  /// Returns a list of HealthRecord objects sorted by createdAt (newest first)
  Future<List<HealthRecord>> getRecordsByEmail(String email) async {
    try {
      final querySnapshot = await _collection
          .where(FirebaseConstants.fieldEmail, isEqualTo: email.toLowerCase())
          .orderBy(FirebaseConstants.fieldCreatedAt, descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => HealthRecord.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException('Failed to fetch records: ${e.message}');
    }
  }

  /// Delete a health record by its document ID
  Future<void> deleteRecord(String recordId) async {
    try {
      await _collection.doc(recordId).delete();
    } on FirebaseException catch (e) {
      throw FirestoreException('Failed to delete record: ${e.message}');
    }
  }

  /// Stream of health records for a given email (for real-time updates)
  Stream<List<HealthRecord>> streamRecordsByEmail(String email) {
    return _collection
        .where(FirebaseConstants.fieldEmail, isEqualTo: email.toLowerCase())
        .orderBy(FirebaseConstants.fieldCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HealthRecord.fromFirestore(doc))
            .toList());
  }
}

/// Custom exception for Firestore errors
class FirestoreException implements Exception {
  final String message;
  FirestoreException(this.message);

  @override
  String toString() => 'FirestoreException: $message';
}
