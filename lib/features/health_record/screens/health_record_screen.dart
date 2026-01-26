import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/health_record_controller.dart';
import '../utils/responsive_utils.dart';
import '../widgets/animated_bottom_sheet.dart';
import '../widgets/animated_loading_overlay.dart';
import '../widgets/header_section.dart';
import '../widgets/email_form_section.dart';
import '../widgets/action_buttons_section.dart';
import '../widgets/records_list_section.dart';
import '../widgets/record_detail_sheet.dart';

/// Main screen for Health Record OCR feature
class HealthRecordScreen extends StatefulWidget {
  const HealthRecordScreen({super.key});

  @override
  State<HealthRecordScreen> createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends State<HealthRecordScreen>
    with TickerProviderStateMixin {
  // Controllers
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _controller = HealthRecordController();

  // Animation Controllers
  late AnimationController _headerAnimationController;
  late AnimationController _formAnimationController;
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _formSlideAnimation;
  late Animation<double> _formFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _controller.addListener(_onControllerUpdate);
  }

  void _initAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerSlideAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _headerFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.2, 1, curve: Curves.easeOut),
      ),
    );

    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _formSlideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _formAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _formFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _formAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _formAnimationController.forward();
    });
  }

  void _onControllerUpdate() {
    if (!mounted) return;

    // Handle error messages
    if (_controller.errorMessage != null) {
      _showSnackBar(_controller.errorMessage!, isError: true);
      _controller.clearMessages();
    }

    // Handle success messages
    if (_controller.successMessage != null) {
      _showSnackBar(_controller.successMessage!);
      _controller.clearMessages();
    }

    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _scrollController.dispose();
    _headerAnimationController.dispose();
    _formAnimationController.dispose();
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    if (!_formKey.currentState!.validate()) return;

    final source = await AnimatedImageSourceSheet.show(context);
    if (source == null) return;

    final imageFile = await _controller.pickImage(source);
    if (imageFile == null) {
      _showSnackBar(AppStrings.errorNoImage, isError: true);
      return;
    }

    if (!mounted) return;
    AnimatedLoadingOverlay.show(context, _controller.loadingMessage);

    await _controller.processImage(
      imageFile,
      _emailController.text,
    );

    if (mounted) {
      AnimatedLoadingOverlay.hide(context);
    }
  }

  Future<void> _handleFetchRecords() async {
    if (!_formKey.currentState!.validate()) return;
    await _controller.fetchRecords(_emailController.text);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: ResponsiveUtils.iconSize(20),
            ),
            SizedBox(width: ResponsiveUtils.spacing(12)),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: ResponsiveUtils.fontSize(14)),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.6),
        ),
        margin: EdgeInsets.all(ResponsiveUtils.horizontalPadding),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundWhite,
              AppColors.backgroundSoftPink.withValues(alpha: 0.5),
              AppColors.backgroundSoftPink,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              HeaderSection(
                slideAnimation: _headerSlideAnimation,
                fadeAnimation: _headerFadeAnimation,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveUtils.horizontalPadding,
                    ResponsiveUtils.spacing(24),
                    ResponsiveUtils.horizontalPadding,
                    ResponsiveUtils.spacing(100),
                  ),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmailFormSection(
          formKey: _formKey,
          emailController: _emailController,
          validator: _controller.validateEmail,
          slideAnimation: _formSlideAnimation,
          fadeAnimation: _formFadeAnimation,
        ),
        SizedBox(height: ResponsiveUtils.spacing(24)),
        ActionButtonsSection(
          onUpload: _handleUpload,
          onFetchRecords: _handleFetchRecords,
          fadeAnimation: _formFadeAnimation,
        ),
        SizedBox(height: ResponsiveUtils.spacing(32)),
        RecordsListSection(
          records: _controller.records,
          isLoading: _controller.isLoading,
          hasSearched: _controller.hasSearched,
          onRecordTap: (record) => RecordDetailSheet.show(context, record),
          onUploadPressed: _handleUpload,
        ),
      ],
    );

    // Constrain width on tablets
    if (ResponsiveUtils.isTablet) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: content,
        ),
      );
    }

    return content;
  }
}
