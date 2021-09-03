import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/users/users_controller.dart';

class UsersScreen extends StatelessWidget {
  final UsersController controller = new UsersController();
  final User user;
  UsersScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Usuários'),
      ),
      body: Obx(() => ListView.separated(
          separatorBuilder: (_, __)=> Divider(), 
          itemCount: controller.users.length,
          itemBuilder: (_, index){
            User user = controller.users[index];
            return ListTile(
              title: Text(user.name, style: flatButtonRosaStyle,),
              subtitle: Text(user.email),
              onTap: (){
                controller.showElegantDialog(user);
                
              },
            );
          },)),
    );
  }
}
