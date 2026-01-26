import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../utils/responsive_utils.dart';
import 'animated_button.dart';

/// Action buttons section (Upload & Get Previous)
class ActionButtonsSection extends StatelessWidget {
  final VoidCallback onUpload;
  final VoidCallback onFetchRecords;
  final Animation<double> fadeAnimation;

  const ActionButtonsSection({
    super.key,
    required this.onUpload,
    required this.onFetchRecords,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);

    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: ResponsiveUtils.isSmallPhone
              ? _buildVerticalLayout()
              : _buildHorizontalLayout(),
        );
      },
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      children: [
        AnimatedButton(
          label: AppStrings.uploadButton,
          icon: Icons.cloud_upload_rounded,
          onPressed: onUpload,
          backgroundColor: AppColors.primaryPink,
        ),
        SizedBox(height: ResponsiveUtils.spacing(12)),
        AnimatedButton(
          label: AppStrings.getPreviousButton,
          icon: Icons.history_rounded,
          onPressed: onFetchRecords,
          backgroundColor: AppColors.darkNavy,
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        Expanded(
          child: AnimatedButton(
            label: AppStrings.uploadButton,
            icon: Icons.cloud_upload_rounded,
            onPressed: onUpload,
            backgroundColor: AppColors.primaryPink,
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing(12)),
        Expanded(
          child: AnimatedButton(
            label: AppStrings.getPreviousButton,
            icon: Icons.history_rounded,
            onPressed: onFetchRecords,
            backgroundColor: AppColors.darkNavy,
          ),
        ),
      ],
    );
  }
}
