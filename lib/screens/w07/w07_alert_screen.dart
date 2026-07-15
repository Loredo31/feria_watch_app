// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/models.dart';
// import '../../widgets/widgets.dart';
// import '../../theme/watch_theme.dart';
// import '../../providers/watch_state.dart';
// import '../../shared/widgets/widgets.dart';

// class W07AlertScreen extends StatefulWidget {
//   final VoidCallback onDismiss;
//   final Function(String location)? onViewMap;
//   final AlertModel? alert;

//   const W07AlertScreen({
//     super.key,
//     required this.onDismiss,
//     this.onViewMap,
//     this.alert,
//   });

//   @override
//   State<W07AlertScreen> createState() => _W07AlertScreenState();
// }

// class _W07AlertScreenState extends State<W07AlertScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _pulseController;
//   late AnimationController _shakeController;
//   late AnimationController _iconController;
//   late Animation<double> _pulseAnim;
//   late Animation<double> _shakeAnim;
//   late Animation<double> _iconAnim;

//   AlertModel? _currentAlert;
//   bool _showHistory = false;

//   @override
//   void initState() {
//     super.initState();

//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..repeat(reverse: true);
//     _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     _shakeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//     )..repeat(reverse: true);
//     _shakeAnim = Tween<double>(begin: -3.0, end: 3.0).animate(
//       CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
//     );

//     _iconController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     )..repeat(reverse: true);
//     _iconAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
//       CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
//     );

//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) _shakeController.stop();
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_currentAlert == null) {
//       final state = Provider.of<WatchState>(context);
//       _currentAlert = widget.alert ??
//           state.activeAlert ??
//           (state.alerts.isNotEmpty ? state.alerts.first : null);
//     }
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _shakeController.dispose();
//     _iconController.dispose();
//     super.dispose();
//   }

//   Color get _alertColor {
//     final alert = _currentAlert;
//     if (alert == null) return WatchColors.primary;
//     return alert.urgency == AlertUrgency.emergency
//         ? WatchColors.alert
//         : WatchColors.warning;
//   }

//   Color get _bgColor {
//     final alert = _currentAlert;
//     if (alert == null) return WatchColors.background;
//     return alert.urgency == AlertUrgency.emergency
//         ? const Color(0xFFFFF0F0)
//         : const Color(0xFFFFFAE0);
//   }

//   String get _alertLocation {
//     final alert = _currentAlert;
//     if (alert == null) return 'Foro Principal (Escenario A)';
//     final msg = '${alert.message} ${alert.fullMessage}'.toLowerCase();
//     if (msg.contains('zona norte')) return 'Zona Norte';
//     if (msg.contains('zona sur')) return 'Zona Sur';
//     if (msg.contains('zona a')) return 'Zona A';
//     if (msg.contains('escenario principal')) return 'Escenario Principal';
//     return 'Foro Principal (Escenario A)';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _pulseAnim,
//       builder: (_, child) {
//         return PageScaffold(
//           backgroundColor: Colors.transparent,
//           title: _showHistory ? 'Historial' : (_currentAlert != null ? '¡Alerta urgente!' : 'Avisos'),
//           titleIcon: _showHistory ? null : (_currentAlert != null ? Icons.warning_amber_rounded : Icons.notifications_none),
//           iconColor: _showHistory ? null : _alertColor,
//           trailing: _showHistory 
//               ? GestureDetector(
//                   onTap: () => setState(() => _showHistory = false),
//                   child: const Icon(
//                     Icons.close,
//                     color: WatchColors.textMuted,
//                     size: 14,
//                   ),
//                 )
//               : null,
//           decoration: BoxDecoration(
//             gradient: RadialGradient(
//               center: Alignment.center,
//               radius: _pulseAnim.value,
//               colors: [
//                 _alertColor.withValues(alpha: 0.25),
//                 _bgColor,
//               ],
//             ),
//           ),
//           body: child!,
//         );
//       },
//       child: _showHistory ? _buildHistory() : _buildAlert(),
//     );
//   }

//   Widget _buildAlert() {
//     final alert = _currentAlert;
//     if (alert == null) {
//       return SafeScroll(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.notifications_off_outlined,
//                 color: WatchColors.textMuted, size: 24),
//             const SizedBox(height: 6),
//             const Text(
//               'Sin alertas activas',
//               style: TextStyle(
//                 color: WatchColors.textPrimary,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 3),
//             const Text(
//               'Recibirás notificaciones en tiempo real aquí',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: WatchColors.textMuted,
//                 fontSize: 8,
//               ),
//             ),
//             const SizedBox(height: 10),
//             WatchButton(
//               label: 'CERRAR',
//               onTap: widget.onDismiss,
//               color: WatchColors.surfaceLight,
//               textColor: WatchColors.textSecondary,
//               small: true,
//             ),
//           ],
//         ),
//       );
//     }

//     return AnimatedBuilder(
//       animation: _shakeAnim,
//       builder: (_, child) => Transform.translate(
//         offset: Offset(_shakeAnim.value, 0),
//         child: child,
//       ),
//       child: SafeScroll(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AlertIcon(
//               scaleAnim: _iconAnim,
//               urgency: alert.urgency,
//             ),
//             const SizedBox(height: 5),
//             Text(
//               alert.message,
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: WatchColors.textPrimary,
//                 fontSize: 9,
//                 height: 1.4,
//               ),
//             ),
//             const SizedBox(height: 3),
//             Text(
//               alert.timestamp,
//               style: const TextStyle(
//                 color: WatchColors.textMuted,
//                 fontSize: 8,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 WatchButton(
//                   label: 'VER MÁS',
//                   onTap: () {
//                     context.read<WatchState>().sendRemoteCommand({
//                       'type': 'open_notification',
//                       'alertId': alert.id,
//                       'message': alert.fullMessage,
//                     });
//                     setState(() => _showHistory = true);
//                   },
//                   color: _alertColor,
//                   icon: Icons.info_outline,
//                   small: true,
//                 ),
//                 const SizedBox(width: 8),
//                 WatchButton(
//                   label: 'OK',
//                   onTap: widget.onDismiss,
//                   color: WatchColors.surfaceLight,
//                   textColor: WatchColors.textSecondary,
//                   small: true,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHistory() {
//     final watchState = context.watch<WatchState>();
//     final alertsList = watchState.alerts;

//     if (alertsList.isEmpty) {
//       return Column(
//         children: [
//           const Divider(color: WatchColors.border, height: 1),
//           const Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.notifications_off_outlined,
//                       color: WatchColors.textMuted, size: 24),
//                   SizedBox(height: 6),
//                   Text(
//                     'Historial vacío',
//                     style: TextStyle(
//                       color: WatchColors.textPrimary,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(height: 3),
//                   Text(
//                     'No se han recibido avisos aún',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: WatchColors.textMuted,
//                       fontSize: 8,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8),
//             child: WatchButton(
//               label: 'VOLVER',
//               onTap: () => setState(() => _showHistory = false),
//               color: WatchColors.surfaceLight,
//               textColor: WatchColors.textSecondary,
//               small: true,
//             ),
//           ),
//         ],
//       );
//     }

//     return Column(
//       children: [
//         const Divider(color: WatchColors.border, height: 1),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.only(
//               top: 4,
//               bottom: 4,
//             ),
//             itemCount: alertsList.length,
//             itemBuilder: (context, index) {
//               final alert = alertsList[index];
//               return AlertHistoryItem(
//                 alert: alert,
//                 onTap: () => setState(() {
//                   _currentAlert = alert;
//                   _showHistory = false;
//                 }),
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               WatchButton(
//                 label: 'VER MAPA',
//                 onTap: () {
//                   if (widget.onViewMap != null) {
//                     widget.onViewMap!(_alertLocation);
//                   }
//                 },
//                 color: WatchColors.primary,
//                 icon: Icons.map_outlined,
//                 small: true,
//               ),
//               const SizedBox(height: 4),
//               WatchButton(
//                 label: 'OK',
//                 onTap: widget.onDismiss,
//                 color: _alertColor,
//                 icon: Icons.check_circle_outline,
//                 small: true,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../../theme/watch_theme.dart';
import '../../providers/watch_state.dart';
import '../../shared/widgets/widgets.dart';

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
          (state.alerts.isNotEmpty ? state.alerts.first : null);
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
    final alert = _currentAlert;
    if (alert == null) return WatchColors.primary;
    return alert.urgency == AlertUrgency.emergency
        ? WatchColors.alert
        : WatchColors.warning;
  }

  Color get _bgColor {
    final alert = _currentAlert;
    if (alert == null) return WatchColors.background;
    return alert.urgency == AlertUrgency.emergency
        ? const Color(0xFFFFF0F0)
        : const Color(0xFFFFFAE0);
  }

  String get _alertLocation {
    final alert = _currentAlert;
    if (alert == null) return 'Ubicación actual';
    final msg = '${alert.message} ${alert.fullMessage}'.toLowerCase();
    if (msg.contains('zona norte')) return 'Zona Norte';
    if (msg.contains('zona sur')) return 'Zona Sur';
    if (msg.contains('zona a')) return 'Zona A';
    if (msg.contains('escenario principal')) return 'Escenario Principal';
    return 'Ubicación actual';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) {
        return PageScaffold(
          backgroundColor: Colors.transparent,
          title: _showHistory ? 'Historial' : (_currentAlert != null ? '¡Alerta urgente!' : 'Avisos'),
          titleIcon: _showHistory ? null : (_currentAlert != null ? Icons.warning_amber_rounded : Icons.notifications_none),
          iconColor: _showHistory ? null : _alertColor,
          trailing: _showHistory 
              ? GestureDetector(
                  onTap: () => setState(() => _showHistory = false),
                  child: const Icon(
                    Icons.close,
                    color: WatchColors.textMuted,
                    size: 14,
                  ),
                )
              : null,
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
          body: child!,
        );
      },
      child: _showHistory ? _buildHistory() : _buildAlert(),
    );
  }

  Widget _buildAlert() {
    final alert = _currentAlert;
    if (alert == null) {
      return SafeScroll(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_off_outlined,
                color: WatchColors.textMuted, size: 24),
            const SizedBox(height: 6),
            const Text(
              'Sin alertas activas',
              style: TextStyle(
                color: WatchColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Recibirás notificaciones en tiempo real aquí',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: WatchColors.textMuted,
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 10),
            WatchButton(
              label: 'CERRAR',
              onTap: widget.onDismiss,
              color: WatchColors.surfaceLight,
              textColor: WatchColors.textSecondary,
              small: true,
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(_shakeAnim.value, 0),
        child: child,
      ),
      child: SafeScroll(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertIcon(
              scaleAnim: _iconAnim,
              urgency: alert.urgency,
            ),
            const SizedBox(height: 5),
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
    );
  }

  Widget _buildHistory() {
    final watchState = context.watch<WatchState>();
    final alertsList = watchState.alerts;

    if (alertsList.isEmpty) {
      return Column(
        children: [
          const Divider(color: WatchColors.border, height: 1),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      color: WatchColors.textMuted, size: 24),
                  SizedBox(height: 6),
                  Text(
                    'Historial vacío',
                    style: TextStyle(
                      color: WatchColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'No se han recibido avisos aún',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: WatchColors.textMuted,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: WatchButton(
              label: 'VOLVER',
              onTap: () => setState(() => _showHistory = false),
              color: WatchColors.surfaceLight,
              textColor: WatchColors.textSecondary,
              small: true,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
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
          padding: const EdgeInsets.only(bottom: 8),
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