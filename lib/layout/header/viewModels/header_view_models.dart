import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HeaderViewModel extends ChangeNotifier {
  //--- state management ---
  bool isScrolling = false;
  setIsScrollingTrue() {
    isScrolling = true;
    notifyListeners();
  }

  setIsScrollingFalse() {
    isScrolling = false;
    notifyListeners();
  }

  //---- logic business -----
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

  static Future<String> getNameUser(String userId) async {
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
}
