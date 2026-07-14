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

final List<TicketModel> mockTickets = [];
