import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loja_virtual/models/address_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';

void main() async {
  await GetStorage.init();
  injectionDependencies();

  runApp(MyApp());
}

void injectionDependencies() async {
  //Get.put(HomeManager());
  Get.put(ProductManager(), permanent: true);
  final PageController _pageController = PageController();
  Get.put(PageManager(_pageController), permanent: true);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Boutique do Brigadeiro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: corRosa,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(elevation: 0)),
      home: LoginScreen(),
    );
  }
}
