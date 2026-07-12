import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/watch_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';


class W02HomeScreen extends StatefulWidget {
  final VoidCallback onQrTap;
  final VoidCallback onAgendaTap;
  final VoidCallback onReminderTap;
  final VoidCallback onAlertTap;

  const W02HomeScreen({
    super.key,
    required this.onQrTap,
    required this.onAgendaTap,
    required this.onReminderTap,
    required this.onAlertTap,
  });

  @override
  State<W02HomeScreen> createState() => _W02HomeScreenState();
}

class _W02HomeScreenState extends State<W02HomeScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late String _currentTime;
  int _countdown = 15;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _currentTime = _formatTime(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentTime = _formatTime(DateTime.now());
          if (_countdown > 0) _countdown--;
        });
      }
    });
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _timer.cancel();
    _slideController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  AgendaEvent get _nextEvent => mockAgendaEvents.firstWhere(
        (e) => e.status == EventStatus.upcoming,
        orElse: () => mockAgendaEvents.first,
      );

  @override
  Widget build(BuildContext context) {
    final next = _nextEvent;
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.2,
          colors: [Color(0xFFEDE8FF), WatchColors.background],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: WatchMetrics.side(context)),
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hora + etiqueta
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mi Feria',
                      style: TextStyle(
                        color: WatchColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      _currentTime,
                      style: const TextStyle(
                        color: WatchColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // Tarjeta del próximo evento
                NextEventCard(event: next, countdown: _countdown),

                const SizedBox(height: 6),

                // Botón QR
                GestureDetector(
                  onTap: widget.onQrTap,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [WatchColors.primary, Color(0xFF5A3CD0)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: WatchColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code, color: Colors.white, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'MI BOLETO QR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // Botón Agenda
                GestureDetector(
                  onTap: widget.onAgendaTap,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: WatchColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: WatchColors.secondary.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today,
                            color: WatchColors.secondary, size: 11),
                        SizedBox(width: 4),
                        Text(
                          'MI AGENDA',
                          style: TextStyle(
                            color: WatchColors.secondary,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Botones de simulación
                SimulationButtons(
                  onReminderTap: widget.onReminderTap,
                  onAlertTap: widget.onAlertTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
