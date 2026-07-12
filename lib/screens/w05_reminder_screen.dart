import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../theme/watch_theme.dart';

class W05ReminderScreen extends StatelessWidget {
  final VoidCallback onViewMap;
  final VoidCallback onDismiss;

  const W05ReminderScreen({
    super.key,
    required this.onViewMap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.0,
          colors: [Color(0xFFFFF8E0), WatchColors.background],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: WatchMetrics.side(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campana animada
              const AnimatedBell(),

              const SizedBox(height: 6),

              const Text(
                '¡Recordatorio!',
                style: TextStyle(
                  color: WatchColors.warning,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Concierto de Mariachi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: WatchColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'Escenario Principal',
                style: TextStyle(
                  color: WatchColors.textSecondary,
                  fontSize: 9,
                ),
              ),

              const SizedBox(height: 6),

              // Badge de tiempo restante
              const TimerBadge(),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WatchButton(
                    label: 'VER MAPA',
                    onTap: onViewMap,
                    color: WatchColors.primary,
                    icon: Icons.map_outlined,
                    small: true,
                  ),
                  const SizedBox(width: 8),
                  WatchButton(
                    label: 'CERRAR',
                    onTap: onDismiss,
                    color: WatchColors.surfaceLight,
                    textColor: WatchColors.textSecondary,
                    small: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
