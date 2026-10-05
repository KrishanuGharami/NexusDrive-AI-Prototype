import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/nexus_card.dart';
import '../../../data/models/vehicle_model.dart';

class VehicleSelector extends StatelessWidget {
  final VehicleModel selectedVehicle;
  final Function(VehicleModel) onVehicleSelected;

  const VehicleSelector({
    super.key,
    required this.selectedVehicle,
    required this.onVehicleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NexusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.directions_car_filled_rounded, color: AppColors.cyanAccent, size: 18),
              SizedBox(width: 8),
              Text(
                'VEHICLE PROFILE & BATTERY CAPACITY',
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
            children: VehicleModel.defaultVehicles.map((vehicle) {
              final isSelected = selectedVehicle.id == vehicle.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cyanAccent.withOpacity(0.12) : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.cyanAccent : AppColors.surfaceBorderSubtle,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    dense: true,
                    title: Text(
                      vehicle.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    subtitle: Text(
                      '${vehicle.batteryCapacityKwh} kWh Pack • Max DC: ${vehicle.maxChargingSpeedKw.toInt()} kW • ${vehicle.supportedPlugTypes.join(', ')}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.cyanAccent, size: 18)
                        : null,
                    onTap: () => onVehicleSelected(vehicle),
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
