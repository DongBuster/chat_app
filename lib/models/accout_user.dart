class AccoutUser {
  late String image;
  late String name;
  late String id;
  late String email;
  late String isNewUser;
  late String isOnline;

  AccoutUser({
    required this.image,
    required this.name,
    required this.id,
    required this.email,
    required this.isNewUser,
    required this.isOnline,
  });
  AccoutUser.itinial() {
    id = '';
    name = '';
    image = '';
    email = '';
    isNewUser = 'false';
    isOnline = 'false';
  }
  AccoutUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    isNewUser = json['isNewUser'] ?? '';
    isOnline = json['isOnline'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    data['isNewUser'] = isNewUser;
    data['isOnline'] = isOnline;

    return data;
  }
}
