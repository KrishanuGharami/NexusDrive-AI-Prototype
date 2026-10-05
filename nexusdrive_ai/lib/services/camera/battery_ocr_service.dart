class OcrExtractionResult {
  final double detectedBatteryPercent;
  final double confidence;
  final String sourceLabel;

  const OcrExtractionResult({
    required this.detectedBatteryPercent,
    required this.confidence,
    required this.sourceLabel,
  });
}

/// Abstract contract for reading EV instrument cluster / dashboard display
class BatteryOcrService {
  Future<OcrExtractionResult> scanClusterDisplay() async {
    // Simulated rapid OCR parser for EV instrument cluster
    await Future.delayed(const Duration(milliseconds: 800));
    return const OcrExtractionResult(
      detectedBatteryPercent: 74.0,
      confidence: 0.96,
      sourceLabel: 'Tata EV MID Optical Recognition',
    );
  }
}
