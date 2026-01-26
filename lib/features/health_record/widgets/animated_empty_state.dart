import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../utils/responsive_utils.dart';

/// Animated empty state widget with floating animation
class AnimatedEmptyState extends StatefulWidget {
  final String? title;
  final String? description;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  const AnimatedEmptyState({super.key, this.title, this.description, this.onActionPressed, this.actionLabel});

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState> with TickerProviderStateMixin {
  late AnimationController _floatController, _fadeController;
  late Animation<double> _floatAnimation, _fadeAnimation, _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
    _fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this)..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut));
  }

  @override
  void dispose() { _floatController.dispose(); _fadeController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    final size = ResponsiveUtils.isTablet ? 180.0 : (ResponsiveUtils.isSmallPhone ? 100.0 : 140.0);
    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnimation, _fadeAnimation]),
      builder: (context, child) => Opacity(
        opacity: _fadeAnimation.value,
        child: Transform.scale(scale: _scaleAnimation.value, child: Center(child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.spacing(32)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildIcon(size), SizedBox(height: ResponsiveUtils.spacing(32)),
            Text(widget.title ?? AppStrings.noRecordsFound, style: TextStyle(fontSize: ResponsiveUtils.fontSize(20), color: AppColors.textDark, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: ResponsiveUtils.spacing(12)),
            Text(widget.description ?? AppStrings.noRecordsDescription, style: TextStyle(fontSize: ResponsiveUtils.fontSize(14), color: AppColors.textMedium, height: 1.5), textAlign: TextAlign.center),
            if (widget.onActionPressed != null) ...[SizedBox(height: ResponsiveUtils.spacing(24)), _buildButton()],
          ]),
        ))),
      ),
    );
  }

  Widget _buildIcon(double size) => Transform.translate(
    offset: Offset(0, _floatAnimation.value),
    child: Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle,
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.backgroundSoftPink, AppColors.primaryPink.withValues(alpha: 0.2)]),
      boxShadow: [BoxShadow(color: AppColors.primaryPink.withValues(alpha: 0.2), blurRadius: 30, offset: const Offset(0, 15))]),
      child: Center(child: Icon(Icons.medical_information_outlined, size: size * 0.43, color: AppColors.primaryPink.withValues(alpha: 0.7)))),
  );

  Widget _buildButton() => TextButton.icon(
    onPressed: widget.onActionPressed,
    icon: Icon(Icons.add_circle_outline, size: ResponsiveUtils.iconSize(20)),
    label: Text(widget.actionLabel ?? 'Upload Record', style: TextStyle(fontSize: ResponsiveUtils.fontSize(14))),
    style: TextButton.styleFrom(foregroundColor: AppColors.primaryPink, padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(24), vertical: ResponsiveUtils.spacing(12))),
  );
}
