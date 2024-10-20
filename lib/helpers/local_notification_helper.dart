import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHelper {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    // Updated initialization with the new callback for notification response.
    await _localNotifications.initialize(initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> showNotification(String meetingId, String email) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'meeting_channel',
      'Meeting Notifications',
      channelDescription: 'Notifications for meeting invitations',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      'Meeting Invitation',
      'A meeting has started. Would you like to join?',
      notificationDetails,
      payload: meetingId, // Pass the meetingId as payload
    );
  }

  /*
  Future<void> showMeetingStateNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'meeting_channel',
      'Meeting Notifications',
      channelDescription: 'Notifications for meeting invitations',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      'Meeting Invitation',
      'A meeting has started. Would you like to join?',
      notificationDetails,
      payload: meetingId, // Pass the meetingId as payload
    );
  }
  */

  // Use the new method to handle notification interactions.
  void onDidReceiveNotificationResponse(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload != null && response.notificationResponseType == NotificationResponseType.selectedNotification) {
      print('User accepted the meeting with ID: $payload');
      // Your logic to join the meeting using Jitsi SDK or another method.
    } else {
      print('User dismissed the notification.');
      // Handle dismiss action if needed.
    }
  }

}