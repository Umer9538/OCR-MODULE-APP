import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_utils.dart';

/// Thumbnail widget for health record cards
class RecordThumbnail extends StatelessWidget {
  final String imageUrl;
  final String recordId;
  final double size;

  const RecordThumbnail({
    super.key,
    required this.imageUrl,
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
          child: imageUrl.isNotEmpty ? _buildNetworkImage() : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: ResponsiveUtils.iconSize(24),
            height: ResponsiveUtils.iconSize(24),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryPink,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
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
