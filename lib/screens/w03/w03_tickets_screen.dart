// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../theme/watch_theme.dart';
// import '../../widgets/widgets.dart';
// import '../../providers/watch_state.dart';
// import '../../shared/widgets/widgets.dart';

// class W03TicketsScreen extends StatefulWidget {
//   final VoidCallback onBack;

//   const W03TicketsScreen({super.key, required this.onBack});

//   @override
//   State<W03TicketsScreen> createState() => _W03TicketsScreenState();
// }

// class _W03TicketsScreenState extends State<W03TicketsScreen>
//     with SingleTickerProviderStateMixin {
//   late final PageController _pageController;
//   int _currentPage = 0;
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnim;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: 0);
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     )..forward();
//     _fadeAnim =
//         CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }

//   Color _typeColor(String type) {
//     switch (type) {
//       case 'VIP':
//         return const Color(0xFFFFD700);
//       case 'General':
//         return WatchColors.secondary;
//       case 'Familiar':
//         return WatchColors.primaryLight;
//       default:
//         return WatchColors.textSecondary;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final watchState = context.watch<WatchState>();
//     final ticketsList = watchState.tickets;

//     if (ticketsList.isEmpty) {
//       return PageScaffold(
//         body: SafeScroll(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.qr_code, color: WatchColors.textMuted, size: 24),
//               const SizedBox(height: 6),
//               const Text(
//                 'Sin boletos',
//                 style: TextStyle(
//                   color: WatchColors.textPrimary,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 3),
//               const Text(
//                 'Compra o reserva en tu teléfono para sincronizar',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: WatchColors.textMuted,
//                   fontSize: 8,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: widget.onBack,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: WatchColors.surfaceLight,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: WatchColors.border),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.arrow_back_ios_new_rounded,
//                           color: WatchColors.textSecondary, size: 8),
//                       SizedBox(width: 3),
//                       Text(
//                         'VOLVER',
//                         style: TextStyle(
//                           color: WatchColors.textSecondary,
//                           fontSize: 8,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return PageScaffold(
//       title: 'Mis Boletos QR',
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(ticketsList.length, (i) {
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 margin: const EdgeInsets.symmetric(horizontal: 2),
//                 width: _currentPage == i ? 14 : 6,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: _currentPage == i
//                       ? WatchColors.primary
//                       : WatchColors.border,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               );
//             }),
//           ),

//           const SizedBox(height: 4),

//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               onPageChanged: (i) {
//                 if (ticketsList.isNotEmpty) {
//                   setState(() => _currentPage = i % ticketsList.length);
//                 }
//                 _fadeController.reset();
//                 _fadeController.forward();
//               },
//               itemBuilder: (context, index) {
//                 if (ticketsList.isEmpty) {
//                   return const SizedBox.shrink();
//                 }
//                 final ticket = ticketsList[index % ticketsList.length];
//                 return FadeTransition(
//                   opacity: _fadeAnim,
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return SingleChildScrollView(
//                         physics: const ClampingScrollPhysics(),
//                         child: ConstrainedBox(
//                           constraints:
//                               BoxConstraints(minHeight: constraints.maxHeight),
//                           child: Center(
//                             child: TicketPage(
//                               ticket: ticket,
//                               typeColor: _typeColor(ticket.ticketType),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),

//           if (ticketsList.length > 1)
//             const Padding(
//               padding: EdgeInsets.only(bottom: 4),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.chevron_left, color: WatchColors.textMuted, size: 12),
//                   Text(
//                     'desliza para ver más',
//                     style: TextStyle(color: WatchColors.textMuted, fontSize: 8),
//                   ),
//                   Icon(Icons.chevron_right,
//                       color: WatchColors.textMuted, size: 12),
//                 ],
//               ),
//             ),

//           Padding(
//             padding: const EdgeInsets.only(bottom: 6),
//             child: GestureDetector(
//               onTap: widget.onBack,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: WatchColors.surfaceLight,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: WatchColors.border),
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.arrow_back_ios_new_rounded,
//                         color: WatchColors.textSecondary, size: 9),
//                     SizedBox(width: 4),
//                     Text(
//                       'VOLVER',
//                       style: TextStyle(
//                         color: WatchColors.textSecondary,
//                         fontSize: 8,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/watch_theme.dart';
import '../../widgets/widgets.dart';
import '../../providers/watch_state.dart';
import '../../shared/widgets/widgets.dart';

class W03TicketsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const W03TicketsScreen({super.key, required this.onBack});

  @override
  State<W03TicketsScreen> createState() => _W03TicketsScreenState();
}

class _W03TicketsScreenState extends State<W03TicketsScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    final ticketsList = Provider.of<WatchState>(context, listen: false).tickets;
    final initialPage =
        ticketsList.isNotEmpty ? 1000 - (1000 % ticketsList.length) : 0;
    _pageController = PageController(initialPage: initialPage);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'VIP':
        return const Color(0xFFFFD700);
      case 'General':
        return WatchColors.secondary;
      case 'Familiar':
        return WatchColors.primaryLight;
      default:
        return WatchColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchState = context.watch<WatchState>();
    final ticketsList = watchState.tickets;

    if (ticketsList.isEmpty) {
      return PageScaffold(
        body: SafeScroll(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.qr_code, color: WatchColors.textMuted, size: 24),
              const SizedBox(height: 6),
              const Text(
                'Sin boletos',
                style: TextStyle(
                  color: WatchColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Compra o reserva en tu teléfono para sincronizar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: WatchColors.textMuted,
                  fontSize: 8,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: WatchColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: WatchColors.border),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded,
                          color: WatchColors.textSecondary, size: 8),
                      SizedBox(width: 3),
                      Text(
                        'VOLVER',
                        style: TextStyle(
                          color: WatchColors.textSecondary,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PageScaffold(
      title: 'Mis Boletos QR',
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(ticketsList.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: _currentPage == i ? 14 : 6,
                height: 4,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? WatchColors.primary
                      : WatchColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),

          const SizedBox(height: 4),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (i) {
                if (ticketsList.isNotEmpty) {
                  setState(() => _currentPage = i % ticketsList.length);
                }
                _fadeController.reset();
                _fadeController.forward();
              },
              itemBuilder: (context, index) {
                if (ticketsList.isEmpty) {
                  return const SizedBox.shrink();
                }
                final ticket = ticketsList[index % ticketsList.length];
                return FadeTransition(
                  opacity: _fadeAnim,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Center(
                            child: TicketPage(
                              ticket: ticket,
                              typeColor: _typeColor(ticket.ticketType),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          if (ticketsList.length > 1)
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left, color: WatchColors.textMuted, size: 12),
                  Text(
                    'desliza para ver más',
                    style: TextStyle(color: WatchColors.textMuted, fontSize: 8),
                  ),
                  Icon(Icons.chevron_right,
                      color: WatchColors.textMuted, size: 12),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: GestureDetector(
              onTap: widget.onBack,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: WatchColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: WatchColors.border),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new_rounded,
                        color: WatchColors.textSecondary, size: 9),
                    SizedBox(width: 4),
                    Text(
                      'VOLVER',
                      style: TextStyle(
                        color: WatchColors.textSecondary,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}