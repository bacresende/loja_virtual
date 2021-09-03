import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';

class CustomDrawerHeader extends StatelessWidget {
  final UserManager userManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180,
      child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Boutique do \nBrigadeiro ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
              ),
              Text(
                'Olá ${userManager.user.value?.name ?? ''}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                child: Text(
                  'Sair',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                onTap: () {
                  print('Sair');
                  userManager.signOut();
                  Get.delete();
                },
              )
            ],
          )),
    );
  }
}
