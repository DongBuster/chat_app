// ignore_for_file: public_member_api_docs, sort_constructors_first
class RoomChatModel {
  late final int id;
  late final String userId;
  late final String roomId;
  late final String image;
  late final String nameRoom;
  RoomChatModel({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.image,
    required this.nameRoom,
  });
  RoomChatModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? -1;
    userId = json["userId"] ?? '';
    roomId = json["roomId"] ?? '';
    image = json["image"] ?? '';
    nameRoom = json["nameRoom"] ?? '';
  }
}
