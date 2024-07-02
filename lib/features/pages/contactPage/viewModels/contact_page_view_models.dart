import 'package:chat_app/features/pages/contactPage/models/friends_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../models/accout_user.dart';
import '../models/list_friends.dart';

class ContactPageViewModels {
  Stream<List<FriendRequestModel>> getFriendsRequest(String userId) async* {
    final supabase = Supabase.instance.client;
    final stream = supabase
        .from('friends_request')
        .stream(primaryKey: ['id'])
        .eq('receiverId', userId)
        .map((listData) {
          // print(listData);
          return listData.map((e) => FriendRequestModel.fromJson(e)).toList();
        });
    yield* stream;
  }

  Stream<List<ListFriendsModel>> getFriends(String userId) async* {
    final supabase = Supabase.instance.client;
    final stream = supabase
        .from('friends')
        .stream(primaryKey: ['id'])
        .eq('userId', userId)
        .map((listData) {
          // print(listData);
          return listData.map((e) => ListFriendsModel.fromJson(e)).toList();
        });
    yield* stream;
  }

  Future<String> getUrlImageUser(String userId) async {
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

  Future<String> getNameUser(String userId) async {
    String name = '';
    if (userId == '') {
      return '';
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((result) {
      Map<String, dynamic> data = result.data() as Map<String, dynamic>;
      if (data['name'] == 'null') {
        return '';
      } else {
        name = data['name'];
      }
    }).catchError((err) {
      return '';
    });
    return name;
  }

  Stream<List<AccoutUser>> streamUser() async* {
    final streamData = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) {
      // print(snapshot.docs.length);
      return snapshot.docs.map((doc) {
        // print(doc.data().isEmpty);
        return AccoutUser.fromJson(doc.data());
      }).toList();
    });
    yield* streamData;
  }

  Stream<List<AccoutUser>> searchUser(String nameSearch) async* {
    final streamData = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) {
      // print(snapshot.docs.length);
      return snapshot.docs
          .map((doc) {
            // print(doc.data().isEmpty);
            var user = AccoutUser.fromJson(doc.data());
            if (user.name.contains(nameSearch)) {
              return user;
            }
            return null;
          })
          .where((user) => user != null)
          .cast<AccoutUser>()
          .toList();
    });

    yield* streamData;
  }

  Future<void> sentFriendRequest(FriendRequestModel model) async {
    await isHaveDocId(model.id).then((isDocId) async {
      isDocId == false
          ? await Supabase.instance.client.from('friends_request').insert({
              'id': model.id,
              'senderId': model.senderId,
              'receiverId': model.receiverId,
              'sentAt': model.sentAt,
              'status': model.status,
            })
          : await deleteFriendRequest(model.id);
    });
  }

  Future<bool> isHaveDocId(String docId) async {
    bool result = false;
    await Supabase.instance.client
        .from('friends_request')
        .select()
        .eq('id', docId)
        .then((values) {
      // print(values.isNotEmpty);
      if (values.isNotEmpty) {
        return result = true;
      } else {
        return result = false;
      }
    });
    return result;
  }

  Future<void> deleteFriendRequest(String docId) async {
    await Supabase.instance.client
        .from('friends_request')
        .delete()
        .eq('id', docId);
  }

  Future<void> updateFriendRequest(String status, String docId) async {
    await Supabase.instance.client
        .from('friends_request')
        .update({'status': status}).eq('id', docId);
  }
}
