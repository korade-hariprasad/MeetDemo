import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meet_demo/helpers/awesome_notification_helper.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  late String myToken;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    // Request a token for the device to identify it.
    final fcmToken = await _firebaseMessaging.getToken();
    myToken = fcmToken!;
    print('FCM Token: $fcmToken');

    // Subscribe to the topic for all devices.
    _firebaseMessaging.subscribeToTopic('allDevices');

    initPushNotifications();
  }

  String getDeviceToken() {
    return myToken;
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if(message == null) return;
      handleNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
    FirebaseMessaging.onBackgroundMessage(handleNotification);
    FirebaseMessaging.onMessage.listen(handleNotification);
  }
}

Future<void> handleNotification(RemoteMessage message) async {
  String? title = message.notification?.title;
  String? body = message.notification?.body;
  AwesomeNotificationHelper().createNotification(title!, body!, message.data['meetId']);
}