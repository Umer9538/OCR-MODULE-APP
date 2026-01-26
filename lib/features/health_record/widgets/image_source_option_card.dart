import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// Animated option card for image source selection
class ImageSourceOptionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String description;
  final List<Color> gradient;
  final VoidCallback onTap;

  const ImageSourceOptionCard({super.key, required this.icon, required this.label, required this.description, required this.gradient, required this.onTap});

  @override
  State<ImageSourceOptionCard> createState() => _ImageSourceOptionCardState();
}

class _ImageSourceOptionCardState extends State<ImageSourceOptionCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) { setState(() => _isPressed = true); _controller.forward(); },
    onTapUp: (_) { setState(() => _isPressed = false); _controller.reverse(); widget.onTap(); },
    onTapCancel: () { setState(() => _isPressed = false); _controller.reverse(); },
    child: AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: _buildCard()),
    ),
  );

  Widget _buildCard() => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    padding: EdgeInsets.all(ResponsiveUtils.spacing(20)),
    decoration: BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: widget.gradient),
      borderRadius: BorderRadius.circular(ResponsiveUtils.cardRadius),
      boxShadow: _isPressed ? [] : [BoxShadow(color: widget.gradient[0].withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 8))],
    ),
    child: Column(children: [
      Container(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(14)),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: Icon(widget.icon, color: Colors.white, size: ResponsiveUtils.iconSize(32)),
      ),
      SizedBox(height: ResponsiveUtils.spacing(14)),
      Text(widget.label, style: TextStyle(color: Colors.white, fontSize: ResponsiveUtils.fontSize(16), fontWeight: FontWeight.bold)),
      SizedBox(height: ResponsiveUtils.spacing(4)),
      Text(widget.description, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: ResponsiveUtils.fontSize(12))),
    ]),
  );
}
