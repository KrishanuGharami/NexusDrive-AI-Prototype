import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';

class OptimizationSelector extends StatelessWidget {
  final String selectedPreference;
  final Function(String) onPreferenceChanged;

  const OptimizationSelector({
    super.key,
    required this.selectedPreference,
    required this.onPreferenceChanged,
  });

  @override
  Widget build(BuildContext context) {
    const preferences = [
      {
        'title': 'Energy Efficient',
        'subtitle': 'Prioritizes lower kWh/km and regenerative braking zones',
        'icon': Icons.eco_rounded,
        'color': AppColors.batterySafe,
      },
      {
        'title': 'Battery Safe',
        'subtitle': 'Guarantees highest arrival reserve with maximum charging hubs',
        'icon': Icons.security_rounded,
        'color': AppColors.cyanAccent,
      },
      {
        'title': 'Fastest',
        'subtitle': 'Prioritizes lowest transit duration; higher energy consumption',
        'icon': Icons.electric_bolt_rounded,
        'color': AppColors.batteryWarning,
      },
    ];

    return NexusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune_rounded, color: AppColors.cyanAccent, size: 18),
              SizedBox(width: 8),
              Text(
                'EDGE ROUTE STRATEGY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: preferences.map((pref) {
              final title = pref['title'] as String;
              final isSelected = selectedPreference == title;
              final color = pref['color'] as Color;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.12) : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : AppColors.surfaceBorderSubtle,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withOpacity(0.2) : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(pref['icon'] as IconData, color: isSelected ? color : AppColors.textSecondary, size: 20),
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    subtitle: Text(
                      pref['subtitle'] as String,
                      style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: color, size: 20)
                        : const Icon(Icons.radio_button_unchecked_rounded, color: AppColors.textTertiary, size: 18),
                    onTap: () => onPreferenceChanged(title),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
