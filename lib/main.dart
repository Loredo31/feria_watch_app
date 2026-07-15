import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/watch_theme.dart';
import 'screens/screens.dart';
import 'providers/watch_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const FeriaWatchApp());
}

class FeriaWatchApp extends StatelessWidget {
  const FeriaWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WatchState>(
      create: (_) => WatchState(),
      child: MaterialApp(
        title: 'Mi Feria Inteligente — Smartwatch',
        debugShowCheckedModeBanner: false,
        theme: WatchTheme.theme,
        home: const WatchAppNavigator(),
      ),
    );
  }
}

class WatchAppNavigator extends StatelessWidget {
  const WatchAppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final watchState = context.watch<WatchState>();
    final isLoggedIn = watchState.isLoggedIn && watchState.wearConnected;

    if (!isLoggedIn) {
      return W01PairingScreen(onPaired: () {});
    }

    if (watchState.activeAlert != null) {
      return W07AlertScreen(
        onDismiss: () => watchState.dismissAlert(),
        onViewMap: (location) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => W06MapScreen(
                highlightLocation: location,
                onBack: () => Navigator.of(context).pop(),
              ),
            ),
          );
        },
      );
    }

    if (watchState.activeReminder != null) {
      return W05ReminderScreen(
        onDismiss: () => watchState.dismissReminder(),
        onViewMap: () {
          final active = watchState.activeReminder;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => W06MapScreen(
                highlightLocation: active?.location ?? 'Escenario Principal',
                onBack: () => Navigator.of(context).pop(),
              ),
            ),
          );
        },
      );
    }

    return W02HomeScreen(
      onQrTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => W03TicketsScreen(
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
      onAgendaTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => W04AgendaScreen(
              onBack: () => Navigator.of(context).pop(),
              onViewMap: (evt) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => W06MapScreen(
                      highlightLocation: evt.location,
                      fromAgenda: true,
                      onBack: () => Navigator.of(context).pop(),
                      onAgendaTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      onReminderTap: () {},
      onAlertTap: () {},
    );
  }
}