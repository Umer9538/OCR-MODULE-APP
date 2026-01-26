/// Health Record OCR Module
///
/// A complete health record upload and OCR feature with professional UI,
/// smooth animations, and responsive design.
///
/// Architecture follows separation of concerns:
/// - Models: Data structures
/// - Services: OCR, local storage, local database
/// - Controllers: Business logic and state management
/// - Widgets: Reusable UI components
/// - Screens: Page-level UI composition
/// - Constants: App-wide constants (colors, strings, themes)
/// - Utils: Utility functions
library;

// Models
export 'models/health_record_model.dart';

// Services
export 'services/ocr_service.dart';
export 'services/local_storage_service.dart';
export 'services/local_database_service.dart';
export 'services/image_service.dart';

// Controllers
export 'controllers/health_record_controller.dart';

// Screens
export 'screens/health_record_screen.dart';

// Widgets - Core Components
export 'widgets/animated_button.dart';
export 'widgets/animated_record_card.dart';
export 'widgets/animated_empty_state.dart';
export 'widgets/animated_bottom_sheet.dart';
export 'widgets/animated_loading_overlay.dart';
export 'widgets/shimmer_loading.dart';
export 'widgets/record_thumbnail.dart';
export 'widgets/image_source_option_card.dart';

// Widgets - Section Components
export 'widgets/header_section.dart';
export 'widgets/email_form_section.dart';
export 'widgets/action_buttons_section.dart';
export 'widgets/records_list_section.dart';
export 'widgets/record_detail_sheet.dart';

// Constants
export 'constants/app_colors.dart';
export 'constants/app_strings.dart';
export 'constants/app_theme.dart';

// Utils
export 'utils/responsive_utils.dart';
