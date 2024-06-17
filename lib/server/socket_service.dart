import 'package:socket_io_client/socket_io_client.dart' as IO;

const urlForWebApp = 'http://localhost:3500';
const urlForAndroid = 'http://10.0.2.2:3500';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  SocketService._internal();
  factory SocketService() {
    return _instance;
  }
  IO.Socket? socket;
  String message = "";
  // StreamSocket streamSocket = StreamSocket();

  void connectAndListen() {
    socket ??= IO.io(
        urlForAndroid, IO.OptionBuilder().setTransports(['websocket']).build());
    socket?.connect();
    socket?.onConnect((data) => {print('Connect to sever socket')});
  }

  void joinRoom(String room) {
    socket?.emit('join_room', room);
    print('Joined room: $room');
  }

  void leaveRoom(String room) {
    socket?.emit('leave_room', room);
    print('Leave room: $room');
  }

  void sendMessage(String userId, String room, String message) {
    socket?.emit('send_message',
        {'room': room, 'fromUserId': userId, 'message': message});
    print('Sent message \'$message\' fromUserId \'$userId\' to room \'$room\'');
  }

  // String reviceMessage() {
  //   String message = '';
  //   socket?.on('receive_message', (data) {
  //     message = data.toString();
  //     print('Message received: $data');
  //   });
  //   return message;
  // }

  void dispose() {
    if (socket != null) {
      socket!.disconnect();
      socket = null;
      print('Disconnected server socket');
    }
  }
}
