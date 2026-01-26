import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_colors.dart';
import '../utils/responsive_utils.dart';

/// Animated loading overlay with pulsing effect
class AnimatedLoadingOverlay extends StatefulWidget {
  final String message;
  const AnimatedLoadingOverlay({super.key, required this.message});

  static void show(BuildContext context, String message) {
    showDialog(context: context, barrierDismissible: false, barrierColor: Colors.black54, builder: (context) => AnimatedLoadingOverlay(message: message));
  }

  static void hide(BuildContext context) { Navigator.of(context, rootNavigator: true).pop(); }

  @override
  State<AnimatedLoadingOverlay> createState() => _AnimatedLoadingOverlayState();
}

class _AnimatedLoadingOverlayState extends State<AnimatedLoadingOverlay> with TickerProviderStateMixin {
  late AnimationController _pulseController, _rotationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat(reverse: true);
    _rotationController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat();
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulseController.dispose(); _rotationController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    final size = ResponsiveUtils.isTablet ? 80.0 : (ResponsiveUtils.isSmallPhone ? 50.0 : 60.0);
    return PopScope(canPop: false, child: Center(child: AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Transform.scale(scale: _pulseAnimation.value, child: Container(
        margin: EdgeInsets.all(ResponsiveUtils.spacing(32)),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(40), vertical: ResponsiveUtils.spacing(32)),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 1.2),
          boxShadow: [BoxShadow(color: AppColors.primaryPink.withValues(alpha: 0.2), blurRadius: 30, offset: const Offset(0, 15))]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _buildLoader(size), SizedBox(height: ResponsiveUtils.spacing(24)),
          Text(widget.message, style: TextStyle(color: AppColors.textDark, fontSize: ResponsiveUtils.fontSize(16), fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          SizedBox(height: ResponsiveUtils.spacing(8)),
          Text('Please wait...', style: TextStyle(color: AppColors.textMedium, fontSize: ResponsiveUtils.fontSize(13))),
        ]),
      )),
    )));
  }

  Widget _buildLoader(double size) => SizedBox(width: size, height: size, child: Stack(alignment: Alignment.center, children: [
    AnimatedBuilder(animation: _rotationController, builder: (context, child) => Transform.rotate(
      angle: _rotationController.value * 2 * math.pi,
      child: Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: SweepGradient(colors: [AppColors.primaryPink.withValues(alpha: 0), AppColors.primaryPink]))),
    )),
    Container(width: size - 10, height: size - 10, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white,
      boxShadow: [BoxShadow(color: AppColors.primaryPink.withValues(alpha: 0.1), blurRadius: 10)]),
      child: Icon(Icons.medical_services_rounded, color: AppColors.primaryPink, size: ResponsiveUtils.iconSize(24))),
  ]));
}
