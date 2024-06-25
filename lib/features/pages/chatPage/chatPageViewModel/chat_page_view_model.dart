import 'package:chat_app/features/pages/chatPage/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPageViewModel {
  Future<void> pushData(String userId, MessageModel messageModel) async {
    await Supabase.instance.client.from('messages').insert({
      'user_id': userId,
      'message': {
        'id': messageModel.id,
        'roomId': messageModel.roomId,
        'senderId': messageModel.senderId,
        'receivedId': messageModel.receivedId,
        'text': messageModel.text,
        'time': messageModel.time,
      }
    }).eq('user_id', userId);
  }

  Future<List<MessageModel>> getMessages(String userId) async {
    List<MessageModel> list = [];
    await Supabase.instance.client
        .from('messages')
        .select('message')
        .then((listData) {
      // print(listData);
      for (var element in listData) {
        MessageModel message = MessageModel.fromJson(element['message']);
        list.add(message);
      }
    });
    return list;
  }
}
