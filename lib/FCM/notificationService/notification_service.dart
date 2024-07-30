import 'dart:convert';
import 'package:http/http.dart' as http;

const String base_url =
    'https://fcm.googleapis.com/v1/projects/chat-app-socket-fcm/messages:send';
const String key_server = '430c4cd8a11a43240ee0982a8ae0203f0e755ffa';
const String sender_id = '652684439981';

class NotificationService {
  Future<bool> pushNotifications({
    required String title,
    body,
    token,
  }) async {
    Map<String, dynamic> payload = {
      'to': token,
      'notification': {
        "priority": "high",
        'title': title,
        'body': body,
        "sound": "default",
      }
    };
    String dataNotification = jsonEncode(payload);
    var respone = await http.post(
      Uri.parse(base_url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= $key_server',
      },
      body: dataNotification,
    );
    print(respone.body.toString());
    return true;
  }
}
