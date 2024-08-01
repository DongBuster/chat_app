import 'package:chat_app/features/pages/chatPage/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ChatPageViewModel {
  static Future<void> pushData(MessageModel messageModel) async {
    await Supabase.instance.client.from('messages').insert({
      'user_id': messageModel.roomId,
      'message': {
        'id': messageModel.id,
        'roomId': messageModel.roomId,
        'senderId': messageModel.senderId,
        'receivedId': messageModel.receivedId,
        'text': messageModel.text,
        'time': messageModel.time,
      }
    });
  }

  //--- ---
  static Future<List<MessageModel>> getMessages(String roomId) async {
    List<MessageModel> list = [];
    await Supabase.instance.client
        .from('messages')
        .select('message')
        .eq('user_id', roomId)
        .then((listData) {
      // print(listData);
      for (var element in listData) {
        MessageModel message = MessageModel.fromJson(element['message']);
        list.add(message);
      }
    });
    return list;
  }

  static MessageModel generateMessageModel(
      String messageText, String roomId, String userId) {
    final DateFormat formatter = DateFormat('HH:mm:ss dd/MM/yyyy');
    final String timeNow = formatter.format(DateTime.now());

    String id = const Uuid().v1();

    List<String> userIdRoom = roomId.split('_');
    List<String> receivedId =
        userIdRoom.where((element) => element != userId).toList();

    return MessageModel(
      id: id,
      roomId: roomId,
      text: messageText,
      senderId: userId,
      receivedId: receivedId,
      time: timeNow,
    );
  }

  //--- ---
  static Future<String> getUrlImageUser(String userId) async {
    String urlImage = '';
    if (userId == '') {
      return '';
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((result) {
      Map<String, dynamic> data = result.data() as Map<String, dynamic>;
      if (data['image'] == 'null') {
        return '';
      } else {
        urlImage = data['image'];
      }
    }).catchError((err) {
      return '';
    });
    return urlImage;
  }
}
