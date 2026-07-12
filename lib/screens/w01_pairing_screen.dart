import 'package:flutter/material.dart';
import '../theme/watch_theme.dart';
import '../widgets/widgets.dart';


class W01PairingScreen extends StatefulWidget {
  final VoidCallback onPaired;

  const W01PairingScreen({super.key, required this.onPaired});

  @override
  State<W01PairingScreen> createState() => _W01PairingScreenState();
}

class _W01PairingScreenState extends State<W01PairingScreen> {
  StatusType _status = StatusType.searching;
  String _statusLabel = 'Buscando teléfono...';

  void _simulatePairing() {
    setState(() {
      _status = StatusType.searching;
      _statusLabel = 'Conectando...';
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _status = StatusType.connected;
          _statusLabel = 'Conectado';
        });
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) widget.onPaired();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [Color(0xFFEDE8FF), WatchColors.background],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: WatchMetrics.side(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animación reloj ↔ teléfono
              const PairingAnimation(),

              const SizedBox(height: 8),

              const Text(
                'Abre la app en tu teléfono e inicia sesión para vincular',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: WatchColors.textSecondary,
                  fontSize: 9,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 8),

              StatusIndicator(label: _statusLabel, type: _status),

              const SizedBox(height: 10),

              WatchButton(
                label: 'VINCULAR AHORA',
                onTap: _simulatePairing,
                color: WatchColors.primary,
                icon: Icons.bluetooth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
