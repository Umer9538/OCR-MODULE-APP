import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_utils.dart';

/// Shimmer loading effect widget
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                AppColors.backgroundSoftPink,
                AppColors.backgroundSoftPink.withValues(alpha: 0.5),
                AppColors.backgroundSoftPink,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer loading card for records
class ShimmerRecordCard extends StatelessWidget {
  const ShimmerRecordCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    final thumbnailSize = ResponsiveUtils.thumbnailSize;

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius),
      ),
      child: Row(
        children: [
          ShimmerLoading(
            width: thumbnailSize,
            height: thumbnailSize,
            borderRadius: ResponsiveUtils.cardRadius * 0.8,
          ),
          SizedBox(width: ResponsiveUtils.spacing(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  width: ResponsiveUtils.spacing(120),
                  height: ResponsiveUtils.fontSize(14),
                ),
                SizedBox(height: ResponsiveUtils.spacing(12)),
                ShimmerLoading(
                  width: double.infinity,
                  height: ResponsiveUtils.fontSize(12),
                ),
                SizedBox(height: ResponsiveUtils.spacing(8)),
                ShimmerLoading(
                  width: ResponsiveUtils.screenWidth * 0.4,
                  height: ResponsiveUtils.fontSize(12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
