// import 'package:flutter/material.dart';
// import '../../theme/watch_theme.dart';

// class PageScaffold extends StatelessWidget {
//   final String? title;
//   final IconData? titleIcon;
//   final Color? iconColor;
//   final Widget body;
//   final Decoration? decoration;
//   final Color? backgroundColor;
//   final Widget? trailing;

//   const PageScaffold({
//     super.key, 
//     this.title, 
//     this.titleIcon, 
//     this.iconColor, 
//     required this.body,
//     this.decoration,
//     this.backgroundColor,
//     this.trailing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final edgePadding = MediaQuery.sizeOf(context).height * 0.065; // WatchMetrics.edge
    
//     return Scaffold(
//       backgroundColor: backgroundColor ?? WatchColors.background,
//       body: Container(
//         decoration: decoration,
//         padding: EdgeInsets.only(bottom: edgePadding),
//         child: Column(
//           children: [
//             if (title != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 24, bottom: 2),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         if (titleIcon != null) ...[
//                           Icon(
//                             titleIcon, 
//                             size: 14, 
//                             color: iconColor ?? WatchColors.primary,
//                           ),
//                           const SizedBox(width: 5),
//                         ],
//                         Text(
//                           title!,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w700,
//                             color: WatchColors.textPrimary,
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (trailing != null)
//                       Positioned(
//                         right: 16,
//                         child: trailing!,
//                       ),
//                   ],
//                 ), 
//               ),
//             Expanded(
//               child: body,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';

class PageScaffold extends StatelessWidget {
  final String? title;
  final IconData? titleIcon;
  final Color? iconColor;
  final Widget body;
  final Decoration? decoration;
  final Color? backgroundColor;
  final Widget? trailing;

  const PageScaffold({
    super.key, 
    this.title, 
    this.titleIcon, 
    this.iconColor, 
    required this.body,
    this.decoration,
    this.backgroundColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    // Estas dos son las ÚNICAS medidas base del sistema: se calculan a
    // partir del tamaño real de pantalla (MediaQuery), no de un valor fijo.
    // Por eso el mismo diseño se ve bien en cualquier tamaño de reloj
    // (Small Round, Large Round, etc.) sin tocar nada por pantalla.
    final size = MediaQuery.sizeOf(context);
    final edgePadding = size.height * 0.065;
    final titleTopPadding = size.height * 0.10;

    return Scaffold(
      backgroundColor: backgroundColor ?? WatchColors.background,
      body: Container(
        decoration: decoration,
        padding: EdgeInsets.only(bottom: edgePadding),
        child: Column(
          children: [
            if (title != null)
              Padding(
                padding: EdgeInsets.only(top: titleTopPadding, bottom: 2),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (titleIcon != null) ...[
                          Icon(
                            titleIcon, 
                            size: 14, 
                            color: iconColor ?? WatchColors.primary,
                          ),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: WatchColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    if (trailing != null)
                      Positioned(
                        right: 16,
                        child: trailing!,
                      ),
                  ],
                ), 
              ),
            Expanded(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}