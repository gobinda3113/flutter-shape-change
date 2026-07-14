import 'package:flutter_test/flutter_test.dart';
import 'package:image_shape_masking_studio/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Image Shape Masking'), findsOneWidget);
  });
}
