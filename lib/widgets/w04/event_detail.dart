// import 'package:flutter/material.dart';
// import '../../theme/watch_theme.dart';
// import '../../models/models.dart';

// class EventDetail extends StatelessWidget {
//   final AgendaEvent event;
//   final VoidCallback onClose;
//   final VoidCallback onViewMap;

//   const EventDetail({
//     super.key,
//     required this.event,
//     required this.onClose,
//     required this.onViewMap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final margin = MediaQuery.sizeOf(context).width * 0.09;
//     return Container(
//       margin: EdgeInsets.all(margin),
//       padding: const EdgeInsets.all(14),
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.sizeOf(context).height - margin * 2,
//       ),
//       decoration: BoxDecoration(
//         color: WatchColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: WatchColors.primary.withValues(alpha: 0.25)),
//         boxShadow: [
//           BoxShadow(
//             color: WatchColors.primary.withValues(alpha: 0.12),
//             blurRadius: 20,
//           ),
//         ],
//       ),
//       child: SingleChildScrollView(
//         physics: const ClampingScrollPhysics(),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(event.icon, style: const TextStyle(fontSize: 20)),
//             const SizedBox(height: 4),
//             Text(
//               event.name,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: WatchColors.textPrimary,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 6),
//             DetailRow(icon: Icons.location_on, text: event.location),
//             DetailRow(
//                 icon: Icons.access_time,
//                 text: '${event.time} – ${event.endTime}'),
//             DetailRow(icon: Icons.timelapse, text: event.duration),
//             const SizedBox(height: 6),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   onTap: onClose,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: WatchColors.surfaceLight,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: WatchColors.border),
//                     ),
//                     child: const Text(
//                       'Cerrar',
//                       style: TextStyle(
//                         color: WatchColors.textSecondary,
//                         fontSize: 9,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: onViewMap,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [WatchColors.primary, Color(0xFF5A3CD0)],
//                       ),
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.map_rounded, color: Colors.white, size: 9),
//                         SizedBox(width: 4),
//                         Text(
//                           'Ver Mapa',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DetailRow extends StatelessWidget {
//   final IconData icon;
//   final String text;

//   const DetailRow({super.key, required this.icon, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         children: [
//           Icon(icon, color: WatchColors.primary, size: 10),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: const TextStyle(
//               color: WatchColors.textSecondary,
//               fontSize: 10,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';
import '../../models/models.dart';
import '../../shared/widgets/widgets.dart';

class EventDetail extends StatelessWidget {
  final AgendaEvent event;
  final VoidCallback onClose;
  final VoidCallback onViewMap;

  const EventDetail({
    super.key,
    required this.event,
    required this.onClose,
    required this.onViewMap,
  });

  @override
  Widget build(BuildContext context) {
    // Esta tarjeta flota sobre la pantalla (no vive dentro de un
    // PageScaffold), así que no puede heredar su padding automático.
    // Reutiliza la misma constante de inset que usa SafeScroll para
    // mantener un solo lugar de referencia para esa proporción.
    final margin = MediaQuery.sizeOf(context).width * SafeScroll.defaultInset;
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(margin),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height - margin * 2,
        ),
        decoration: BoxDecoration(
          color: WatchColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WatchColors.primary.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: WatchColors.primary.withValues(alpha: 0.12),
              blurRadius: 20,
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(event.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                event.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: WatchColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              DetailRow(icon: Icons.location_on, text: event.location),
              DetailRow(
                  icon: Icons.access_time,
                  text: '${event.time} – ${event.endTime}'),
              DetailRow(icon: Icons.timelapse, text: event.duration),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: WatchColors.surfaceLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: WatchColors.border),
                      ),
                      child: const Text(
                        'Cerrar',
                        style: TextStyle(
                          color: WatchColors.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onViewMap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [WatchColors.primary, Color(0xFF5A3CD0)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.map_rounded, color: Colors.white, size: 9),
                          SizedBox(width: 4),
                          Text(
                            'Ver Mapa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: WatchColors.primary, size: 10),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: WatchColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}