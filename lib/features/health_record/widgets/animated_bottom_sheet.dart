import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/image_service.dart';
import '../utils/responsive_utils.dart';
import 'image_source_option_card.dart';

/// Animated bottom sheet for selecting image source
class AnimatedImageSourceSheet extends StatefulWidget {
  final Function(ImageSourceOption) onSourceSelected;
  const AnimatedImageSourceSheet({super.key, required this.onSourceSelected});

  static Future<ImageSourceOption?> show(BuildContext context) {
    return showModalBottomSheet<ImageSourceOption>(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (context) => AnimatedImageSourceSheet(onSourceSelected: (source) => Navigator.pop(context, source)),
    );
  }

  @override
  State<AnimatedImageSourceSheet> createState() => _AnimatedImageSourceSheetState();
}

class _AnimatedImageSourceSheetState extends State<AnimatedImageSourceSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation, _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this)..forward();
    _slideAnimation = Tween<double>(begin: 100, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _slideAnimation.value),
        child: Opacity(opacity: _fadeAnimation.value, child: _buildSheet()),
      ),
    );
  }

  Widget _buildSheet() => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveUtils.cardRadius * 1.5))),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(ResponsiveUtils.spacing(24), ResponsiveUtils.spacing(16), ResponsiveUtils.spacing(24), ResponsiveUtils.spacing(24)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: ResponsiveUtils.spacing(48), height: 5, decoration: BoxDecoration(color: AppColors.textLight.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(3))),
          SizedBox(height: ResponsiveUtils.spacing(24)),
          _buildTitle(),
          SizedBox(height: ResponsiveUtils.spacing(28)),
          _buildOptions(),
          SizedBox(height: ResponsiveUtils.spacing(20)),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(32), vertical: ResponsiveUtils.spacing(12))),
            child: Text(AppStrings.cancelOption, style: TextStyle(color: AppColors.textMedium, fontSize: ResponsiveUtils.fontSize(15), fontWeight: FontWeight.w500)),
          ),
        ]),
      ),
    ),
  );

  Widget _buildTitle() => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(10)),
        decoration: BoxDecoration(color: AppColors.primaryPink.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.add_photo_alternate_rounded, color: AppColors.primaryPink, size: ResponsiveUtils.iconSize(24)),
      ),
      SizedBox(width: ResponsiveUtils.spacing(12)),
      Text(AppStrings.imageSourceTitle, style: TextStyle(fontSize: ResponsiveUtils.fontSize(20), color: AppColors.textDark, fontWeight: FontWeight.bold)),
    ]),
    SizedBox(height: ResponsiveUtils.spacing(8)),
    Text('Choose how you want to add your health record', style: TextStyle(color: AppColors.textMedium, fontSize: ResponsiveUtils.fontSize(14)), textAlign: TextAlign.center),
  ]);

  Widget _buildOptions() => Row(children: [
    Expanded(child: ImageSourceOptionCard(icon: Icons.camera_alt_rounded, label: AppStrings.cameraOption, description: 'Take a new photo',
        gradient: [AppColors.primaryPink, AppColors.primaryPinkLight], onTap: () => widget.onSourceSelected(ImageSourceOption.camera))),
    SizedBox(width: ResponsiveUtils.spacing(16)),
    Expanded(child: ImageSourceOptionCard(icon: Icons.photo_library_rounded, label: AppStrings.galleryOption, description: 'Choose existing',
        gradient: [AppColors.darkNavy, AppColors.darkNavyLight], onTap: () => widget.onSourceSelected(ImageSourceOption.gallery))),
  ]);
}
