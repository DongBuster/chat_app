import 'package:flutter/material.dart';

class HeaderViewModel extends ChangeNotifier {
  bool isScrolling = false;
  setIsScrollingTrue() {
    isScrolling = true;
    notifyListeners();
  }

  setIsScrollingFalse() {
    isScrolling = false;
    notifyListeners();
  }
}
