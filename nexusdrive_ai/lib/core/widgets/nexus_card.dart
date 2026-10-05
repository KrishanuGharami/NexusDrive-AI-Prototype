import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class NexusCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool hasGlow;
  final Color? glowColor;

  const NexusCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16.0,
    this.onTap,
    this.hasGlow = false,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.surfaceBorder;
    final effectiveBgColor = backgroundColor ?? AppColors.surfaceCard;

    Widget cardWidget = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorderColor, width: 1.2),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: (glowColor ?? AppColors.cyanAccent).withOpacity(0.12),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                const BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}
