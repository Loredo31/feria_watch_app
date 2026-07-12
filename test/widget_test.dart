import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:feria_watch_app/main.dart';
import 'package:feria_watch_app/screens/w03_tickets_screen.dart';

void main() {
  testWidgets('App smoke test - verifies pairing screen loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FeriaWatchApp());

    // Verify that the pairing screen details are shown.
    expect(find.text('VINCULAR AHORA'), findsOneWidget);
    expect(find.text('Buscando teléfono...'), findsOneWidget);
  });

  testWidgets('W03TicketsScreen - infinite carousel swipe test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: W03TicketsScreen(onBack: () {}),
      ),
    ));

    // Initially, it should show the first ticket: VIP (Jory Bravo)
    expect(find.text('VIP'), findsOneWidget);
    expect(find.text('General'), findsNothing);
    expect(find.text('Familiar'), findsNothing);

    // Swipe left (drag from right to left) to go to next ticket (General)
    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    // Now it should show General (Jory Bravo)
    expect(find.text('General'), findsOneWidget);
    expect(find.text('VIP'), findsNothing);

    // Swipe right (drag from left to right) to go back to VIP
    await tester.drag(find.byType(PageView), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(find.text('VIP'), findsOneWidget);

    // Swipe right again (drag from left to right) to go to the previous virtual page,
    // which wraps around to index 2 (Familiar, Ana García)
    await tester.drag(find.byType(PageView), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Familiar'), findsOneWidget);
    expect(find.text('Ana García'), findsOneWidget);
  });

  testWidgets('App back navigation - PopScope intercepts and redirects to home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FeriaWatchApp());

    // 1. Move from Pairing screen to Home screen by tapping the pairing button
    await tester.tap(find.text('VINCULAR AHORA'));
    await tester.pump(); // Start simulation
    // Wait for the simulated pairing timer to complete (2 seconds + 0.8 seconds)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Now we should be on the home screen
    expect(find.text('MI BOLETO QR'), findsOneWidget);

    // 2. Go to Tickets Screen
    await tester.tap(find.text('MI BOLETO QR'));
    await tester.pumpAndSettle();

    // Now we are on the tickets screen
    expect(find.text('Mis Boletos QR'), findsOneWidget);

    // 3. Simulate system back button/gesture
    final dynamic widgetsBinding = tester.binding;
    final bool handled = await widgetsBinding.handlePopRoute();
    
    // We expect handlePopRoute to return true because it was intercepted by PopScope, 
    // rather than false which would let the app exit
    expect(handled, isTrue);
    await tester.pumpAndSettle();

    // 4. Verify we are back on the Home screen instead of having exited
    expect(find.text('MI BOLETO QR'), findsOneWidget);
    expect(find.text('Mis Boletos QR'), findsNothing);
  });
}

