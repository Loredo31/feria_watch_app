import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/watch_theme.dart';
import 'screens/screens.dart';
import 'models/models.dart';
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
        home: const WatchSimulatorPage(),
      ),
    );
  }
}

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
  WatchScreen? _previous;
  String? _highlightedMapLocation;
  AgendaEvent? _selectedAgendaEvent;

  void _navigate(WatchScreen screen) {
    setState(() {
      _previous = _current;
      _current = screen;
      if (screen != WatchScreen.w04Agenda && screen != WatchScreen.w06Map) {
        _selectedAgendaEvent = null;
        _highlightedMapLocation = null;
      }
    });
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
          initialSelectedEvent: _selectedAgendaEvent,
          onEventSelected: (evt) {
            setState(() {
              _selectedAgendaEvent = evt;
            });
          },
          onViewMap: (evt) {
            setState(() {
              _selectedAgendaEvent = evt;
              _highlightedMapLocation = evt.location;
              _previous = WatchScreen.w04Agenda;
              _current = WatchScreen.w06Map;
            });
          },
        );
      case WatchScreen.w05Reminder:
        return W05ReminderScreen(
          onViewMap: () {
            setState(() {
              final active = context.read<WatchState>().activeReminder;
              _highlightedMapLocation = active?.location ?? 'Escenario Principal';
              _previous = WatchScreen.w05Reminder;
              _current = WatchScreen.w06Map;
            });
          },
          onDismiss: () {
            context.read<WatchState>().dismissReminder();
            _navigate(WatchScreen.w02Home);
          },
        );
      case WatchScreen.w06Map:
        return W06MapScreen(
          highlightLocation: _highlightedMapLocation,
          fromAgenda: _previous == WatchScreen.w04Agenda,
          onBack: () => _navigate(WatchScreen.w02Home),
          onAgendaTap: () {
            setState(() {
              _current = WatchScreen.w04Agenda;
            });
          },
        );
      case WatchScreen.w07Alert:
        return W07AlertScreen(
          onDismiss: () {
            context.read<WatchState>().dismissAlert();
            _navigate(WatchScreen.w02Home);
          },
          onViewMap: (location) {
            setState(() {
              _highlightedMapLocation = location;
              _previous = WatchScreen.w07Alert;
              _current = WatchScreen.w06Map;
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchState = context.watch<WatchState>();

    if (!watchState.isLoggedIn || !watchState.wearConnected) {
      if (_current != WatchScreen.w01Pairing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _current = WatchScreen.w01Pairing;
            });
          }
        });
      }
    } else if (_current == WatchScreen.w01Pairing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _current = WatchScreen.w02Home;
          });
        }
      });
    }

    if (watchState.activeAlert != null && 
        _current != WatchScreen.w07Alert && 
        _current != WatchScreen.w06Map) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _current = WatchScreen.w07Alert;
          });
        }
      });
    } else if (watchState.activeReminder != null && 
               _current != WatchScreen.w05Reminder && 
               _current != WatchScreen.w06Map &&
               watchState.activeAlert == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _current = WatchScreen.w05Reminder;
          });
        }
      });
    }

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