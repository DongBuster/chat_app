class AccoutUser {
  late String image;
  late String name;
  late String id;
  late String email;
  late String isNewUser;
  AccoutUser({
    required this.image,
    required this.name,
    required this.id,
    required this.email,
    required this.isNewUser,
  });
  AccoutUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    isNewUser = json['isNewUser'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    data['isNewUser'] = isNewUser;

    return data;
  }
}
