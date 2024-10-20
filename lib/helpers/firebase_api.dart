import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meet_demo/helpers/shared_pref_helper.dart';

import 'jitsi_helper.dart';

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
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleMessage);
    FirebaseMessaging.onMessage.listen((message){});

    /*
    FirebaseMessaging.onMessage.listen((message){
      final notification = message.notification;
      if(notification == null) return;
      _localNotificationPlugin.show(notification.hashCode, notification.title, notification.body,
        NotificationDetails(android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher',
        ),),
        payload: jsonEncode(message.toMap()),
      );
    });
    */
  }

  final _androidChannel = const AndroidNotificationChannel(
    'notification_channel_id',
    'High Importance Notifications',
    description: 'Used for notification',
    importance: Importance.high,
  );

  final _localNotificationPlugin = FlutterLocalNotificationsPlugin();
}

//Future<void> handleBackgroundMessage(RemoteMessage message) async {}
Future<void> handleMessage(RemoteMessage? message) async {
  if (message == null) return;
  SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
  String? email = await sharedPrefHelper.getEmail();
  String? name = await sharedPrefHelper.getName();
  final String meetId = message.data['meetId'] ?? '';
  if (meetId == ''){
    debugPrint("meetid is null");
    print("meetid is null");
    return;
  }
  //join the meet
  debugPrint("message is $message");
  print("meet is null $meetId");
  JitsiHelper().joinMeeting(meetId: meetId, email: email!, name: name!);
}