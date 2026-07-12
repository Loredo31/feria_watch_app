import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';

/// Campana animada con efecto de rotación y resplandor para la pantalla de recordatorio
class AnimatedBell extends StatefulWidget {
  const AnimatedBell({super.key});

  @override
  State<AnimatedBell> createState() => _AnimatedBellState();
}

class _AnimatedBellState extends State<AnimatedBell>
    with TickerProviderStateMixin {
  late AnimationController _bellController;
  late AnimationController _glowController;
  late Animation<double> _bellAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);
    _bellAnim = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _bellController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bellController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bellAnim,
      builder: (_, child) => Transform.rotate(
        angle: _bellAnim.value,
        child: child,
      ),
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, child) => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: WatchColors.warning.withValues(alpha: 0.1),
            boxShadow: [
              BoxShadow(
                color: WatchColors.warning
                    .withValues(alpha: _glowAnim.value * 0.5),
                blurRadius: 18,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_active,
            color: WatchColors.warning,
            size: 28,
          ),
        ),
      ),
    );
  }
}
