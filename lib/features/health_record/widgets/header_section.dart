import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../utils/responsive_utils.dart';

/// Animated header section widget
class HeaderSection extends StatelessWidget {
  final Animation<double> slideAnimation;
  final Animation<double> fadeAnimation;

  const HeaderSection({super.key, required this.slideAnimation, required this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    return AnimatedBuilder(
      animation: Listenable.merge([slideAnimation, fadeAnimation]),
      builder: (context, child) => Transform.translate(
        offset: Offset(0, slideAnimation.value),
        child: Opacity(opacity: fadeAnimation.value, child: _buildHeader()),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.horizontalPadding, ResponsiveUtils.spacing(16),
        ResponsiveUtils.horizontalPadding, ResponsiveUtils.spacing(24),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.primaryPink, AppColors.primaryPinkLight],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(ResponsiveUtils.cardRadius * 1.5)),
        boxShadow: [BoxShadow(color: AppColors.primaryPink.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          _buildIcon(),
          SizedBox(width: ResponsiveUtils.spacing(16)),
          Expanded(child: _buildTitle()),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing(12)),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(Icons.medical_information_rounded, color: Colors.white, size: ResponsiveUtils.iconSize(28)),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.screenTitle,
            style: TextStyle(color: Colors.white, fontSize: ResponsiveUtils.fontSize(22), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        SizedBox(height: ResponsiveUtils.spacing(4)),
        Text('Upload & manage your health records',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: ResponsiveUtils.fontSize(13))),
      ],
    );
  }
}
