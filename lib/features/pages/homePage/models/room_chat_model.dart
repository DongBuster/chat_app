class RoomChatModel {
  late final String id;
  late final String image;
  late final String nameRoom;
  RoomChatModel({
    required this.id,
    required this.image,
    required this.nameRoom,
  });
  RoomChatModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? '';
    image = json["image"] ?? '';
    nameRoom = json["nameRoom"] ?? '';
  }
}
