import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class StatusIndicator extends StatelessWidget {
  final String label;
  final String status;
  final IconData icon;
  final Color activeColor;
  final bool isHighlight;

  const StatusIndicator({
    super.key,
    required this.label,
    required this.status,
    required this.icon,
    this.activeColor = AppColors.cyanAccent,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHighlight ? activeColor.withOpacity(0.4) : AppColors.surfaceBorderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: activeColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 13, color: activeColor),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                  letterSpacing: 0.4,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: activeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
