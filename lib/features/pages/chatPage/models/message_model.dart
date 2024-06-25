// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  late final String id;
  late final String roomId;
  late final String text;
  late final String senderId;
  late final List<dynamic> receivedId;
  late final String time;
  MessageModel({
    required this.id,
    required this.roomId,
    required this.text,
    required this.senderId,
    required this.receivedId,
    required this.time,
  });
  MessageModel.initial() {
    id = '';
    roomId = '';
    text = '';
    senderId = '';
    receivedId = [];
    time = '';
  }
  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? '';
    roomId = json["roomId"] ?? '';
    text = json["text"] ?? '';
    senderId = json["senderId"] ?? '';
    receivedId = json["receivedId"] ?? [];
    time = json["time"] ?? '';
  }
}
