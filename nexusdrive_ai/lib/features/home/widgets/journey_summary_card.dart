import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../core/widgets/primary_button.dart';

class JourneySummaryCard extends StatelessWidget {
  final String destination;
  final String drivingPreference;
  final VoidCallback onPlanPressed;
  final VoidCallback onChangeDestinationPressed;

  const JourneySummaryCard({
    super.key,
    required this.destination,
    required this.drivingPreference,
    required this.onPlanPressed,
    required this.onChangeDestinationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.navigation_rounded, color: AppColors.cyanAccent, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'PLANNED DESTINATION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onChangeDestinationPressed,
                child: const Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyanAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            destination,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.electricBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Mode: $drivingPreference',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.electricBlue,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Bengaluru Urban Hub',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Plan Journey & Analyze Routes',
            icon: Icons.alt_route_rounded,
            onPressed: onPlanPressed,
          ),
        ],
      ),
    );
  }
}
