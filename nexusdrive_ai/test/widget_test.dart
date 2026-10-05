import 'package:flutter_test/flutter_test.dart';
import 'package:nexusdrive_ai/app/app.dart';

void main() {
  testWidgets('NexusDriveApp launches and builds navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(const NexusDriveApp());
    expect(find.text('Copilot'), findsOneWidget);
    expect(find.text('Journey'), findsOneWidget);
    expect(find.text('Telemetry'), findsOneWidget);
  });
}
