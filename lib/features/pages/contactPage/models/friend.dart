class FriendsModel {
  late int id;
  late String userId;
  late String idFriend;
  late String imageFriend;
  late String nameFriend;

  FriendsModel({
    required this.id,
    required this.userId,
    required this.idFriend,
    required this.imageFriend,
    required this.nameFriend,
  });
  FriendsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? -1;
    userId = json["userId"] ?? '';
    idFriend = json["idFriend"] ?? '';
    imageFriend = json["imageFriend"] ?? '';
    nameFriend = json["nameFriend"] ?? '';
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['idFriend'] = idFriend;
    data['imageFriend'] = imageFriend;
    data['nameFriend'] = nameFriend;
    return data;
  }
}
