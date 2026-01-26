import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/health_record_model.dart';
import '../utils/responsive_utils.dart';

/// Bottom sheet for displaying record details
class RecordDetailSheet extends StatelessWidget {
  final HealthRecord record;
  const RecordDetailSheet({super.key, required this.record});

  static void show(BuildContext context, HealthRecord record) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => RecordDetailSheet(record: record));
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    return DraggableScrollableSheet(
      initialChildSize: ResponsiveUtils.isTablet ? 0.6 : 0.75, minChildSize: 0.4, maxChildSize: 0.95,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveUtils.cardRadius * 1.5))),
        child: Column(children: [
          Container(margin: EdgeInsets.only(top: ResponsiveUtils.spacing(12)), width: 48, height: 5, decoration: BoxDecoration(color: AppColors.textLight.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(3))),
          Expanded(child: ListView(controller: controller, padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding), children: [
            Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              _buildImage(), SizedBox(height: ResponsiveUtils.spacing(24)),
              _buildHeader(), SizedBox(height: ResponsiveUtils.spacing(16)),
              _buildText(), SizedBox(height: ResponsiveUtils.spacing(24)),
              _buildButton(context),
            ]))),
          ])),
        ]),
      ),
    );
  }

  Widget _buildImage() {
    final h = ResponsiveUtils.isTablet ? 300.0 : 250.0;
    return Hero(
      tag: 'record_image_${record.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius),
        child: record.imageUrl.isNotEmpty
          ? Image.network(record.imageUrl, height: h, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder(h))
          : _placeholder(h),
      ),
    );
  }

  Widget _placeholder(double h) => Container(height: h, decoration: BoxDecoration(color: AppColors.backgroundSoftPink, borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius)),
    child: Center(child: Icon(Icons.image_rounded, size: ResponsiveUtils.iconSize(64), color: AppColors.primaryPink.withValues(alpha: 0.3))));

  Widget _buildHeader() => Row(children: [
    Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(2))),
    SizedBox(width: ResponsiveUtils.spacing(12)),
    Text(AppStrings.extractedTextLabel, style: TextStyle(color: AppColors.textDark, fontSize: ResponsiveUtils.fontSize(18), fontWeight: FontWeight.bold)),
  ]);

  Widget _buildText() => Container(
    padding: EdgeInsets.all(ResponsiveUtils.spacing(20)),
    decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.8)),
    child: SelectableText(record.extractedText.isNotEmpty ? record.extractedText : AppStrings.noTextExtracted, style: TextStyle(color: AppColors.textDark, fontSize: ResponsiveUtils.fontSize(15), height: 1.6)),
  );

  Widget _buildButton(BuildContext context) => SizedBox(height: ResponsiveUtils.buttonHeight, child: ElevatedButton(
    onPressed: () => Navigator.pop(context),
    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPink, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.8))),
    child: Text('Close', style: TextStyle(fontSize: ResponsiveUtils.fontSize(16), fontWeight: FontWeight.w600)),
  ));
}
