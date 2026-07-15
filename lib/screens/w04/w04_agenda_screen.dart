import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../theme/watch_theme.dart';
import '../../widgets/widgets.dart';
import '../../providers/watch_state.dart';
import '../../shared/widgets/widgets.dart';

class W04AgendaScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(AgendaEvent event)? onViewMap;
  final AgendaEvent? initialSelectedEvent;
  final Function(AgendaEvent? event)? onEventSelected;

  const W04AgendaScreen({
    super.key,
    required this.onBack,
    this.onViewMap,
    this.initialSelectedEvent,
    this.onEventSelected,
  });

  @override
  State<W04AgendaScreen> createState() => _W04AgendaScreenState();
}

class _W04AgendaScreenState extends State<W04AgendaScreen>
    with SingleTickerProviderStateMixin {
  AgendaEvent? _selectedEvent;
  late AnimationController _detailController;
  late Animation<double> _detailAnim;

  List<AgendaEvent> _getSortedEvents(List<AgendaEvent> events) {
    final order = {
      EventStatus.ongoing: 0,
      EventStatus.upcoming: 1,
      EventStatus.finished: 2,
    };
    final sorted = List<AgendaEvent>.from(events);
    sorted.sort((a, b) => order[a.status]!.compareTo(order[b.status]!));
    return sorted;
  }

  @override
  void initState() {
    super.initState();
    _detailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _detailAnim = CurvedAnimation(
      parent: _detailController,
      curve: Curves.easeOut,
    );

    if (widget.initialSelectedEvent != null) {
      _selectedEvent = widget.initialSelectedEvent;
      _detailController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  void _showDetail(AgendaEvent event) {
    setState(() => _selectedEvent = event);
    widget.onEventSelected?.call(event);
    _detailController.forward(from: 0);
  }

  void _hideDetail() {
    _detailController.reverse().then((_) {
      if (mounted) {
        setState(() => _selectedEvent = null);
        widget.onEventSelected?.call(null);
      }
    });
  }

  Color _statusColor(EventStatus s) {
    switch (s) {
      case EventStatus.ongoing:
        return WatchColors.success;
      case EventStatus.upcoming:
        return WatchColors.primary;
      case EventStatus.finished:
        return WatchColors.textMuted;
    }
  }

  String _statusLabel(EventStatus s) {
    switch (s) {
      case EventStatus.ongoing:
        return 'En curso';
      case EventStatus.upcoming:
        return 'Próximo';
      case EventStatus.finished:
        return 'Finalizado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchState = context.watch<WatchState>();
    final sortedEvents = _getSortedEvents(watchState.agendaEvents);

    if (sortedEvents.isEmpty) {
      return PageScaffold(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), WatchColors.background],
          ),
        ),
        body: SafeScroll(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_busy, color: WatchColors.textMuted, size: 24),
              const SizedBox(height: 6),
              const Text(
                'Agenda vacía',
                style: TextStyle(
                  color: WatchColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Marca favoritos en tu teléfono para sincronizar',
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

    return Stack(
      children: [
        PageScaffold(
          title: 'Mi Agenda',
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE8F5E9), WatchColors.background],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(height: 1, color: WatchColors.border),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 14,
                    ),
                    itemCount: sortedEvents.length + 1,
                    itemBuilder: (context, index) {
                      if (index == sortedEvents.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: GestureDetector(
                              onTap: widget.onBack,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: WatchColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: WatchColors.border),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.arrow_back_ios_new_rounded,
                                        color: WatchColors.textSecondary,
                                        size: 9),
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
                        );
                      }
                      final event = sortedEvents[index];
                      return EventTile(
                        event: event,
                        statusColor: _statusColor(event.status),
                        statusLabel: _statusLabel(event.status),
                        onTap: () => _showDetail(event),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_selectedEvent != null)
          FadeTransition(
            opacity: _detailAnim,
            child: GestureDetector(
              onTap: _hideDetail,
              child: Container(
                color: Colors.white.withValues(alpha: 0.92),
                child: Center(
                  child: ScaleTransition(
                    scale: _detailAnim,
                    child: EventDetail(
                      event: _selectedEvent!,
                      onClose: _hideDetail,
                      onViewMap: () {
                        if (widget.onViewMap != null && _selectedEvent != null) {
                          widget.onViewMap!(_selectedEvent!);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}