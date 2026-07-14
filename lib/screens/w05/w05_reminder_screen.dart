import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';
import '../../theme/watch_theme.dart';
import '../../providers/watch_state.dart';

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
    final watchState = context.watch<WatchState>();
    final active = watchState.activeReminder;

    final title = active?.name ?? 'Concierto de Mariachi';
    final location = active?.location ?? 'Escenario Principal';
    final minutes = watchState.reminderMinutes;

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

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: WatchColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                location,
                style: const TextStyle(
                  color: WatchColors.textSecondary,
                  fontSize: 9,
                ),
              ),

              const SizedBox(height: 6),

              // Badge de tiempo restante
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: WatchColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Comienza en $minutes min',
                  style: const TextStyle(
                    color: WatchColors.warning,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

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

