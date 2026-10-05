import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../domain/entities/route.dart';
import '../../../domain/entities/telemetry.dart';
import '../../../services/ai/explanation_service.dart';

class RouteExplanationCard extends StatelessWidget {
  final RouteEntity route;
  final TelemetryEntity telemetry;
  final ExplanationService explanationService;

  const RouteExplanationCard({
    super.key,
    required this.route,
    required this.telemetry,
    required this.explanationService,
  });

  @override
  Widget build(BuildContext context) {
    final factors = explanationService.generateFactorBreakdown(route, telemetry);

    return NexusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.cyanAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.psychology_rounded, color: AppColors.cyanAccent, size: 18),
              ),
              const SizedBox(width: 8),
              const Text(
                'WHY THIS ROUTE? (EDGE AI REASONING)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.cyanAccent,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.surfaceBorderSubtle),
            ),
            child: Text(
              route.explanation,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'MULTI-VARIABLE FACTOR BREAKDOWN',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textTertiary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: factors.map((f) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          f.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${(f.score * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: f.score >= 0.7 ? AppColors.batterySafe : AppColors.batteryWarning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: f.score,
                        backgroundColor: AppColors.surfaceElevated,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          f.score >= 0.7 ? AppColors.batterySafe : AppColors.batteryWarning,
                        ),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      f.description,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
