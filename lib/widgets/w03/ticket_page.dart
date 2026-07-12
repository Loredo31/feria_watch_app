import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../theme/watch_theme.dart';
import '../../models/models.dart';

/// Página individual de boleto con QR, nombre, fecha, tipo y estado
class TicketPage extends StatelessWidget {
  final TicketModel ticket;
  final Color typeColor;

  const TicketPage({
    super.key,
    required this.ticket,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // QR Container
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: QrImageView(
            data: ticket.qrData,
            version: QrVersions.auto,
            size: 92,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
          ),
        ),

        const SizedBox(height: 5),

        // Holder name
        Text(
          ticket.holderName,
          style: const TextStyle(
            color: WatchColors.textPrimary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 2),

        // Date + Type row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ticket.eventDate,
              style: const TextStyle(
                color: WatchColors.textMuted,
                fontSize: 8,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: typeColor.withValues(alpha: 0.5)),
              ),
              child: Text(
                ticket.ticketType,
                style: TextStyle(
                  color: typeColor,
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: ticket.isUsed
                ? WatchColors.textMuted.withValues(alpha: 0.12)
                : WatchColors.success.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ticket.isUsed
                  ? WatchColors.textMuted.withValues(alpha: 0.4)
                  : WatchColors.success.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                ticket.isUsed ? Icons.cancel_outlined : Icons.verified,
                color:
                    ticket.isUsed ? WatchColors.textMuted : WatchColors.success,
                size: 9,
              ),
              const SizedBox(width: 3),
              Text(
                ticket.isUsed ? 'Ya utilizado' : 'Válido',
                style: TextStyle(
                  color: ticket.isUsed
                      ? WatchColors.textMuted
                      : WatchColors.success,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}