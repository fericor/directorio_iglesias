import 'package:conexion_mas/controllers/eventosApiClient.dart';
import 'package:conexion_mas/screens/notificationDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static BuildContext? _context;

  // Establecer el contexto de navegación
  static void setContext(BuildContext context) {
    _context = context;
  }

  static Future<void> initialize() async {
    // Configuración para Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Manejar cuando se toca la notificación desde la bandeja
        _handleNotificationTap(details.payload);
      },
    );

    // Solicitar permisos
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Obtener token FCM
    String? token = await _firebaseMessaging.getToken();

    // Manejar mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // Manejar cuando la app está en segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Manejar cuando la app está cerrada
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        // Delay para asegurar que la app esté lista
        Future.delayed(Duration(milliseconds: 500), () {
          _handleMessage(message);
        });
      }
    });
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel',
      'Notificaciones',
      channelDescription: 'Canal para notificaciones generales',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(), // Enviar todos los datos como payload
    );
  }

  static void _handleMessage(RemoteMessage message) {
    print('Mensaje recibido: ${message.data}');
    _navigateBasedOnMessage(message.data);
  }

  static void _handleNotificationTap(String? payload) {
    if (payload == null) return;

    try {
      // Convertir el payload string a Map
      final payloadData = _parsePayload(payload);
      _navigateBasedOnMessage(payloadData);
    } catch (e) {
      print('Error parsing payload: $e');
    }
  }

  static Map<String, dynamic> _parsePayload(String payload) {
    // Convertir string like "{key: value}" to Map
    final cleaned = payload.replaceAll('{', '').replaceAll('}', '');
    final pairs = cleaned.split(', ');
    final Map<String, dynamic> result = {};

    for (var pair in pairs) {
      final parts = pair.split(': ');
      if (parts.length == 2) {
        result[parts[0].trim()] = parts[1].trim();
      }
    }

    return result;
  }

  static void _navigateBasedOnMessage(Map<String, dynamic> data) {
    if (_context == null) {
      print('Context not set for navigation');
      return;
    }

    final type = data['type'] ?? 'general';
    final id = data['id'];
    final title = data['title'];
    final body = data['body'];

    switch (type) {
      case 'news':
        _navigateToNewsDetail(
          id: id,
          title: title,
          content: body,
          data: data,
        );
        break;

      case 'promotion':
        _navigateToPromotionDetail(
          id: id,
          title: title,
          description: body,
          data: data,
        );
        break;

      case 'message':
        _navigateToChat(
          userId: data['user_id'],
          userName: data['user_name'],
          message: body,
        );
        break;

      default:
        _navigateToNotificationDetail(
          id: id,
          title: title,
          content: body,
          data: data,
        );
    }
  }

  // Métodos de navegación directa
  static void _navigateToNewsDetail({
    String? id,
    String? title,
    String? content,
    Map<String, dynamic>? data,
  }) {
    if (_context == null) return;

    /*Navigator.of(_context!).push(
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(
          newsId: id,
          newsTitle: title,
          newsContent: content,
          extraData: data,
        ),
      ),
    );*/
  }

  static void _navigateToNotificationDetail({
    String? id,
    String? title,
    String? content,
    Map<String, dynamic>? data,
  }) {
    if (_context == null) return;

    EventosApiClient()
        .getEventoByIdByUser(
            int.parse(data?['idEvento'] ?? ''), data?['idUser'] ?? '')
        .then((eventoItem) {
      Navigator.of(_context!).push(
        MaterialPageRoute(
          builder: (context) => DetalleEventoPush(
            evento: eventoItem,
            controller: PageController(),
          ),
        ),
      );
    });

    /*Navigator.of(_context!).push(
      MaterialPageRoute(
        builder: (context) => NotificationDetailScreen(
          notificationId: id,
          notificationTitle: title,
          notificationContent: content,
          data: data,
        ),
      ),
    );*/
  }

  static void _navigateToPromotionDetail({
    String? id,
    String? title,
    String? description,
    Map<String, dynamic>? data,
  }) {
    if (_context == null) return;

    /*Navigator.of(_context!).push(
      MaterialPageRoute(
        builder: (context) => PromotionDetailScreen(
          promotionId: id,
          promotionTitle: title,
          promotionDescription: description,
          extraData: data,
        ),
      ),
    );*/
  }

  static void _navigateToChat({
    String? userId,
    String? userName,
    String? message,
  }) {
    if (_context == null) return;

    /*Navigator.of(_context!).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userId: userId,
          userName: userName,
          initialMessage: message,
        ),
      ),
    );*/
  }

  // Método para obtener el token (útil para enviar al backend)
  static Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Suscribirse a temas
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Desuscribirse de temas
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

Future<void> setupPushNotifications() async {
  await NotificationService.initialize();
}
