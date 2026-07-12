import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';

/// Animación de vinculación: reloj ↔ punto bluetooth ↔ teléfono
class PairingAnimation extends StatefulWidget {
  const PairingAnimation({super.key});

  @override
  State<PairingAnimation> createState() => _PairingAnimationState();
}

class _PairingAnimationState extends State<PairingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _pulseController;
  late AnimationController _btController;
  late Animation<double> _orbitAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _btAnim;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _orbitAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _orbitController, curve: Curves.linear),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _btController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _btAnim = Tween<double>(begin: 0.3, end: 1.0).animate(_btController);
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _btController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orbiting bluetooth dot
          AnimatedBuilder(
            animation: _orbitAnim,
            builder: (_, __) {
              return Transform.translate(
                offset: Offset(
                  36 * math.cos(_orbitAnim.value),
                  20 * math.sin(_orbitAnim.value),
                ),
                child: FadeTransition(
                  opacity: _btAnim,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: WatchColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: WatchColors.primary.withValues(alpha: 0.8),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Watch icon
          Positioned(
            left: 0,
            child: ScaleTransition(
              scale: _pulseAnim,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: WatchColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: WatchColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: const Icon(
                  Icons.watch,
                  color: WatchColors.primary,
                  size: 22,
                ),
              ),
            ),
          ),
          // Arrow
          const Positioned(
            left: 44,
            child: Icon(
              Icons.sync_alt,
              color: WatchColors.textMuted,
              size: 14,
            ),
          ),
          // Phone icon
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: WatchColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: WatchColors.textMuted.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.smartphone,
                color: WatchColors.textSecondary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
