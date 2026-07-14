import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../../theme/watch_theme.dart';
import '../../providers/watch_state.dart';

class W07AlertScreen extends StatefulWidget {
  final VoidCallback onDismiss;
  final Function(String location)? onViewMap;
  final AlertModel? alert;

  const W07AlertScreen({
    super.key,
    required this.onDismiss,
    this.onViewMap,
    this.alert,
  });

  @override
  State<W07AlertScreen> createState() => _W07AlertScreenState();
}

class _W07AlertScreenState extends State<W07AlertScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _iconController;
  late Animation<double> _pulseAnim;
  late Animation<double> _shakeAnim;
  late Animation<double> _iconAnim;

  AlertModel? _currentAlert;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    )..repeat(reverse: true);
    _shakeAnim = Tween<double>(begin: -3.0, end: 3.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _iconAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _shakeController.stop();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentAlert == null) {
      final state = Provider.of<WatchState>(context);
      _currentAlert = widget.alert ??
          state.activeAlert ??
          (state.alerts.isNotEmpty ? state.alerts.first : mockAlerts.first);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Color get _alertColor {
    final alert = _currentAlert ?? mockAlerts.first;
    return alert.urgency == AlertUrgency.emergency
        ? WatchColors.alert
        : WatchColors.warning;
  }

  Color get _bgColor {
    final alert = _currentAlert ?? mockAlerts.first;
    return alert.urgency == AlertUrgency.emergency
        ? const Color(0xFFFFF0F0)
        : const Color(0xFFFFFAE0);
  }

  String get _alertLocation {
    final alert = _currentAlert ?? mockAlerts.first;
    final msg = '${alert.message} ${alert.fullMessage}'.toLowerCase();
    if (msg.contains('zona norte')) return 'Zona Norte';
    if (msg.contains('zona sur')) return 'Zona Sur';
    if (msg.contains('zona a')) return 'Zona A';
    if (msg.contains('escenario principal')) return 'Escenario Principal';
    return 'Foro Principal (Escenario A)';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: _pulseAnim.value,
              colors: [
                _alertColor.withValues(alpha: 0.25),
                _bgColor,
              ],
            ),
          ),
          child: child,
        );
      },
      child: _showHistory ? _buildHistory() : _buildAlert(),
    );
  }

  Widget _buildAlert() {
    final alert = _currentAlert ?? mockAlerts.first;
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(_shakeAnim.value, 0),
        child: child,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: WatchMetrics.side(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono de alerta
              AlertIcon(
                scaleAnim: _iconAnim,
                urgency: alert.urgency,
              ),

              const SizedBox(height: 5),

              Text(
                '¡Alerta urgente!',
                style: TextStyle(
                  color: _alertColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                alert.message,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: WatchColors.textPrimary,
                  fontSize: 9,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                alert.timestamp,
                style: const TextStyle(
                  color: WatchColors.textMuted,
                  fontSize: 8,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WatchButton(
                    label: 'VER MÁS',
                    onTap: () {
                      // Enviar comando remoto al teléfono
                      context.read<WatchState>().sendRemoteCommand({
                        'type': 'open_notification',
                        'alertId': alert.id,
                        'message': alert.fullMessage,
                      });
                      setState(() => _showHistory = true);
                    },
                    color: _alertColor,
                    icon: Icons.info_outline,
                    small: true,
                  ),
                  const SizedBox(width: 8),
                  WatchButton(
                    label: 'OK',
                    onTap: widget.onDismiss,
                    color: WatchColors.surfaceLight,
                    textColor: WatchColors.textSecondary,
                    small: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    final watchState = context.watch<WatchState>();
    final alertsList = watchState.alerts.isNotEmpty ? watchState.alerts : mockAlerts;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: WatchMetrics.edge(context) + 10,
            left: 16,
            right: 16,
            bottom: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Historial',
                style: TextStyle(
                  color: WatchColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showHistory = false),
                child: const Icon(
                  Icons.close,
                  color: WatchColors.textMuted,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: WatchColors.border, height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: 4,
              bottom: 4,
            ),
            itemCount: alertsList.length,
            itemBuilder: (context, index) {
              final alert = alertsList[index];
              return AlertHistoryItem(
                alert: alert,
                onTap: () => setState(() {
                  _currentAlert = alert;
                  _showHistory = false;
                }),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: WatchMetrics.edge(context) + 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WatchButton(
                label: 'VER MAPA',
                onTap: () {
                  if (widget.onViewMap != null) {
                    widget.onViewMap!(_alertLocation);
                  }
                },
                color: WatchColors.primary,
                icon: Icons.map_outlined,
                small: true,
              ),
              const SizedBox(height: 4),
              WatchButton(
                label: 'OK',
                onTap: widget.onDismiss,
                color: _alertColor,
                icon: Icons.check_circle_outline,
                small: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

