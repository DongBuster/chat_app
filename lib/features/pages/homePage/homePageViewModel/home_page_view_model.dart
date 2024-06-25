import 'package:chat_app/features/pages/homePage/models/room_chat_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageViewModel {
  Stream<List<RoomChatModel>> getRooms(String currentUserId) async* {
    final supabaseClient = Supabase.instance.client;
    final streamData = supabaseClient
        .from('rooms_chat')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUserId)
        .map((listData) {
          // print(listData[0]['rooms']);
          List list = listData[0]['rooms'];
          return list.map((e) => RoomChatModel.fromJson(e)).toList();
        });
    yield* streamData;
  }
}
