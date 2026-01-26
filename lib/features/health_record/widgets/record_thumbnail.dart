import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_utils.dart';

/// Thumbnail widget for health record cards
class RecordThumbnail extends StatelessWidget {
  final String imagePath;
  final int? recordId;
  final double size;

  const RecordThumbnail({
    super.key,
    required this.imagePath,
    required this.recordId,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'record_image_$recordId',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundSoftPink,
              AppColors.primaryPink.withValues(alpha: 0.1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.8),
          child: imagePath.isNotEmpty ? _buildFileImage() : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildFileImage() {
    final file = File(imagePath);
    return FutureBuilder<bool>(
      future: file.exists(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Image.file(file, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildErrorIcon());
        }
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_rounded,
        color: AppColors.primaryPink.withValues(alpha: 0.5),
        size: ResponsiveUtils.iconSize(32),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Center(
      child: Icon(
        Icons.broken_image_rounded,
        color: AppColors.primaryPink.withValues(alpha: 0.5),
        size: ResponsiveUtils.iconSize(32),
      ),
    );
  }
}
