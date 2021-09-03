import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/pedidos_usuario/pedidos_usuario_screen.dart';
import 'package:loja_virtual/widgets/elegant_dialog.dart';

class UsersController extends GetxController {
  RxList<User> users = <User>[].obs;
  UsersController() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db.collection('users').getDocuments();

    users.value = querySnapshot.documents
        .map((DocumentSnapshot documentSnapshot) =>
            User.fromMap(documentSnapshot.data))
        .toList();
  }

  void showElegantDialog(User user) {
    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
              titulo: '${user.name}',
              descricao: 'Qual ação deseja realizar?',
              primeiroBotao: FlatButton(
                  child: Text(
                    'Ver Pedidos',
                    style: flatButtonRosaStyle,
                  ),
                  onPressed: () {
                    Get.to(PedidosUsuarioScreen(user));
                  }),
              segundoBotao: FlatButton(
                  child: Text(!user.admin ? 'Tornar Admin' : 'Tirar Admin',
                      style: flatButtonAzulStyle),
                  onPressed: () async {
                    Firestore db = Firestore.instance;
                    await db
                        .collection('users')
                        .document(user.id)
                        .updateData({'admin': !user.admin});

                    if (!user.admin) {
                      await db
                          .collection('admins')
                          .document(user.id)
                          .setData({'admin': user.id});
                    } else {
                      await db.collection('admins').document(user.id).delete();
                    }
                    Get.back();
                  }),
              icone: Icons.person);
        });
  }
}
