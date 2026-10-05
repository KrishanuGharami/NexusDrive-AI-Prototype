import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/nexus_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/models/vehicle_model.dart';
import '../../demo/demo_controller.dart';
import '../../services/camera/battery_ocr_service.dart';
import '../../services/office_kit/office_kit_bridge.dart';

class SettingsScreen extends StatelessWidget {
  final DemoController demoController;
  final OfficeKitBridge officeKitBridge;
  final BatteryOcrService ocrService;

  const SettingsScreen({
    super.key,
    required this.demoController,
    required this.officeKitBridge,
    required this.ocrService,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: demoController,
      builder: (context, _) {
        final ctrl = demoController;

        return Scaffold(
          appBar: AppBar(
            title: const Text('System Settings & Vehicle Profile'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Profile
                _buildSectionHeader('VEHICLE PROFILE'),
                const SizedBox(height: 8),
                NexusCard(
                  child: Column(
                    children: VehicleModel.defaultVehicles.map((v) {
                      final isSelected = ctrl.selectedVehicle.id == v.id;
                      return Material(
                        color: Colors.transparent,
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.ev_station_rounded,
                            color: isSelected ? AppColors.cyanAccent : AppColors.textTertiary,
                          ),
                          title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          subtitle: Text('${v.batteryCapacityKwh} kWh • Max DC ${v.maxChargingSpeedKw.toInt()} kW', style: const TextStyle(fontSize: 11)),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.cyanAccent)
                              : null,
                          onTap: () => ctrl.setVehicle(v),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Camera Dashboard Battery OCR (Priority 2)
                _buildSectionHeader('CAMERA / DASHBOARD OCR (PRIORITY 2)'),
                const SizedBox(height: 8),
                NexusCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Scan EV Instrument Cluster MID',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Optical recognition reads the physical dashboard display if OBD-II/BLE telemetry is inaccessible.',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        label: 'Simulate Dashboard Optical Scan',
                        icon: Icons.camera_alt_rounded,
                        onPressed: () async {
                          final result = await ocrService.scanClusterDisplay();
                          ctrl.setDemoMode(true);
                          ctrl.setBatteryPercent(result.detectedBatteryPercent);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('OCR Success: Detected ${result.detectedBatteryPercent.toInt()}% SoC via ${result.sourceLabel}'),
                                backgroundColor: AppColors.surfaceElevated,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Office Kit Integration
                _buildSectionHeader('OFFICE KIT / PC SYNERGY'),
                const SizedBox(height: 8),
                NexusCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            officeKitBridge.pairedDevice.deviceName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.batterySafe.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('CONNECTED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.batterySafe)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('IP: ${officeKitBridge.pairedDevice.ipAddress} • Protocol: ${officeKitBridge.pairedDevice.protocolVersion}', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                      const SizedBox(height: 10),
                      const Text(
                        'Seamlessly casts route telemetry, edge inferences, and battery rescue directives to PC screen during demo.',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Submission & Grand Finale Info
                _buildSectionHeader('EVENT METADATA'),
                const SizedBox(height: 8),
                NexusCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('iQOO Hackathon 2026 Grand Finale', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.cyanAccent)),
                      const SizedBox(height: 4),
                      const Text('Track: Mobility • Bengaluru Grand Finale', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const Text('Participant: Solo, Working Professional', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      const Text(
                        'NexusDrive AI addresses the critical EV challenge of connectivity drops and accurate energy decision making using pure offline edge copilot intelligence.',
                        style: TextStyle(fontSize: 11, color: AppColors.textTertiary, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.textTertiary,
        letterSpacing: 0.6,
      ),
    );
  }
}
