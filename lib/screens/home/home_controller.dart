import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/widgets/elegant_dialog.dart';

class HomeController extends GetxController {
  Firestore _db = Firestore.instance;
  RxString _textoInformativo = ''.obs;

  String get textoInformativo => _textoInformativo.value;

  set textoInformativo(String value) => _textoInformativo.value = value;

  RxString _diaSelecionado = ''.obs;

  String get diaSelecionado => _diaSelecionado.value;

  set diaSelecionado(String value) => _diaSelecionado.value = value;

  RxBool _alterando = false.obs;

  bool get alterando => _alterando.value;

  set alterando(bool value) => _alterando.value = value;

  RxBool _edit = false.obs;

  bool get edit => _edit.value;

  set edit(bool value) => _edit.value = value;

  void setEdit() {
    edit = !edit;
  }

  HomeController(User user) {
    verifyCardFidelity(user);
  }

  Future<void> verifyCardFidelity(User user) async {
    //CardFidelityManager cardFidelityManager = new CardFidelityManager(user);

    DocumentSnapshot documentSnapshot =
        await _db.collection('users').document(user.id).get();

    if (documentSnapshot.data['data_valid_fidelity'] != null) {
      textoInformativo =
          'Você Completou seu Cartão Fidelidade, tendo de até um mês para usá-lo em qualquer compra no app!';
    }
  }

  Future<void> editItem(Product product) async {
    showModalBottomSheet(
        context: Get.context,
        builder: (_) {
          return Container(
            child: Column(
              children: [
                Card(
                  color: corRosa,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Que ação deseja fazer com o produto: "${product.name}"?',
                      style: flatButtonBrancoStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: corVerde,
                  ),
                  title: Text(
                    'Alterar dia do produto',
                    style: flatButtonVerdeStyle,
                  ),
                  onTap: () {
                    alterDayOfProduct(product);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.remove,
                    color: corVermelha,
                  ),
                  title: Text(
                    'Deletar Produto',
                    style: flatButtonVermelhoStyle2,
                  ),
                  onTap: () async {
                    await deleteItem(product);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Voltar',
                    style: flatButtonAzulStyle,
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> alterDayOfProduct(Product product) async {
    diaSelecionado = product.dayOfWeek;
    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    color: corRosa,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Selecione o dia',
                        style: flatButtonBrancoStyle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Obx(() => Column(
                        children: [
                          RadioListTile(
                              title: Text(
                                'Segunda-Feira',
                                style: flatButtonRosaStyle,
                              ),
                              activeColor: corRosa,
                              value: 'Segunda-Feira',
                              groupValue: diaSelecionado,
                              onChanged: (String valor) {
                                diaSelecionado = valor;
                              }),
                          RadioListTile(
                              title: Text(
                                'Terça-Feira',
                                style: flatButtonRosaStyle,
                              ),
                              activeColor: corRosa,
                              value: 'Terça-Feira',
                              groupValue: diaSelecionado,
                              onChanged: (String valor) {
                                diaSelecionado = valor;
                              }),
                          RadioListTile(
                              title: Text(
                                'Quarta-Feira',
                                style: flatButtonRosaStyle,
                              ),
                              activeColor: corRosa,
                              value: 'Quarta-Feira',
                              groupValue: diaSelecionado,
                              onChanged: (String valor) {
                                diaSelecionado = valor;
                              }),
                          RadioListTile(
                              title: Text(
                                'Quinta-Feira',
                                style: flatButtonRosaStyle,
                              ),
                              activeColor: corRosa,
                              value: 'Quinta-Feira',
                              groupValue: diaSelecionado,
                              onChanged: (String valor) {
                                diaSelecionado = valor;
                              }),
                          RadioListTile(
                              title: Text(
                                'Sexta-Feira',
                                style: flatButtonRosaStyle,
                              ),
                              activeColor: corRosa,
                              value: 'Sexta-Feira',
                              groupValue: diaSelecionado,
                              onChanged: (String valor) {
                                diaSelecionado = valor;
                              }),
                          RadioListTile(
                              title: Text(
                                'Sábado',
                                style: flatButtonRosaStyle,
                              ),
                              activeColor: corRosa,
                              value: 'Sábado',
                              groupValue: diaSelecionado,
                              onChanged: (String valor) {
                                diaSelecionado = valor;
                              }),
                          RadioListTile(
                              title: Text(
                                'Não Listado',
                                style: flatButtonPretoStyle,
                              ),
                              activeColor: corRosa,
                              value: 'Não Listado',
                              groupValue: diaSelecionado,
                              onChanged: (String valor) {
                                diaSelecionado = valor;
                              }),
                        ],
                      )),
                ),
                Obx(() => GestureDetector(
                      child: Container(
                        color: !alterando ? corRosa : Colors.black,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              !alterando ? 'Alterar' : 'Alterando',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      onTap: !alterando
                          ? () async {
                              alterando = true;
                              _db
                                  .collection('products')
                                  .document(product.id)
                                  .updateData(
                                      {'dayOfWeek': this.diaSelecionado});
                              alterando = false;
                              Get.back();
                              Get.back();
                            }
                          : () {},
                    )),
              ],
            ),
          );
        });
  }

  Future<void> deleteItem(Product product) async {
    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
            titulo: 'Deletar Produto',
            descricao: 'Tem certeza que deseja deletar ${product.name}?',
            primeiroBotao: FlatButton(
              child: Text(
                'Não',
                style: TextStyle(color: Colors.green, fontSize: 22),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            segundoBotao: FlatButton(
              child: Text('Sim',
                  style: TextStyle(
                      color: corRosa,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
              onPressed: () async {
                await deleteProductFromDB(product);
                Get.back();
                Get.back();
              },
            ),
            icone: Icons.remove,
          );
        });
  }

  Future<void> deleteProductFromDB(Product product) async {
    await _db.collection('products').document(product.id).delete();

    if (product.namePhotos.isNotEmpty) {
      print('tem fotos');
      await deleteImagesStorage(product);
    }
  }

  Future<void> deleteImagesStorage(Product product) async {
    for (String namePhoto in product.namePhotos) {
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      StorageReference pastaRaiz = firebaseStorage.ref();
      StorageReference arquivo =
          pastaRaiz.child("fotos_produtos").child("$namePhoto.jpg");

      arquivo.delete();
    }
  }

  /*Rx<User> user = User().obs;
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  

  Future<void> getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    DocumentSnapshot documentSnapshot =
        await _db.collection('users').document(firebaseUser.uid).get();

    user.value = User.fromMap(documentSnapshot.data);
  }*/
}
