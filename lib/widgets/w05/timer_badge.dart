import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';

/// Badge de cuenta regresiva: "Comienza en X minutos"
class TimerBadge extends StatelessWidget {
  final String label;

  const TimerBadge({super.key, this.label = 'Comienza en 10 minutos'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: WatchColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WatchColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: WatchColors.warning, size: 11),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: WatchColors.warning,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
