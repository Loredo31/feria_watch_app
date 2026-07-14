import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';

class SimulationButtons extends StatelessWidget {
  final VoidCallback onReminderTap;
  final VoidCallback onAlertTap;

  const SimulationButtons({
    super.key,
    required this.onReminderTap,
    required this.onAlertTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
        color: WatchColors.surfaceLight,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: WatchColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '— SIMULACIÓN —',
            style: TextStyle(
              color: WatchColors.textMuted,
              fontSize: 6,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onReminderTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: WatchColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: WatchColors.warning.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_active,
                            color: WatchColors.warning, size: 10),
                        SizedBox(width: 2),
                        Text(
                          'W-05',
                          style: TextStyle(
                            color: WatchColors.warning,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: onAlertTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: WatchColors.alert.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: WatchColors.alert.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_rounded,
                            color: WatchColors.alert, size: 10),
                        SizedBox(width: 2),
                        Text(
                          'W-07',
                          style: TextStyle(
                            color: WatchColors.alert,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
