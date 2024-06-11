import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:weather_proj/screens/my_home_page.dart';

void main() {
  testWidgets('MyHomePage has a title and an AppBar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: MyHomePage(title: 'Test Home Page'),
    ));

    // Verify that our widget has a title.
    expect(find.text('Test Home Page'), findsOneWidget);

    // Verify that our widget has an AppBar.
    expect(find.byType(AppBar), findsOneWidget);
  });
}