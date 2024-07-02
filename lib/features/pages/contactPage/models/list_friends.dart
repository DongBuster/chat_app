class ListFriendsModel {
  late int id;
  late String userId;
  late List<String> friendsId;
  ListFriendsModel({
    required this.id,
    required this.userId,
    required this.friendsId,
  });
  ListFriendsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? -1;
    userId = json["userId"] ?? '';
    friendsId = json["friendsId"] ?? [];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['friendsId'] = friendsId;
    return data;
  }
}
