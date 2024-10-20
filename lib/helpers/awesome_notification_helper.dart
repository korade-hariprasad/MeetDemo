import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:meet_demo/helpers/shared_pref_helper.dart';

import 'jitsi_helper.dart';


class AwesomeNotificationHelper{

  initNotifications() {
    AwesomeNotifications().initialize(null, [
      NotificationChannel(channelKey: "call_channel", channelName: "Call channel", channelDescription: "For incoming calls",
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
      )
    ]);
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceived,
    );
  }

  createNotification(String title, String body, String meetId){
    AwesomeNotifications().createNotification(content: NotificationContent(id: 123, channelKey: "call_channel",
      title: title,
      body: body,
      category: NotificationCategory.Call,
      wakeUpScreen: true,
      fullScreenIntent: true,
      autoDismissible: false,
      payload: {"meetId": meetId},
    ),
        actionButtons: [
          NotificationActionButton(key: "ACCEPT", label: "Accept", color: Colors.green, autoDismissible: false),
          NotificationActionButton(key: "REJECT", label: "Reject", color: Colors.red, autoDismissible: true, actionType: ActionType.DismissAction),
        ]
    );
  }
}

Future<void> onActionReceived(ReceivedAction receivedAction) async {
  if (receivedAction.buttonKeyPressed == "REJECT") {
    print("Call Rejected");
    return;
  } else if (receivedAction.buttonKeyPressed == "ACCEPT") {
    // Retrieve necessary information from Shared Preferences
    SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
    String? email = await sharedPrefHelper.getEmail();
    String? name = await sharedPrefHelper.getName();
    // Get the meeting ID from the data payload
    final String meetId = receivedAction.payload?['meetId'] ?? '';
    if (meetId.isEmpty) {
      debugPrint("Meeting ID is null");
      return;
    }
    // Join the meeting
    debugPrint("Joining meeting with ID: $meetId");
    JitsiHelper().joinMeeting(meetId: meetId, email: email!, name: name!);
    AwesomeNotifications().dismissNotificationsByChannelKey("call_channel");
  }
}