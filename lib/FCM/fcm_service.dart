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
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "chat-app-socket-fcm",
      "private_key_id": "444906461d5049ab76587fcfb9d78c215644d8ac",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCTSZC8ePL41dAT\n4w8F5iNRdejn5bD2Q7rIO9Ay9Llm+EdzbC2/XdcXtCY0emymoOKbgXkN0smHUj6v\nM4sklmkXIluhLyscY3PKuXRKQTTqrpr0YSnmwKeqJi5tkIr1c8HouO5c62siFPBZ\nxLqrzADcTU047IdDryMBOvFaGMcg3DatZlXioHh2XtWWm3WIlk+YbWB1RIrc7m8S\nIy7xo/wGese4tve7swvbPlvvWcQXUMbCgrUwKBhv60P/j2P9/ju+FPqYroAuxhwP\nKnPqeZNZwORJ+GnAJDF0ZigAgGHe19DVp70dS/A5iceNtycKXNvdm2ExbGTfBGqv\nTzUQnLm7AgMBAAECggEARQMFvcHAOwbYEdFkoyNzrgIc6LdvhNw0Ywjfo1iWnKA9\nvl/USaPbGkCvXAx251ZgB3QReAAprG3FcEsq6bBOOmg/XdVfklQpF7ZwvjAybrn0\nYgg63WOsy+VLAMxmx95+35/zE/e8wYHlInKy8rdKOe9AfSkasgSYVsW6+7e7afH+\npBfmBKUDvQ8vCrEHUEmlQPplstR1OWCoQ7tkAaolI7RruKczz4ruHnoa9ZfSBzSo\nYY619aZqOpuBOVXQGclRN70TVaomqr+l0BlWQzmKxkJODsO5+61brR9EoUJlHT9f\nPY+V2ayhDJT1nImChesejJlYZt3MuUopP1FDHEuNAQKBgQDOFTnV+64A3QMChglB\nCOBGPq7PfBa4pWp3PBxxtNsvIfMbaE06Eyvv0HJgYW+UC4ZFYXGGsqc8k8LXyUrs\n+cs1sjjOZgqDEU8jDDtO4u4LqB//AFIbtJssyNJrE2LGz2ay7Fi2kukh9gTOK2A0\nI7cRkLl2hH2pkgux41fRxNJnAQKBgQC29oylabIme2sBOvq9PljqOoFj0uyz2glq\nxF4rK1FS/56iEEEWTPjKvTFJcVadNxtrwY48jBCCjGgmaPAQfqQ4OpF6qTwbL76b\nAjdIkpUYsSgk1XRC+HQrWC5eoRnmrWoiiwA9dOK+UFdbr8lskEYWzOs2TwanMzhr\nFgzzkAd8uwKBgBooyZmnA/RqGZq1ZvFRbh6ckFYYG04++R+/iqDIY1Y9Sf29pKft\njRM483vWgnJZcCbYcq+1d9MRspbvn0orfycGw303qLfwd4osYE7oMW1bXwxgfwuz\nRktOBp++6zfvVcr6g1xRk7RS5VNCYEjeC7v4EgLAWK8wsblX8WrYQBkBAoGAZhJy\nMK4g11svPUZ8MCuiSzpMiTZZG5Vef5QBvS+zdQxqoZtT1G8otWKLJp/2ZEskHx+i\njKDPbSWLzTHqDCm60CvMkZPslnYybiP0V6Z/S4E6FiKHc/1MQgo2BFD4NDs25QKL\nJb4Z6XbE5b/SLaDnmTzFVE0ONyVaKlPo8dC+fJUCgYBswg7VI6pQoiI+N4x8X5Bm\nz6sGlZsUOE1j2iwLBwqqs2bWHNJcSm6VL+6kC2WNrFJ46OKFcP0F2mewmKGr+Qaq\nF4HVAYvMWDlM5QU9IWIx5NVhvTCl0kDkd4pnfd5Ia+Q21CKFc5LiYCYcpJDiC+VU\nWISoepwJHFxwyJtjOrfFzw==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-mqund@chat-app-socket-fcm.iam.gserviceaccount.com",
      "client_id": "103776444726416538217",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-mqund%40chat-app-socket-fcm.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

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
