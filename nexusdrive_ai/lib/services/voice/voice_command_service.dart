import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum VoiceIntent {
  optimizeBattery,
  optimizeFastest,
  optimizeEnergy,
  activateBatteryRescue,
  unknown,
}

class VoiceCommandResult {
  final String recognizedText;
  final VoiceIntent intent;
  final String actionDescription;

  const VoiceCommandResult({
    required this.recognizedText,
    required this.intent,
    required this.actionDescription,
  });
}

class VoiceCommandService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  bool get isAvailable => _isInitialized;

  Future<bool> initialize() async {
    try {
      _isInitialized = await _speechToText.initialize(
        onError: (val) => debugPrint('SpeechToText onError: $val'),
        onStatus: (val) => debugPrint('SpeechToText onStatus: $val'),
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('SpeechToText init exception: $e');
      _isInitialized = false;
      return false;
    }
  }

  Future<void> startListening({
    required Function(VoiceCommandResult) onResult,
    required Function(bool isListening) onListeningStateChanged,
  }) async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) {
        onListeningStateChanged(false);
        return;
      }
    }

    onListeningStateChanged(true);

    try {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult || result.recognizedWords.isNotEmpty) {
            final text = result.recognizedWords.toLowerCase();
            final intent = _parseIntent(text);
            onResult(
              VoiceCommandResult(
                recognizedText: result.recognizedWords,
                intent: intent,
                actionDescription: _getIntentDescription(intent),
              ),
            );
          }
        },
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('Speech listening error: $e');
      onListeningStateChanged(false);
    }
  }

  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
    } catch (_) {}
  }

  /// Parses voice transcripts into deterministic navigation & EV commands
  VoiceIntent _parseIntent(String text) {
    if (text.contains('battery') || text.contains('safe') || text.contains('conserve')) {
      return VoiceIntent.optimizeBattery;
    } else if (text.contains('fast') || text.contains('quick') || text.contains('speed')) {
      return VoiceIntent.optimizeFastest;
    } else if (text.contains('energy') || text.contains('efficient') || text.contains('eco')) {
      return VoiceIntent.optimizeEnergy;
    } else if (text.contains('rescue') || text.contains('charge') || text.contains('charging')) {
      return VoiceIntent.activateBatteryRescue;
    }
    return VoiceIntent.unknown;
  }

  String _getIntentDescription(VoiceIntent intent) {
    switch (intent) {
      case VoiceIntent.optimizeBattery:
        return 'Updated driving preference to Battery Safe mode.';
      case VoiceIntent.optimizeFastest:
        return 'Updated driving preference to Fastest route.';
      case VoiceIntent.optimizeEnergy:
        return 'Updated driving preference to Energy Efficient mode.';
      case VoiceIntent.activateBatteryRescue:
        return 'Emergency Battery Rescue mode triggered.';
      case VoiceIntent.unknown:
        return 'Voice command recognized. Analyzing intent...';
    }
  }
}
