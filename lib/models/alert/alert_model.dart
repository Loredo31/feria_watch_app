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

final List<AlertModel> mockAlerts = [
  const AlertModel(
    id: 'ALT-001',
    message: 'Cambio de sede para el espectáculo folclórico: Ahora en zona A',
    fullMessage:
        'Por razones técnicas, el Espectáculo Folclórico se ha trasladado a la Zona A (Escenario Alternativo). Por favor dirígete a la zona A ahora.',
    urgency: AlertUrgency.operational,
    timestamp: '15:45',
  ),
  const AlertModel(
    id: 'ALT-002',
    message: '¡Emergencia! Evacuar zona norte inmediatamente',
    fullMessage:
        'Se ha detectado una situación de emergencia en la Zona Norte. Por favor evacúe de manera ordenada siguiendo las instrucciones del personal de seguridad.',
    urgency: AlertUrgency.emergency,
    timestamp: '16:10',
  ),
];
