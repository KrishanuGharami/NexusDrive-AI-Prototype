import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/demo_constants.dart';
import '../../../core/widgets/nexus_card.dart';

class DestinationInput extends StatelessWidget {
  final String selectedDestination;
  final Function(String) onDestinationChanged;

  const DestinationInput({
    super.key,
    required this.selectedDestination,
    required this.onDestinationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.pin_drop_rounded, color: AppColors.cyanAccent, size: 18),
              SizedBox(width: 8),
              Text(
                'DESTINATION SELECTION',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedDestination,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'BENGALURU CORRIDORS (OFFLINE READY)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DemoConstants.sampleDestinations.map((dest) {
              final isSelected = selectedDestination == dest;
              return ChoiceChip(
                label: Text(dest),
                selected: isSelected,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.textInverse : AppColors.textSecondary,
                ),
                backgroundColor: AppColors.surfaceElevated,
                selectedColor: AppColors.cyanAccent,
                side: BorderSide(
                  color: isSelected ? AppColors.cyanAccent : AppColors.surfaceBorderSubtle,
                ),
                onSelected: (_) => onDestinationChanged(dest),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
