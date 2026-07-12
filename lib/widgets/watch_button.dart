import 'package:flutter/material.dart';
import '../theme/watch_theme.dart';

class WatchButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool small;

  const WatchButton({
    super.key,
    required this.label,
    this.onTap,
    this.color,
    this.textColor,
    this.icon,
    this.small = false,
  });

  @override
  State<WatchButton> createState() => _WatchButtonState();
}

class _WatchButtonState extends State<WatchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.color ?? WatchColors.primary;
    final fg = widget.textColor ?? Colors.white;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.small ? 10 : 14,
            vertical: widget.small ? 5 : 8,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: bg.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: fg, size: widget.small ? 12 : 14),
                const SizedBox(width: 4),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: fg,
                  fontSize: widget.small ? 9 : 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón circular de "regresar" para encabezados de pantalla
class WatchBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const WatchBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: WatchColors.surfaceLight,
          shape: BoxShape.circle,
          border: Border.all(color: WatchColors.border),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 10,
          color: WatchColors.textSecondary,
        ),
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusIndicator({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    switch (type) {
      case StatusType.connected:
        dotColor = WatchColors.secondary;
        break;
      case StatusType.searching:
        dotColor = WatchColors.warning;
        break;
      case StatusType.disconnected:
        dotColor = WatchColors.alert;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PulsingDot(color: dotColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: dotColor,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: widget.color.withValues(alpha: 0.6), blurRadius: 4),
          ],
        ),
      ),
    );
  }
}

enum StatusType { connected, searching, disconnected }
