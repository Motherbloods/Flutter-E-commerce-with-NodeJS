import 'package:ecommerce/ui/user/form_data.dart';
import 'package:flutter/gestures.dart';
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
      await tester.pumpAndSettle(Duration(seconds: 10));

      // Check for success message or error message
      expect(find.textContaining('Recommendations'), findsOneWidget);

      // Wait for navigation
      await tester.pumpAndSettle(Duration(seconds: 10));

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
      await tester.pumpAndSettle(Duration(seconds: 10));

      // Check for error message
      expect(find.textContaining('Invalid credentials'), findsOneWidget);
    });

    testWidgets('Register redirect test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find the RichText widget by its key
      final richTextFinder = find.byKey(const Key('registerRichText'));
      expect(richTextFinder, findsOneWidget);

      // Get the RichText widget
      final RichText richText = tester.widget(richTextFinder);

      // Get the TextSpan
      final TextSpan textSpan = richText.text as TextSpan;

      // Find the "Register" TextSpan
      final registerSpan = textSpan.children!
              .firstWhere((span) => span is TextSpan && span.text == 'Register')
          as TextSpan;

      // Cast the recognizer to TapGestureRecognizer and trigger the onTap function
      final TapGestureRecognizer tapRecognizer =
          registerSpan.recognizer! as TapGestureRecognizer;
      tapRecognizer.onTap!();

      // Rebuild the widget tree
      await tester.pumpAndSettle();
      final emailField = find.byKey(Key('emailField'));
      final passField = find.byKey(Key('passField'));
      final confPassField = find.byKey(Key('confPassField'));

      await tester.enterText(emailField, 'brooo@example.com');
      await tester.enterText(passField, 'halo');
      await tester.enterText(confPassField, 'halo');

      await tester.tap(find.byKey(Key('button')));
      print('Register button tapped');

      // Tunggu dan log setiap detik
      for (int i = 1; i <= 15; i++) {
        await tester.pump(Duration(seconds: 1));
        print('Waited $i seconds');
        if (find.byType(FormDataUser).evaluate().isNotEmpty) {
          print('FormDataUser found after $i seconds');
          break;
        }
      }

      print('Checking for FormDataUser');
      // Verify we're on the FormDataUser page and handle the alert
      expect(find.byType(FormDataUser), findsOneWidget);
      expect(find.text('Lengkapi Profil'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Fill out the form fields
      await tester.enterText(find.byKey(Key('firstname')), 'John');
      await tester.enterText(find.byKey(Key('lastname')), 'Doe');
      await tester.enterText(find.byKey(Key('username')), 'johndoe');
      await tester.enterText(find.byKey(Key('alamat')), '123 Main St');
      await tester.tap(find.text('Simpan'));
      // Check if we're on the RegisterPage
      expect(find.byType(LoginPage), findsOneWidget);
      final email = find.byKey(Key('emailField'));
      final pass = find.byKey(Key('passField'));

      await tester.enterText(email, 'brooo@example.com');
      await tester.enterText(pass, 'halo');

      await tester.tap(find.byKey(Key('button')));

      // Wait for the API call to complete
      await tester.pumpAndSettle(Duration(seconds: 10));

      // Check for success message or error message
      expect(find.textContaining('Recommendations'), findsOneWidget);

      // Wait for navigation
      await tester.pumpAndSettle(Duration(seconds: 10));

      expect(find.byType(MainScreen), findsOneWidget);
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
