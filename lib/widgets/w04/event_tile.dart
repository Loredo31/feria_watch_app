import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';
import '../../models/models.dart';

class EventTile extends StatelessWidget {
  final AgendaEvent event;
  final Color statusColor;
  final String statusLabel;
  final VoidCallback onTap;

  const EventTile({
    super.key,
    required this.event,
    required this.statusColor,
    required this.statusLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final finished = event.status == EventStatus.finished;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: event.status == EventStatus.ongoing
              ? WatchColors.success.withValues(alpha: 0.08)
              : WatchColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: event.status == EventStatus.ongoing
                ? WatchColors.success.withValues(alpha: 0.4)
                : WatchColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              child: Text(
                event.time,
                style: TextStyle(
                  color: finished ? WatchColors.textMuted : WatchColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Container(
              width: 2,
              height: 26,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(1),
              ),
            ),

            const SizedBox(width: 7),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.shortName,
                    style: TextStyle(
                      color: finished
                          ? WatchColors.textMuted
                          : WatchColors.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      decoration: finished
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    event.location,
                    style: const TextStyle(
                      color: WatchColors.textMuted,
                      fontSize: 8,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                boxShadow: event.status == EventStatus.ongoing
                    ? [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.5),
                          blurRadius: 5,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
