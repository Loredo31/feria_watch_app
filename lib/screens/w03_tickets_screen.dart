import 'package:flutter/material.dart';
import '../theme/watch_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

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
    final initialPage = mockTickets.isNotEmpty ? mockTickets.length * 1000 : 0;
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
    return Container(
      color: WatchColors.background,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: WatchMetrics.edge(context) + 10,
              bottom: 6,
            ),
            child: const Text(
              'Mis Boletos QR',
              style: TextStyle(
                color: WatchColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Indicadores de página
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(mockTickets.length, (i) {
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

          // PageView de boletos
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) {
                if (mockTickets.isNotEmpty) {
                  setState(() => _currentPage = i % mockTickets.length);
                }
                _fadeController.reset();
                _fadeController.forward();
              },
              itemBuilder: (context, index) {
                if (mockTickets.isEmpty) {
                  return const SizedBox.shrink();
                }
                final ticket = mockTickets[index % mockTickets.length];
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

          // Hint de deslizar
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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

          // Botón de regreso — hasta el final de la pantalla
          Padding(
            padding: EdgeInsets.only(bottom: WatchMetrics.edge(context) + 6),
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