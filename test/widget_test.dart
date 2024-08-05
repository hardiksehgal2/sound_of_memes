// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:ventures/main.dart';

// ignore: depend_on_referenced_packages

void main() {
  testWidgets('SignIn screen appears when not logged in', (WidgetTester tester) async {
    // Provide a value for `isLoggedIn`.
    await tester.pumpWidget(MyApp(isLoggedIn: false));

    // Verify that the SignIn screen is displayed.
    expect(find.text('Sign In'), findsOneWidget); // Adjust based on actual widget text or properties in SignIn screen
  });

  testWidgets('HomeScreen appears when logged in', (WidgetTester tester) async {
    // Provide a value for `isLoggedIn`.
    await tester.pumpWidget(MyApp(isLoggedIn: true));

    // Verify that the HomeScreen is displayed.
    expect(find.text('Home Screen Title'), findsOneWidget); // Adjust based on actual widget text or properties in HomeScreen
  });
}
