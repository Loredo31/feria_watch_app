import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class WatchState extends ChangeNotifier {
  WebSocketChannel? _channel;
  bool _isConnecting = false;
  Timer? _reconnectTimer;

  bool isLoggedIn = false;
  bool isVisitor = false;
  String? userName;
  String? userEmail;
  bool wearConnected = false;
  int reminderMinutes = 10;

  List<TicketModel> tickets = [];
  List<AgendaEvent> agendaEvents = [];
  List<AlertModel> alerts = [];

  AlertModel? activeAlert;
  AgendaEvent? activeReminder;

  String connectionStatus = 'Buscando teléfono...';
  StatusType connectionType = StatusType.searching;

  WatchState() {
    connect();
  }

  void connect() {
    if (_isConnecting) return;
    _isConnecting = true;
    
    final host = kIsWeb
        ? 'localhost'
        : (defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost');
    final url = 'ws://$host:8080';
    
    debugPrint('WatchState: Conectando al socket en $url');
    connectionStatus = 'Buscando teléfono...';
    connectionType = StatusType.searching;
    notifyListeners();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (data) {
          _isConnecting = false;
          _handleMessage(data as String);
        },
        onDone: () {
          _isConnecting = false;
          _handleDisconnect();
        },
        onError: (e) {
          _isConnecting = false;
          _handleDisconnect();
        },
      );
    } catch (e) {
      _isConnecting = false;
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    connectionStatus = 'Sin Bluetooth';
    connectionType = StatusType.disconnected;
    wearConnected = false;
    notifyListeners();

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      connect();
    });
  }

  void _handleMessage(String rawData) {
    try {
      final msg = jsonDecode(rawData) as Map<String, dynamic>;
      final type = msg['type'];
      debugPrint('WatchState: Mensaje recibido: $msg');

      if (type == 'auth_state') {
        isLoggedIn = msg['isLoggedIn'] ?? false;
        isVisitor = msg['isVisitor'] ?? false;
        userName = msg['name'];
        userEmail = msg['email'];
        wearConnected = msg['wearConnected'] ?? false;
        reminderMinutes = msg['reminderMinutes'] ?? 10;

        if (wearConnected && isLoggedIn) {
          connectionStatus = 'Conectado';
          connectionType = StatusType.connected;
        } else if (!wearConnected) {
          connectionStatus = 'Sin reloj detectado';
          connectionType = StatusType.disconnected;
        } else {
          connectionStatus = 'Buscando teléfono...';
          connectionType = StatusType.searching;
        }
      } else if (type == 'tickets') {
        final list = msg['tickets'] as List<dynamic>;
        tickets = list.map((t) {
          final visitDateStr = t['visitDate'] != null
              ? _formatDate(DateTime.parse(t['visitDate'] as String))
              : '10/05/2026';
          return TicketModel(
            id: t['id'] ?? '',
            holderName: userName ?? 'Usuario',
            ticketType: t['type'] ?? 'General',
            qrData: t['qrCodeData'] ?? '',
            eventDate: visitDateStr,
            isUsed: t['status'] == 'Usado',
          );
        }).toList();
      } else if (type == 'favorites') {
        final list = msg['favorites'] as List<dynamic>;
        agendaEvents = list.map((e) {
          EventStatus statusVal = EventStatus.upcoming;
          final statusStr = e['status'] as String?;
          if (statusStr == 'ongoing') {
            statusVal = EventStatus.ongoing;
          } else if (statusStr == 'finished') {
            statusVal = EventStatus.finished;
          }
          return AgendaEvent(
            id: e['id'] ?? '',
            name: e['name'] ?? '',
            shortName: e['shortName'] ?? '',
            location: e['location'] ?? '',
            time: e['time'] ?? '',
            endTime: e['endTime'] ?? '',
            duration: e['duration'] ?? '',
            status: statusVal,
            icon: e['icon'] ?? '📅',
          );
        }).toList();
      } else if (type == 'trigger_alert') {
        final alertData = msg['alert'] as Map<String, dynamic>;
        AlertUrgency urgencyVal = AlertUrgency.operational;
        if (alertData['urgency'] == 'emergency' || alertData['urgency'] == 'AlertUrgency.emergency') {
          urgencyVal = AlertUrgency.emergency;
        }
        final newAlert = AlertModel(
          id: alertData['id'] ?? 'ALT-${DateTime.now().millisecondsSinceEpoch}',
          message: alertData['message'] ?? '',
          fullMessage: alertData['fullMessage'] ?? '',
          urgency: urgencyVal,
          timestamp: alertData['timestamp'] ?? _formatTime(DateTime.now()),
        );
        
        if (!alerts.any((a) => a.id == newAlert.id)) {
          alerts.insert(0, newAlert);
        }
        activeAlert = newAlert;
      } else if (type == 'trigger_reminder') {
        final evtData = msg['event'] as Map<String, dynamic>;
        activeReminder = AgendaEvent(
          id: evtData['id'] ?? '',
          name: evtData['name'] ?? '',
          shortName: evtData['shortName'] ?? '',
          location: evtData['location'] ?? '',
          time: evtData['time'] ?? '',
          endTime: evtData['endTime'] ?? '',
          duration: evtData['duration'] ?? '',
          status: EventStatus.upcoming,
          icon: evtData['icon'] ?? '⏰',
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('WatchState: Error al interpretar mensaje: $e');
    }
  }

  void dismissAlert() {
    activeAlert = null;
    if (_channel != null) {
      try {
        _channel!.sink.add(jsonEncode({'type': 'dismiss_alert'}));
      } catch (_) {}
    }
    notifyListeners();
  }

  void dismissReminder() {
    activeReminder = null;
    if (_channel != null) {
      try {
        _channel!.sink.add(jsonEncode({'type': 'dismiss_reminder'}));
      } catch (_) {}
    }
    notifyListeners();
  }

  void sendRemoteCommand(Map<String, dynamic> command) {
    if (_channel != null) {
      try {
        _channel!.sink.add(jsonEncode(command));
      } catch (_) {}
    }
  }

  void requestManualSync() {
    sendRemoteCommand({'type': 'request_sync'});
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    super.dispose();
  }
}
