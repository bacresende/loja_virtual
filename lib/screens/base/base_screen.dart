import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:loja_virtual/models/address_manager.dart';
import 'package:loja_virtual/models/card_fidelity_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/cartao_fidelidade/cartao_fidelidade_screen.dart';
import 'package:loja_virtual/screens/enderecos/enderecos_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/screens/my_orders.dart/my_orders_screen.dart';
import 'package:loja_virtual/screens/orders_users/orders_users_screen.dart';
import 'package:loja_virtual/screens/users/users_screen.dart';

class BaseScreen extends StatefulWidget {
  final User user;

  BaseScreen(this.user);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseUser currentUser;
    configCFM();
    //Get.lazyPut(() => AddressManager());
    Get.lazyPut(() => AddressManager());
    Get.lazyPut(() => CartManager(currentUser, id: widget.user.id));
    Get.lazyPut(() => CardFidelityManager(widget.user));
  }

  void configCFM() {
    final fcm = FirebaseMessaging();

    if (GetPlatform.isIOS) {
      fcm.requestNotificationPermissions(
          IosNotificationSettings(provisional: true));
    }

    fcm.configure(
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
      onMessage: (Map<String, dynamic> message) async {
        String title = message['notification']['title'];
        String mensagem = message['notification']['body'];

        showNotification(title, mensagem);
      },
    );
  }

  void showNotification(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.purple[900],
      duration: Duration(seconds: 5),
      icon: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    PageManager pageManager = Get.find();
    return Scaffold(
      body: PageView(
        controller: pageManager.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(widget.user),
          CardFidelityScreen(widget.user),
          EnderecosScreen(widget.user),
          MyOrdersScreen(widget.user),
          OrdersUsersScreen(widget.user),
          UsersScreen(widget.user)
        ],
      ),
    );
  }
}
