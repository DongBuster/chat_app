class Messages {
  // late final
  late final String senderID;
  late final String receiverID;
  late final String message;
  Messages({
    required this.senderID,
    required this.receiverID,
    required this.message,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'].toString();

    receiverID = json['receiverID'].toString();
    message = json['message'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['senderID'] = senderID;

    data['receiverID'] = receiverID;
    data['message'] = message;

    return data;
  }
}
