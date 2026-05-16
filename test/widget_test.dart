import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:electronichub/main.dart';

void main() {
  testWidgets('App launches and shows sign-in screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app shows the sign-in screen
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(
      find.byType(TextFormField),
      findsNWidgets(2),
    ); // email and password fields
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Navigate to sign-up screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify we're on sign-in screen first
    expect(find.text('Welcome Back'), findsOneWidget);

    // Find the Sign Up button and ensure it's visible
    final signUpButton = find.text('Sign Up');
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    // Verify sign-up screen is displayed
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Sign up to get started'), findsOneWidget);
    expect(find.byKey(const Key('nameField')), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('confirmPasswordField')), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Form validation on sign-in', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Try to submit empty form
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Should show validation errors
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Password visibility toggle works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find the visibility toggle icon (initially visibility_off for obscured password)
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsNothing);

    // Tap visibility toggle
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    // Icon should change to visibility (password now visible)
    expect(find.byIcon(Icons.visibility), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsNothing);
  });
}
