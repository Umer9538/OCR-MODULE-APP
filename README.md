# Health Record OCR Module

A standalone Flutter feature module that allows users to upload health record images and automatically extract text using on-device OCR. Built as an assessment task for MiGynae app integration.

## Features

- **Email-based identification** - No authentication required, uses email as a lightweight identifier
- **Image capture** - Take photos using camera or select from gallery
- **On-device OCR** - Google ML Kit text recognition (works offline, fast, free)
- **Local storage** - Images and records stored locally on device (SQLite + file system)
- **Record retrieval** - Fetch previously saved records by email
- **MiGynae-themed UI** - Pink/feminine design matching the existing app's color scheme
- **Responsive design** - Adapts to phones, small phones, and tablets
- **Smooth animations** - Slide, fade, scale, and floating animations throughout

### Nice-to-Have Features (Included)

- Image compression before upload (70% quality JPEG)
- Loading indicators with animated status messages
- Success/error toast notifications
- Animated empty state with floating icon
- Shimmer loading placeholders
- Clean separation of UI, services, controllers, and storage logic

## Architecture

The project follows **clean architecture** with **separation of concerns**:

```
lib/
├── main.dart                           # App entry point
└── features/
    └── health_record/
        ├── health_record.dart          # Barrel export file
        │
        ├── models/
        │   └── health_record_model.dart    # Data model with SQLite serialization
        │
        ├── services/                   # External API interactions
        │   ├── ocr_service.dart            # Google ML Kit OCR
        │   ├── local_storage_service.dart  # Local file storage operations
        │   ├── local_database_service.dart # SQLite database operations
        │   └── image_service.dart          # Image picker + compression
        │
        ├── controllers/                # Business logic & state management
        │   └── health_record_controller.dart   # ChangeNotifier controller
        │
        ├── screens/                    # Page-level UI composition
        │   └── health_record_screen.dart
        │
        ├── widgets/                    # Reusable UI components (max 120 lines each)
        │   ├── animated_button.dart        # Animated action button with pulse effect
        │   ├── animated_record_card.dart   # Record card with slide/fade animation
        │   ├── animated_empty_state.dart   # Empty state with floating animation
        │   ├── animated_bottom_sheet.dart  # Image source selection sheet
        │   ├── animated_loading_overlay.dart   # Loading overlay with spinner
        │   ├── shimmer_loading.dart        # Shimmer placeholder effect
        │   ├── record_thumbnail.dart       # Thumbnail with Hero animation
        │   ├── record_detail_sheet.dart    # Bottom sheet for record details
        │   ├── image_source_option_card.dart   # Camera/gallery option card
        │   ├── header_section.dart         # App header with icon
        │   ├── email_form_section.dart     # Email input with validation
        │   ├── action_buttons_section.dart # Upload/fetch buttons
        │   └── records_list_section.dart   # Records list with animations
        │
        ├── constants/                  # App-wide constants
        │   ├── app_colors.dart             # MiGynae pink color palette
        │   ├── app_strings.dart            # UI strings
        │   └── app_theme.dart              # Material theme configuration
        │
        └── utils/                      # Utility functions
            └── responsive_utils.dart       # Responsive sizing utilities
```

## Code Quality Standards

| Standard | Implementation |
|----------|----------------|
| Max lines per file | 120 lines |
| Architecture | Feature-based with separation of concerns |
| State management | ChangeNotifier pattern |
| Responsive design | ResponsiveUtils for all screen sizes |
| Animations | Custom AnimationController-based |
| Storage | Local SQLite database + file system |

## Local Storage Structure

### SQLite Database

```
Table: health_records
├── id: INTEGER PRIMARY KEY AUTOINCREMENT
├── email: TEXT NOT NULL
├── image_path: TEXT NOT NULL
├── extracted_text: TEXT NOT NULL
└── created_at: INTEGER NOT NULL (milliseconds since epoch)
```

### File Storage

```
Documents/health_records/
└── {sanitized_email}_{timestamp}_{uuid}.jpg
```

## Setup Instructions

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Xcode (for iOS)
- Android Studio (for Android)

### Step 1: Clone/Download the Project

```bash
git clone <repository-url>
cd health_record_ocr_module
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Run the App

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Release build (Android)
flutter build apk --release
```

## Integration into Existing App

### Option 1: Copy the Module

1. Copy the `lib/features/health_record/` folder to your project
2. Add dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  sqflite: ^2.4.1
  path: ^1.9.0
  google_mlkit_text_recognition: ^0.14.0
  image_picker: ^1.1.2
  flutter_image_compress: ^2.3.0
  path_provider: ^2.1.5
  intl: ^0.20.1
  uuid: ^4.5.1
```

3. Add iOS permissions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access needed to capture health records</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access needed to select health records</string>
```

4. Ensure Android `minSdkVersion` is 21+ in `android/app/build.gradle`

5. Add ProGuard rules for release builds in `android/app/proguard-rules.pro`:

```
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.play.core.**
```

6. Import and use the screen:

```dart
import 'package:your_app/features/health_record/health_record.dart';

// Navigate to the screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const HealthRecordScreen()),
);
```

### Option 2: Customize Colors

Edit `lib/features/health_record/constants/app_colors.dart` to match your app's theme.

## Switching to Firebase (Future)

This branch uses local storage. To switch to Firebase:

1. Switch to the `master` branch which has Firebase implementation
2. Or add Firebase dependencies and replace:
   - `local_storage_service.dart` → `storage_service.dart` (Firebase Storage)
   - `local_database_service.dart` → `firestore_service.dart` (Firestore)

The modular architecture makes this switch straightforward.

## OCR Approach

### Google ML Kit Text Recognition (Chosen)

**Why this approach:**

- **On-device processing** - No internet required, works offline
- **Free** - No API costs or usage limits
- **Fast** - Processes images in milliseconds
- **Privacy** - Image data never leaves the device
- **Accurate** - Works well with printed text, prescriptions, lab reports

**Alternatives considered:**

| Approach | Pros | Cons |
|----------|------|------|
| Google Cloud Vision API | Higher accuracy, handwriting support | Costs money, requires internet |
| Tesseract OCR | Open source | Lower accuracy, larger app size |
| Firebase ML Kit (Legacy) | Easy setup | Deprecated, use google_mlkit instead |

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| sqflite | ^2.4.1 | Local SQLite database |
| path | ^1.9.0 | File path manipulation |
| google_mlkit_text_recognition | ^0.14.0 | On-device OCR |
| image_picker | ^1.1.2 | Camera/gallery access |
| flutter_image_compress | ^2.3.0 | Image compression |
| path_provider | ^2.1.5 | App directory access |
| intl | ^0.20.1 | Date formatting |
| uuid | ^4.5.1 | Unique filename generation |

## Responsive Design

The module uses `ResponsiveUtils` for adaptive layouts:

| Device | Screen Width | Adaptations |
|--------|--------------|-------------|
| Small Phone | < 360dp | Smaller fonts, icons, spacing |
| Phone | 360-600dp | Standard sizing |
| Tablet | > 600dp | Larger elements, max content width |

## Error Handling

The module includes error handling for:

- Invalid email format
- No image selected
- OCR extraction failures
- Storage failures
- File system errors

Errors are displayed as snackbar messages with appropriate styling.

## Testing

To test the module:

1. Enter any valid email address
2. Click "Upload" and select camera or gallery
3. Take/select a photo of a health record or any text document
4. Verify OCR extracts text correctly
5. Click "Get Previous" to retrieve saved records
6. Click on a record card to see full details in bottom sheet

## Review Criteria

This module is built to meet the following review criteria:

| Criteria | Implementation |
|----------|----------------|
| **Code Quality** | Clean architecture, max 120 lines/file, ChangeNotifier pattern |
| **Structure** | Feature-based with separation of concerns (models, services, controllers, widgets, screens) |
| **Storage** | Local SQLite + file system; easily switchable to Firebase |
| **UX Logic** | Animated transitions, loading states, empty states, responsive design |

## License

This module is created as an assessment task. Usage rights to be determined upon project acceptance.

## Author

Built with Flutter for MiGynae app integration.
