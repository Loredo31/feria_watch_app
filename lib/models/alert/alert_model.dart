enum AlertUrgency { emergency, operational }

class AlertModel {
  final String id;
  final String message;
  final String fullMessage;
  final AlertUrgency urgency;
  final String timestamp;

  const AlertModel({
    required this.id,
    required this.message,
    required this.fullMessage,
    required this.urgency,
    required this.timestamp,
  });
}

final List<AlertModel> mockAlerts = [];
