import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../features/pages/chatPage/models/message_model.dart';

const urlForAvdLDplayer = 'http://192.168.1.5:3500';
const urlForWebApp = 'http://localhost:3500';
const urlForAndroid = 'http://10.0.2.2:3500';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  SocketService._internal();
  factory SocketService() {
    return _instance;
  }
  IO.Socket? socket;

  // StreamSocket streamSocket = StreamSocket();

  void connectAndListen() {
    socket ??= IO.io(urlForAvdLDplayer,
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket?.connect();
    socket?.onConnect((data) {
      print('Connect to sever socket');
      socket?.emit('user_login', FirebaseAuth.instance.currentUser?.uid ?? '');
    });
    // print(FirebaseAuth.instance.currentUser?.uid);
  }

  void joinRoom(String room) {
    socket?.emit('join_room', room);
    // print('Joined room: $room');
  }

  void leaveRoom(String room) {
    socket?.emit('leave_room', room);
    // print('Leave room: $room');
  }

  void sendMessage(MessageModel messageModel) {
    socket?.emit('send_message', {
      'id': messageModel.id,
      'roomId': messageModel.roomId,
      'senderId': messageModel.senderId,
      'receivedId': messageModel.receivedId,
      'text': messageModel.text,
      'time': messageModel.time,
    });
    // print('Sent message \'$message\' fromUserId \'$userId\' to room \'$room\'');
  }

  void dispose() {
    if (socket != null) {
      socket!.disconnect();
      socket = null;
      print('Disconnected server socket');
    }
  }
}
