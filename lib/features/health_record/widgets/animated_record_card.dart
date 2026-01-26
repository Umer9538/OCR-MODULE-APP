import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/health_record_model.dart';
import '../utils/responsive_utils.dart';
import 'record_thumbnail.dart';

/// Animated record card with slide and fade animations
class AnimatedRecordCard extends StatefulWidget {
  final HealthRecord record;
  final int index;
  final VoidCallback? onTap;
  const AnimatedRecordCard({super.key, required this.record, required this.index, this.onTap});

  @override
  State<AnimatedRecordCard> createState() => _AnimatedRecordCardState();
}

class _AnimatedRecordCardState extends State<AnimatedRecordCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 400 + (widget.index * 100).clamp(0, 300)), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeOut)));
    _slideAnimation = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: const Interval(0, 0.8, curve: Curves.easeOutCubic)));
    _controller.forward();
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    return FadeTransition(opacity: _fadeAnimation, child: SlideTransition(position: _slideAnimation, child: _buildCard()));
  }

  Widget _buildCard() => GestureDetector(
    onTap: widget.onTap,
    child: Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing(16)),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius), boxShadow: [
        BoxShadow(color: AppColors.primaryPink.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 2)),
      ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap, borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius),
          splashColor: AppColors.primaryPink.withValues(alpha: 0.1),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(16)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RecordThumbnail(imageUrl: widget.record.imageUrl, recordId: widget.record.id ?? '', size: ResponsiveUtils.thumbnailSize),
              SizedBox(width: ResponsiveUtils.spacing(16)),
              Expanded(child: _buildContent()),
              _buildArrow(),
            ]),
          ),
        ),
      ),
    ),
  );

  Widget _buildContent() {
    final date = DateFormat('MMM dd, yyyy • hh:mm a').format(widget.record.createdAt);
    final text = widget.record.extractedText.isNotEmpty ? widget.record.extractedText : AppStrings.noTextExtracted;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(10), vertical: ResponsiveUtils.spacing(5)),
        decoration: BoxDecoration(color: AppColors.primaryPink.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.access_time_rounded, size: ResponsiveUtils.iconSize(12), color: AppColors.primaryPink),
          SizedBox(width: ResponsiveUtils.spacing(4)),
          Flexible(child: Text(date, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ResponsiveUtils.fontSize(11), color: AppColors.primaryPink, fontWeight: FontWeight.w600))),
        ]),
      ),
      SizedBox(height: ResponsiveUtils.spacing(10)),
      Row(children: [
        Container(width: 3, height: ResponsiveUtils.spacing(12), decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(2))),
        SizedBox(width: ResponsiveUtils.spacing(6)),
        Text(AppStrings.extractedTextLabel, style: TextStyle(fontSize: ResponsiveUtils.fontSize(10), color: AppColors.textMedium, fontWeight: FontWeight.w700)),
      ]),
      SizedBox(height: ResponsiveUtils.spacing(6)),
      Text(text, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ResponsiveUtils.fontSize(13), color: AppColors.textDark, height: 1.4)),
    ]);
  }

  Widget _buildArrow() => Container(
    padding: EdgeInsets.all(ResponsiveUtils.spacing(8)),
    decoration: BoxDecoration(color: AppColors.backgroundSoftPink, borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.6)),
    child: Icon(Icons.arrow_forward_ios_rounded, size: ResponsiveUtils.iconSize(14), color: AppColors.primaryPink),
  );
}
