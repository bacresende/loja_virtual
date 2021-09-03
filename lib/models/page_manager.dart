import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class PageManager extends GetxController{
  final PageController _pageController;

  PageManager(this._pageController);

  int page = 0;
  void setPage({int value}){
    if(value == page) return;
    page = value; 
    _pageController.jumpToPage(value);
  }

  PageController get pageController => _pageController;
}
