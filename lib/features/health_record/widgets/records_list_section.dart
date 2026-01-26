import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/health_record_model.dart';
import '../utils/responsive_utils.dart';
import 'animated_record_card.dart';
import 'animated_empty_state.dart';
import 'shimmer_loading.dart';

/// Records list section with loading and empty states
class RecordsListSection extends StatelessWidget {
  final List<HealthRecord> records;
  final bool isLoading;
  final bool hasSearched;
  final Function(HealthRecord) onRecordTap;
  final VoidCallback onUploadPressed;

  const RecordsListSection({
    super.key,
    required this.records,
    required this.isLoading,
    required this.hasSearched,
    required this.onRecordTap,
    required this.onUploadPressed,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    if (isLoading) return _buildLoadingState();
    if (!hasSearched) return const SizedBox.shrink();
    if (records.isEmpty) return AnimatedEmptyState(onActionPressed: onUploadPressed, actionLabel: 'Upload Your First Record');
    return _buildRecordsList();
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(3, (index) => Padding(
        padding: EdgeInsets.only(bottom: ResponsiveUtils.spacing(16)),
        child: const ShimmerRecordCard(),
      )),
    );
  }

  Widget _buildRecordsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        SizedBox(height: ResponsiveUtils.spacing(20)),
        if (ResponsiveUtils.isTablet && records.length > 1)
          _buildGrid()
        else
          ...records.asMap().entries.map((e) => AnimatedRecordCard(
            record: e.value, index: e.key, onTap: () => onRecordTap(e.value),
          )),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing(8)),
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.5),
          ),
          child: Icon(Icons.folder_open_rounded, color: AppColors.primaryPink, size: ResponsiveUtils.iconSize(20)),
        ),
        SizedBox(width: ResponsiveUtils.spacing(12)),
        Text('Your Records', style: TextStyle(color: AppColors.textDark, fontSize: ResponsiveUtils.fontSize(18), fontWeight: FontWeight.bold)),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(12), vertical: ResponsiveUtils.spacing(6)),
          decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(20)),
          child: Text('${records.length}', style: TextStyle(color: Colors.white, fontSize: ResponsiveUtils.fontSize(13), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 2.5,
        crossAxisSpacing: ResponsiveUtils.spacing(16),
        mainAxisSpacing: ResponsiveUtils.spacing(16),
      ),
      itemCount: records.length,
      itemBuilder: (context, index) => AnimatedRecordCard(
        record: records[index], index: index, onTap: () => onRecordTap(records[index]),
      ),
    );
  }
}
