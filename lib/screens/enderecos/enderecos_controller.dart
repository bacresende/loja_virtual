import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/address_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/widgets/elegant_dialog.dart';

class EnderecosController extends GetxController {
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  AddressManager addressManager = Get.find();


  void showDeleteDialog(Address address){
    showDialog(
      context: Get.context,
      builder: (context){
        return ElegantDialog(
            titulo: "Excluir Endereço",
            descricao: "Deseja excluir o endereco de ${address.endereco} ?",
            icone: Icons.delete,
            primeiroBotao: FlatButton(
              child: Text(
                'Não',
                style: dialogFlatButtonVerdeStyle,
              ),
              onPressed: () async {
                Get.back();
              },
            ),
            segundoBotao: FlatButton(
              child: Text(
                'Sim',
                style: dialogFlatButtonRosaStyle,
              ),
              onPressed: () async {
                await deleteItemAddress(address.id);
                Get.back();
              },
            ),
          );
      }
      );
  }

  Future<void> deleteItemAddress(String id) async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    _db
        .collection('users')
        .document(firebaseUser.uid)
        .collection('address')
        .document(id)
        .delete();
  }
}
