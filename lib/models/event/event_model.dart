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

final List<AgendaEvent> mockAgendaEvents = [
  const AgendaEvent(
    id: 'EV-001',
    name: 'Concierto de Mariachi',
    shortName: 'Concierto de Mariachi',
    location: 'Zona C',
    time: '16:00',
    endTime: '17:30',
    duration: '1h 30min',
    status: EventStatus.ongoing,
    icon: '🎵',
  ),
  const AgendaEvent(
    id: 'EV-002',
    name: 'Espectáculo Folclórico',
    shortName: 'Espectáculo Folclórico',
    location: 'Escenario Principal',
    time: '18:00',
    endTime: '19:00',
    duration: '1h',
    status: EventStatus.upcoming,
    icon: '🎭',
  ),
  const AgendaEvent(
    id: 'EV-003',
    name: 'Cine al Aire Libre',
    shortName: 'Cine al aire libre',
    location: 'Jardín Central',
    time: '20:00',
    endTime: '22:00',
    duration: '2h',
    status: EventStatus.upcoming,
    icon: '🎬',
  ),
  const AgendaEvent(
    id: 'EV-000',
    name: 'Inauguración Oficial',
    shortName: 'Inauguración',
    location: 'Entrada Principal',
    time: '10:00',
    endTime: '11:00',
    duration: '1h',
    status: EventStatus.finished,
    icon: '🎉',
  ),
];
