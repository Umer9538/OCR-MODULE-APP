import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_utils.dart';

/// Animated button with scale and glow effects
class AnimatedButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isOutlined;

  const AnimatedButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isOutlined = false,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    final bgColor = widget.backgroundColor ?? AppColors.primaryPink;
    final fgColor = widget.foregroundColor ?? Colors.white;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildButton(bgColor, fgColor),
        ),
      ),
    );
  }

  Widget _buildButton(Color bgColor, Color fgColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.spacing(14), horizontal: ResponsiveUtils.spacing(16)),
      decoration: BoxDecoration(
        gradient: widget.isOutlined ? null : LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [bgColor, bgColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius * 0.8),
        border: widget.isOutlined ? Border.all(color: bgColor, width: 2) : null,
        boxShadow: _isPressed ? [] : [BoxShadow(color: bgColor.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: widget.isOutlined ? bgColor : fgColor, size: ResponsiveUtils.iconSize(20)),
          SizedBox(width: ResponsiveUtils.spacing(8)),
          Flexible(
            child: Text(widget.label, overflow: TextOverflow.ellipsis,
                style: TextStyle(color: widget.isOutlined ? bgColor : fgColor, fontSize: ResponsiveUtils.fontSize(14), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
