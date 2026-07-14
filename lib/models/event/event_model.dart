enum EventStatus { upcoming, ongoing, finished }

class AgendaEvent {
  final String id;
  final String name;
  final String shortName;
  final String location;
  final String time;
  final String endTime;
  final String duration;
  final EventStatus status;
  final String icon;

  const AgendaEvent({
    required this.id,
    required this.name,
    required this.shortName,
    required this.location,
    required this.time,
    required this.endTime,
    required this.duration,
    required this.status,
    required this.icon,
  });
}

final List<AgendaEvent> mockAgendaEvents = [];
