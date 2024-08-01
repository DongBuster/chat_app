import 'package:chat_app/features/pages/contactPage/models/friends_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../models/accout_user.dart';
import '../models/friend_model.dart';

class ContactPageViewModels {
  //--- ------
  Stream<List<FriendRequestModel>> getFriendsRequest(String userId) async* {
    final supabase = Supabase.instance.client;
    final stream = supabase
        .from('friends_request')
        .stream(primaryKey: ['id'])
        .eq('receiverId', userId)
        .map((listData) {
          // print(listData);
          final filteredList =
              listData.where((e) => e['status'] == 'pending').toList();
          return filteredList
              .map((e) => FriendRequestModel.fromJson(e))
              .toList();
        });
    yield* stream;
  }

  Stream<List<FriendModel>> getFriends(String userId) async* {
    final supabase = Supabase.instance.client;
    final stream = supabase
        .from('friends')
        .stream(primaryKey: ['id'])
        .eq('userId', userId)
        .map((listData) {
          // print(listData);

          return listData.map((e) => FriendModel.fromJson(e)).toList();
        });
    yield* stream;
  }

  Future<bool> isHaveFriendRequest(String docId) async {
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

  Future<void> sentFriendRequest(FriendRequestModel model) async {
    await isHaveFriendRequest(model.id).then((isDocId) async {
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

  Future<void> acceptFriendRequest(FriendRequestModel model) async {
    await Supabase.instance.client
        .from('friends_request')
        .update({'status': 'accept'}).eq('id', model.id);
    await Supabase.instance.client
        .from('friends_request')
        .select('id,senderId,receiverId')
        .eq('id', model.id)
        .then((listData) async {
      // print(listData);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(listData[0]['receiverId'])
          .get()
          .then((result) async {
        Map<String, dynamic> dataUser = result.data() as Map<String, dynamic>;
        // print('lan1');
        await Supabase.instance.client.from('friends').insert({
          'userId': listData[0]['senderId'],
          'idFriend': listData[0]['receiverId'],
          'nameFriend': dataUser['name'],
          'imageFriend': dataUser['image'],
        });

        //---- ----
        await Supabase.instance.client.from('rooms_chat').insert({
          "userId": listData[0]['senderId'],
          "roomId": listData[0]['id'],
          "image": dataUser['image'],
          "nameRoom": dataUser['name']
        });
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(listData[0]['senderId'])
          .get()
          .then((result) async {
        Map<String, dynamic> dataUser = result.data() as Map<String, dynamic>;

        await Supabase.instance.client.from('friends').insert({
          'userId': listData[0]['receiverId'],
          'idFriend': listData[0]['senderId'],
          'nameFriend': dataUser['name'],
          'imageFriend': dataUser['image'],
        });
        //--- ----
        await Supabase.instance.client.from('rooms_chat').insert({
          "userId": listData[0]['receiverId'],
          "roomId": listData[0]['id'],
          "image": dataUser['image'],
          "nameRoom": dataUser['name']
        });
      });
    });
    // await Supabase.instance.client.from('friends_request').delete().eq('id', model.id);
  }

  //--- ------

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

  Future<List<AccoutUser>> streamListUser(String userId) async {
    List<AccoutUser> listUser = [];
    List<String> listFriend = [];
    await Supabase.instance.client
        .from('friends')
        .select('idFriend')
        .eq('userId', userId)
        .then((listData) {
      // print(listData);
      for (var element in listData) {
        listFriend.add(element['idFriend']);
      }
    });
    // print(listFriend);
    await FirebaseFirestore.instance.collection('users').get().then((result) {
      for (var element in result.docs) {
        // print(e.data()['id']);
        if (!listFriend.contains(element.data()['id']) &&
            element.data()['id'] != userId) {
          listUser.add(AccoutUser.fromJson(element.data()));
        }
      }
    });

    return listUser;
  }

  Stream<AccoutUser> streamUser(String userId) async* {
    final streamData = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      // print(snapshot.docs.length);

      // print(snapshot.data());
      return AccoutUser.fromJson(snapshot.data() as Map<String, dynamic>);
    });
    yield* streamData;
  }

  Stream<List<AccoutUser>> searchNameUser(String nameSearch) async* {
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

  Future<AccoutUser> searchUserId(String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((result) {
      // print(snapshot.docs.length);
      Map<String, dynamic> data = result.data() as Map<String, dynamic>;
      return AccoutUser.fromJson(data);
    });

    // yield* streamData;
  }
}
