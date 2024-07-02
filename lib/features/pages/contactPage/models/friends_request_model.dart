// ignore_for_file: public_member_api_docs, sort_constructors_first
class FriendRequestModel {
  late String id;
  late String senderId;
  late String receiverId;
  late String sentAt;
  late String status;
  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    required this.status,
  });
  FriendRequestModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? '';
    senderId = json["senderId"] ?? '';
    receiverId = json["receiverId"] ?? '';
    sentAt = json["sentAt"] ?? '';
    status = json["status"] ?? 'pending';
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['sentAt'] = sentAt;
    data['status'] = status;
    return data;
  }
}
