import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';
import '../../theme/watch_theme.dart';
import '../../providers/watch_state.dart';



class W06MapScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onAgendaTap;
  final String? highlightLocation;
  final bool fromAgenda;

  const W06MapScreen({
    super.key,
    this.onBack,
    this.onAgendaTap,
    this.highlightLocation,
    this.fromAgenda = false,
  });

  @override
  State<W06MapScreen> createState() => _W06MapScreenState();
}

class _W06MapScreenState extends State<W06MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WatchColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: WatchMetrics.edge(context) + 10,
                bottom: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mapa del Recinto',
                    style: TextStyle(
                      color: WatchColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: WatchColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.my_location,
                            color: WatchColors.secondary, size: 8),
                        SizedBox(width: 2),
                        Text(
                          'GPS',
                          style: TextStyle(
                            color: WatchColors.secondary,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return InteractiveViewer(
                      transformationController: _transformController,
                      minScale: 0.8,
                      maxScale: 4.0,
                      child: Container(
                        color: const Color(0xFFE8EFF8),
                        child: CustomPaint(
                          size: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          painter: MapPainter(
                            pulseAnim: _pulseAnim,
                            highlightLocation: widget.highlightLocation,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 6,
                bottom: WatchMetrics.edge(context) + 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ZoomButton(
                        icon: Icons.add,
                        onTap: () {
                          final m = _transformController.value.clone();
                          m.scaleByDouble(1.3, 1.3, 1.3, 1.0);
                          _transformController.value = m;
                        },
                      ),
                      const SizedBox(width: 4),
                      ZoomButton(
                        icon: Icons.remove,
                        onTap: () {
                          final m = _transformController.value.clone();
                          m.scaleByDouble(0.77, 0.77, 0.77, 1.0);
                          _transformController.value = m;
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<WatchState>().sendRemoteCommand({
                        'type': 'open_map',
                        'location': widget.highlightLocation ?? 'Foro Principal (Escenario A)',
                      });

                      if (widget.fromAgenda) {
                        widget.onAgendaTap?.call();
                      } else {
                        widget.onBack?.call();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [WatchColors.primary, Color(0xFF5A3CD0)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: WatchColors.primary.withValues(alpha: 0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'TELÉFONO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
