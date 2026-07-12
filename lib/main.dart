import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/watch_theme.dart';
import 'screens/w01_pairing_screen.dart';
import 'screens/w02_home_screen.dart';
import 'screens/w03_tickets_screen.dart';
import 'screens/w04_agenda_screen.dart';
import 'screens/w05_reminder_screen.dart';
import 'screens/w06_map_screen.dart';
import 'screens/w07_alert_screen.dart';

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
    return MaterialApp(
      title: 'Mi Feria Inteligente — Smartwatch',
      debugShowCheckedModeBanner: false,
      theme: WatchTheme.theme,
      home: const WatchSimulatorPage(),
    );
  }
}

/// Navigator state for screens
enum WatchScreen {
  w01Pairing,
  w02Home,
  w03Tickets,
  w04Agenda,
  w05Reminder,
  w06Map,
  w07Alert,
}

class WatchSimulatorPage extends StatefulWidget {
  const WatchSimulatorPage({super.key});

  @override
  State<WatchSimulatorPage> createState() => _WatchSimulatorPageState();
}

class _WatchSimulatorPageState extends State<WatchSimulatorPage> {
  WatchScreen _current = WatchScreen.w01Pairing;

  void _navigate(WatchScreen screen) {
    setState(() => _current = screen);
  }

  Widget _buildScreen() {
    switch (_current) {
      case WatchScreen.w01Pairing:
        return W01PairingScreen(
          onPaired: () => _navigate(WatchScreen.w02Home),
        );
      case WatchScreen.w02Home:
        return W02HomeScreen(
          onQrTap: () => _navigate(WatchScreen.w03Tickets),
          onAgendaTap: () => _navigate(WatchScreen.w04Agenda),
          onReminderTap: () => _navigate(WatchScreen.w05Reminder),
          onAlertTap: () => _navigate(WatchScreen.w07Alert),
        );
      case WatchScreen.w03Tickets:
        return W03TicketsScreen(
          onBack: () => _navigate(WatchScreen.w02Home),
        );
      case WatchScreen.w04Agenda:
        return W04AgendaScreen(
          onBack: () => _navigate(WatchScreen.w02Home),
        );
      case WatchScreen.w05Reminder:
        return W05ReminderScreen(
          onViewMap: () => _navigate(WatchScreen.w06Map),
          onDismiss: () => _navigate(WatchScreen.w02Home),
        );
      case WatchScreen.w06Map:
        return W06MapScreen(
          onBack: () => _navigate(WatchScreen.w02Home),
        );
      case WatchScreen.w07Alert:
        return W07AlertScreen(
          onDismiss: () => _navigate(WatchScreen.w02Home),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // La pantalla física del reloj YA es redonda (el hardware/emulador
    // recorta las esquinas). Aquí solo llenamos ese rectángulo lógico
    // completo, sin cabecera de teléfono ni círculo decorativo extra:
    // eso era lo que sobraba y hacía que el contenido se viera
    // desproporcionado/alargado dentro del emulador Wear OS.
    final bool canPopDirectly = _current == WatchScreen.w01Pairing || _current == WatchScreen.w02Home;

    return PopScope(
      canPop: canPopDirectly,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() => _current = WatchScreen.w02Home);
      },
      child: Scaffold(
        backgroundColor: WatchColors.background,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: KeyedSubtree(
            key: ValueKey(_current),
            child: _buildScreen(),
          ),
        ),
      ),
    );
  }
}