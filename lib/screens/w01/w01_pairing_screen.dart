import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/watch_theme.dart';
import '../../widgets/widgets.dart';
import '../../providers/watch_state.dart';

class W01PairingScreen extends StatelessWidget {
  final VoidCallback onPaired;

  const W01PairingScreen({super.key, required this.onPaired});

  @override
  Widget build(BuildContext context) {
    final watchState = context.watch<WatchState>();

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

              StatusIndicator(
                label: watchState.connectionStatus,
                type: watchState.connectionType,
              ),

              const SizedBox(height: 10),

              WatchButton(
                label: 'VINCULAR AHORA',
                onTap: () {
                  watchState.connect();
                  watchState.requestManualSync();
                },
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

