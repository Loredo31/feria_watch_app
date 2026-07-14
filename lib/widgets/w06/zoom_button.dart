import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';

class ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ZoomButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: WatchColors.surface,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: WatchColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, color: WatchColors.textSecondary, size: 13),
      ),
    );
  }
}
