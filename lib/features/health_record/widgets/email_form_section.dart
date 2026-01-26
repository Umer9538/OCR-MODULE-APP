import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../utils/responsive_utils.dart';

/// Animated email form section widget
class EmailFormSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final String? Function(String?)? validator;
  final Animation<double> slideAnimation;
  final Animation<double> fadeAnimation;

  const EmailFormSection({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.validator,
    required this.slideAnimation,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    return AnimatedBuilder(
      animation: Listenable.merge([slideAnimation, fadeAnimation]),
      builder: (context, child) => Transform.translate(
        offset: Offset(0, slideAnimation.value),
        child: Opacity(opacity: fadeAnimation.value, child: _buildCard()),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius),
        boxShadow: [BoxShadow(color: AppColors.primaryPink.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: ResponsiveUtils.spacing(16)),
            _buildTextField(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing(8)),
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.5),
          ),
          child: Icon(Icons.email_outlined, color: AppColors.primaryPink, size: ResponsiveUtils.iconSize(20)),
        ),
        SizedBox(width: ResponsiveUtils.spacing(12)),
        Text('Your Email', style: TextStyle(color: AppColors.textDark, fontSize: ResponsiveUtils.fontSize(16), fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildTextField() {
    final radius = BorderRadius.circular(ResponsiveUtils.cardRadius * 0.8);
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      style: TextStyle(fontSize: ResponsiveUtils.fontSize(16)),
      decoration: InputDecoration(
        hintText: AppStrings.emailHint,
        hintStyle: TextStyle(color: AppColors.textLight, fontSize: ResponsiveUtils.fontSize(15)),
        filled: true,
        fillColor: AppColors.backgroundLight,
        contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(20), vertical: ResponsiveUtils.spacing(18)),
        border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: AppColors.primaryPink.withValues(alpha: 0.1))),
        focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: const BorderSide(color: AppColors.primaryPink, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: radius, borderSide: const BorderSide(color: AppColors.error)),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: ResponsiveUtils.spacing(16), right: ResponsiveUtils.spacing(12)),
          child: Icon(Icons.alternate_email_rounded, color: AppColors.primaryPink.withValues(alpha: 0.7), size: ResponsiveUtils.iconSize(22)),
        ),
      ),
    );
  }
}
