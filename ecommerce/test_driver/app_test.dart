import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ecommerce/main.dart' as app;
import 'package:ecommerce/ui/authpage/login.dart';
import 'package:ecommerce/ui/authpage/register.dart';
import 'package:ecommerce/ui/authpage/login_seller.dart';
import 'package:ecommerce/ui/main_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('LoginPage Integration Tests', () {
    testWidgets('Login flow test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);

      final emailField = find.byKey(Key('emailField'));
      final passField = find.byKey(Key('passField'));

      await tester.enterText(emailField, 'a');
      await tester.enterText(passField, 'a');

      await tester.tap(find.byKey(Key('button')));

      // Wait for the API call to complete
      await tester.pumpAndSettle(Duration(seconds: 5));

      // Check for success message or error message
      expect(find.textContaining('Login successful'), findsOneWidget);

      // Wait for navigation
      await tester.pumpAndSettle(Duration(seconds: 15));

      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('Login failure test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('emailField'));
      final passField = find.byKey(Key('passField'));

      await tester.enterText(emailField, 'wrong@example.com');
      await tester.enterText(passField, 'wrongpassword');

      await tester.tap(find.byKey(Key('button')));

      // Wait for the API call to complete
      await tester.pumpAndSettle(Duration(seconds: 5));

      // Check for error message
      expect(find.textContaining('Invalid credentials'), findsOneWidget);
    });

    testWidgets('Register redirect test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets('Login as seller redirect test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Login').last);
      await tester.pumpAndSettle();

      expect(find.byType(LoginPageSeller), findsOneWidget);
    });
  });
}
