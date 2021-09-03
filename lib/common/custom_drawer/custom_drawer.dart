import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer_header.dart';
import 'package:loja_virtual/common/custom_drawer/drawer_tile.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserManager userManager = Get.find();
    return Drawer(
      child: ListView(
        children: [
          CustomDrawerHeader(),
          Divider(),
          DrawerTile(iconData: Icons.home, title: 'Início', page: 0),
          DrawerTile(iconData: Icons.card_giftcard, title: 'Cartão Fidelidade', page: 1),
          DrawerTile(iconData: Icons.list, title: 'Endereços', page: 2),
          DrawerTile(iconData: Icons.playlist_add_check, title: 'Meus Pedidos', page: 3),
          
          if(userManager.userNormal.admin)
          ...[
            DrawerTile(iconData: Icons.sort, title: 'Pedido dos Usuários', page: 4),
            DrawerTile(iconData: Icons.people, title: 'Todos os Usuários', page: 5),
          ]
        ],
      ),
    );
  }
}