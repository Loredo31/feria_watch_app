import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';
import '../../models/models.dart';

/// Tarjeta compacta que muestra el próximo evento con cuenta regresiva
class NextEventCard extends StatelessWidget {
  final AgendaEvent event;
  final int countdown;

  const NextEventCard({
    super.key,
    required this.event,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: WatchColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: WatchColors.primary.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: WatchColors.primary.withValues(alpha: 0.06),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(event.icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.shortName,
                  style: const TextStyle(
                    color: WatchColors.textPrimary,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'en $countdown min',
                  style: const TextStyle(
                    color: WatchColors.warning,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
