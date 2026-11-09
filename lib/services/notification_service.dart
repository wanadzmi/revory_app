import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Initializes and schedules local upcoming-service notifications.
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Initializes timezone data and platform notification permissions.
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// Schedules a reminder one week before the due date when still upcoming.
  static Future<void> schedule({
    required int id,
    required String vehicle,
    required String service,
    required DateTime dueDate,
  }) async {
    final when = tz.TZDateTime.from(
      DateTime(
        dueDate.year,
        dueDate.month,
        dueDate.day,
        9,
      ).subtract(const Duration(days: 7)),
      tz.local,
    );
    if (when.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id: id,
      title: '$service is coming up',
      body: '$vehicle is due for $service in one week.',
      scheduledDate: when,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'service_reminders',
          'Service reminders',
          channelDescription: 'Upcoming vehicle maintenance reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Cancels all notifications scheduled by the app.
  static Future<void> cancelAll() => _plugin.cancelAll();
}
