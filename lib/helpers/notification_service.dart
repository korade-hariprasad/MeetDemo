import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationService {

  static Future<String> getAccessToken() async {

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    //get access token using Auth
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes, client
    );

    client.close();
    return credentials.accessToken.data;
  }

  static sendNotification(BuildContext context, String meetId, String email) async {
    final String serverKey = await getAccessToken();

    final Map<String, dynamic> message = {
      'message': {
        'topic': 'allDevices',
        'notification': {
          'title': "Join meet?",
          'body': "Meeting is started by $email click to join",
        },
        'data': {
          'meetId': meetId,
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("Notification sent to all devices");
    } else {
      print("Failed to send notification\nStatus Code: ${response.statusCode}");
    }
  }
}