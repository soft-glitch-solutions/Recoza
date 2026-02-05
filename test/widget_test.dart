import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/app.dart';
import 'package:myapp/constants/strings.dart';

void main() {
  testWidgets('Onboarding screen has a get started button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RecozaApp());

    // Verify that the Get Started button is present.
    expect(find.text(AppsStrings.getStarted), findsOneWidget);
  });
}
