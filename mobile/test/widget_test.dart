import 'package:flutter_test/flutter_test.dart';
import 'package:agribridge/main.dart';

void main() {
  testWidgets('AgribridgeApp loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AgribridgeApp());
    expect(find.text('Agribridge'), findsWidgets);
  });
}
