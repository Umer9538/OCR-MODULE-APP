/// App strings for the Health Record OCR feature
/// Centralized for easy localization in the future
class AppStrings {
  AppStrings._();

  // Screen Title
  static const String screenTitle = 'Health Records';

  // Input Labels
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'Enter your email';

  // Button Labels
  static const String uploadButton = 'Upload';
  static const String getPreviousButton = 'Get Previous';

  // Image Source Options
  static const String imageSourceTitle = 'Select Image Source';
  static const String cameraOption = 'Camera';
  static const String galleryOption = 'Gallery';
  static const String cancelOption = 'Cancel';

  // Loading Messages
  static const String extractingText = 'Extracting text...';
  static const String uploadingImage = 'Uploading image...';
  static const String savingRecord = 'Saving record...';
  static const String fetchingRecords = 'Fetching records...';

  // Success Messages
  static const String recordSaved = 'Record saved successfully!';
  static const String recordsFetched = 'Records loaded';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNoImage = 'No image selected';
  static const String errorNoText = 'Could not extract text from image';
  static const String errorUpload = 'Failed to upload image';
  static const String errorSave = 'Failed to save record';
  static const String errorFetch = 'Failed to fetch records';
  static const String errorInvalidEmail = 'Please enter a valid email address';
  static const String errorEmptyEmail = 'Please enter your email address';

  // Empty States
  static const String noRecordsFound = 'No records found';
  static const String noRecordsDescription =
      'Upload a health record to get started';

  // Record Card
  static const String extractedTextLabel = 'Extracted Text';
  static const String noTextExtracted = 'No text could be extracted';
}
