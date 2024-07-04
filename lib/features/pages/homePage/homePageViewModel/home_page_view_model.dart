import 'package:chat_app/features/pages/homePage/models/room_chat_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageViewModel {
  Stream<List<RoomChatModel>> getRooms(String currentUserId) async* {
    List<RoomChatModel> list = [];
    final supabaseClient = Supabase.instance.client;
    final streamData = supabaseClient
        .from('rooms_chat')
        .stream(primaryKey: ['id'])
        .eq('userId', currentUserId)
        .map((listData) {
          // print()
          list.clear(); // Clear the list before adding new data
          for (var e in listData) {
            // print(e['id'].runtimeType);
            try {
              var roomChatModel = RoomChatModel.fromJson(e);
              list.add(roomChatModel);
            } catch (error) {
              print('Error parsing JSON: $error');
            }
          }

          return list;
          // return listData.map((e) => RoomChatModel.fromJson(e)).toList();
        });
    yield* streamData;
  }
}
