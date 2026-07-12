import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';
import '../../models/models.dart';

/// Overlay de detalle de evento (se muestra al tocar un EventTile)
class EventDetail extends StatelessWidget {
  final AgendaEvent event;
  final VoidCallback onClose;

  const EventDetail({
    super.key,
    required this.event,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final margin = MediaQuery.sizeOf(context).width * 0.09;
    return Container(
      margin: EdgeInsets.all(margin),
      padding: const EdgeInsets.all(14),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - margin * 2,
      ),
      decoration: BoxDecoration(
        color: WatchColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WatchColors.primary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: WatchColors.primary.withValues(alpha: 0.12),
            blurRadius: 20,
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(event.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              event.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: WatchColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            DetailRow(icon: Icons.location_on, text: event.location),
            DetailRow(
                icon: Icons.access_time,
                text: '${event.time} – ${event.endTime}'),
            DetailRow(icon: Icons.timelapse, text: event.duration),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  color: WatchColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: WatchColors.primary.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(
                    color: WatchColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fila de detalle con ícono y texto
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: WatchColors.primary, size: 10),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: WatchColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}