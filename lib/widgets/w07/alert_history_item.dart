import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';
import '../../models/models.dart';

/// Ítem individual en el historial de alertas
class AlertHistoryItem extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback onTap;

  const AlertHistoryItem({
    super.key,
    required this.alert,
    required this.onTap,
  });

  Color get _color => alert.urgency == AlertUrgency.emergency
      ? WatchColors.alert
      : WatchColors.warning;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(
              alert.urgency == AlertUrgency.emergency
                  ? Icons.emergency
                  : Icons.warning_amber_rounded,
              color: _color,
              size: 12,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: WatchColors.textPrimary,
                      fontSize: 9,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    alert.timestamp,
                    style: const TextStyle(
                      color: WatchColors.textMuted,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
