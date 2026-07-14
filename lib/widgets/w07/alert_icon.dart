import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';
import '../../models/models.dart';

class AlertIcon extends StatelessWidget {
  final Animation<double> scaleAnim;
  final AlertUrgency urgency;

  const AlertIcon({
    super.key,
    required this.scaleAnim,
    required this.urgency,
  });

  Color get _color =>
      urgency == AlertUrgency.emergency ? WatchColors.alert : WatchColors.warning;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnim,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _color.withValues(alpha: 0.15),
          border: Border.all(
            color: _color.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Icon(
          urgency == AlertUrgency.emergency
              ? Icons.emergency
              : Icons.warning_amber_rounded,
          color: _color,
          size: 24,
        ),
      ),
    );
  }
}
