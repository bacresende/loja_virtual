import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/endereco/endereco_screen.dart';
import 'package:loja_virtual/screens/enderecos/enderecos_controller.dart';

class EnderecosScreen extends StatelessWidget {
  final EnderecosController controller = new EnderecosController();
  final User user;

  EnderecosScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Endereços'),
      ),
      drawer: CustomDrawer(),
      body: Obx(() => controller.addressManager.enderecos.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemCount: controller.addressManager.enderecos.length,
              itemBuilder: (_, index) {
                Address address = controller.addressManager.enderecos[index];

                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${address.nomeEndereco}',
                        style: TextStyle(
                            fontSize: 20,
                            color: corRosa,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${address.endereco} - ${address.estado}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  subtitle: Text('Telefone: ${address.telefone}',
                      style: TextStyle(fontSize: 16)),
                  leading: Icon(
                    Icons.pin_drop_outlined,
                    color: corRosa,
                  ),
                  onTap: () {
                    controller.showDeleteDialog(address);
                  },
                );
              })
          : Center(
              child: Text(
              'Sem Endereços no Momento',
              style: flatButtonRosaStyle,
            ))),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: corRosa,
        label: Text('Adicionar Endereço'),
        icon: Icon(Icons.add),
        onPressed: () {
          Get.to(EnderecoScreen());
        },
      ),
    );
  }
}
