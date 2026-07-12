class TicketModel {
  final String id;
  final String holderName;
  final String ticketType;
  final String qrData;
  final String eventDate;
  final bool isUsed;

  const TicketModel({
    required this.id,
    required this.holderName,
    required this.ticketType,
    required this.qrData,
    required this.eventDate,
    this.isUsed = false,
  });
}

final List<TicketModel> mockTickets = [
  const TicketModel(
    id: 'TK-2027-001',
    holderName: 'Jory Bravo',
    ticketType: 'VIP',
    qrData: 'FERIA2027-VIP-TK001-JORYBRAVO-VALID',
    eventDate: '10/05/2027',
    isUsed: false,
  ),
  const TicketModel(
    id: 'TK-2027-002',
    holderName: 'Jory Bravo',
    ticketType: 'General',
    qrData: 'FERIA2027-GEN-TK002-JORYBRAVO-VALID',
    eventDate: '11/05/2027',
    isUsed: false,
  ),
  const TicketModel(
    id: 'TK-2027-003',
    holderName: 'Ana García',
    ticketType: 'Familiar',
    qrData: 'FERIA2027-FAM-TK003-ANAGARCIA-USED',
    eventDate: '10/05/2027',
    isUsed: true,
  ),
];
