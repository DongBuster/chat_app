import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationService {
  //--- get FCM server key ---
  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {};

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }

  //--- get FCM Token device recevied ---
  Future<String> getFCMToken(String userId) async {
    String FCMToken = '';
    await FirebaseFirestore.instance
        .collection('FcmUser')
        .doc(userId)
        .get()
        .then(
      (value) {
        // print(value.data()!['notificationToken']);
        return FCMToken = value.data()?['notificationToken'] ?? '';
      },
    );
    return FCMToken;
  }

  //--- ---
  Future<void> sendDataToFCM(
      String messageText, String nameRoom, List<dynamic> receivedIds) async {
    final String serverKey = await getAccessToken(); // Your FCM server key
    const String fcmEndpoint =
        'https://fcm.googleapis.com/v1/projects/chat-app-socket-fcm/messages:send';
    final currentFCMToken = await FirebaseMessaging.instance.getToken();
    // print("fcmkey : $currentFCMToken");
    // print(messageText);
    for (var i = 0; i < receivedIds.length; i++) {
      String FCMToken = await getFCMToken(receivedIds[i]);
      // print(FCMToken);
      final Map<String, dynamic> message = {
        'message': {
          'token':
              FCMToken, // Token of the device you want to send the message to
          'notification': {'body': messageText, 'title': nameRoom},
          'data': {
            'current_user_fcm_token':
                currentFCMToken, // Include the current user's FCM token in data payload
          },
        }
      };

      final http.Response response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('FCM message sent successfully');
      } else {
        print('Failed to send FCM message: ${response.statusCode}');
      }
    }
  }
}
