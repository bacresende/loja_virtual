import 'dart:io';
import 'dart:math';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loja_virtual/models/adicional_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/widgets/elegant_dialog.dart';
import 'package:loja_virtual/widgets/elegant_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProductController extends GetxController {
  Product product = new Product();

  RxList<AdicionalProduct> itens = <AdicionalProduct>[].obs;

  RxList _imagens = [].obs;
  List get imagens => _imagens.value;
  ImagePicker imagePicker = ImagePicker();

  RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;

  void abrirDialogSelecionarFoto() {
    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
            titulo: "Selecionar Foto",
            descricao: "Deseja tirar uma foto ou pegar da galeria?",
            icone: Icons.add_a_photo,
            primeiroBotao: FlatButton(
              child: Text(
                'Tirar Foto',
                style: dialogFlatButtonRosaStyle,
              ),
              onPressed: () async {
                getImage(isFoto: true);
              },
            ),
            segundoBotao: FlatButton(
              child: Text(
                'Galeria',
                style: dialogFlatButtonVerdeStyle,
              ),
              onPressed: () async {
                getImage(isFoto: false);
              },
            ),
          );
        });
  }

  Future getImage({bool isFoto}) async {
    PickedFile imagem;
    if (isFoto) {
      imagem = await imagePicker.getImage(source: ImageSource.camera);

      if (imagem != null) {
        if (_imagens.length < 4) {
          _imagens.add(imagem);
          Get.back();
        } else {
          Get.back();
          Get.rawSnackbar(
              message: "Máximo de fotos 4", backgroundColor: corVermelha);
        }
      }
    } else {
      imagem = await imagePicker.getImage(source: ImageSource.gallery);

      if (imagem != null) {
        if (_imagens.length < 4) {
          _imagens.add(imagem);
          Get.back();
        } else {
          Get.back();
          Get.rawSnackbar(
              message: "Máximo de fotos 4", backgroundColor: corVermelha);
        }
      }
    }
  }

  Future<void> urlToFile() async {
    Random random = new Random();
    if (product.images != null) {
      for (String urlImagem in product.images) {
        Directory tempDir = await getTemporaryDirectory();

        String tempPath = tempDir.path;

        File file =
            new File('$tempPath' + (random.nextInt(100)).toString() + '.png');

        http.Response response = await http.get(urlImagem);

        _imagens.add(await file.writeAsBytes(response.bodyBytes));
      }
    }
  }

  void abrirDialogExclusao(int index) {
    showDialog(
      context: Get.context,
      builder: (context) => Dialog(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
              width: double.infinity,
              height: 300,
              image: Image.file(File(imagens[index].path)).image),
          FlatButton(
            onPressed: () {
              removeItem(index);

              Get.back();
            },
            child: Text("Excluir"),
            textColor: Colors.red,
          )
        ],
      )),
    );
  }

  void removeItem(int index) {
    _imagens.removeAt(index);
  }

  openDialogAdd() {
    Rx<AdicionalProduct> adicionalProduct = AdicionalProduct().obs;
    showDialog(
        context: Get.context,
        builder: (_) {
          return AlertDialog(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Digite o nome e preço do adicional',
                style:
                    TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElegantTextFormField(
                  onChange: (String valor) {
                    adicionalProduct.value.name = valor;
                  },
                  label: 'Inserir Adicional',
                  keyboardType: TextInputType.text,
                ),
                ElegantTextFormField(
                  onChange: (String valor) {
                    valor = valor.replaceAll('.', '');
                    valor = valor.replaceAll(',', '.');
                    adicionalProduct.value.price = valor;
                  },
                  label: 'Inserir preço',
                  keyboardType: TextInputType.number,
                  validator: (String valor) {
                    if (valor.isEmpty) {
                      return 'Não deixe o campo em branco';
                    }
                    return null;
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    RealInputFormatter(centavos: true),
                  ],
                ),
              ],
            ),
            actions: [
              FlatButton(
                  child: Text('Voltar'),
                  onPressed: () {
                    Get.back();
                  }),
              RaisedButton(
                  color: corRosa,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Text('Adicionar',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: () {
                    if (adicionalProduct.value.name.isNull ||
                        adicionalProduct.value.price.isNull) {
                      Get.rawSnackbar(
                          message: 'Não deixe o campo em branco',
                          icon: Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.red);
                    } else {
                      addItens(adicionalProduct.value);

                      Get.back();
                    }
                  }),
            ],
          );
        });
  }

  void addItens(AdicionalProduct adicionalProduct) {
    itens.add(adicionalProduct);
  }

  void deleteItens(AdicionalProduct adicionalProduct, int index) {
    showDialog(
        context: Get.context,
        builder: (_) {
          return AlertDialog(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Excluir adicional',
                style:
                    TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
            content: Text(
              'Deseja Excluir ${adicionalProduct.name} ?',
            ),
            actions: [
              FlatButton(
                  child: Text('Não'),
                  onPressed: () {
                    Get.back();
                  }),
              FlatButton(
                  child: Text('Sim, excluir',
                      style: TextStyle(
                        color: Colors.red,
                      )),
                  onPressed: () {
                    itens.removeAt(index);
                    Get.back();
                  }),
            ],
          );
        });
  }

  Future<void> save(String diaDaSemana) async {
    loading = true;
    if (imagens.isNotEmpty) {
      await salvarImagens();
    }

    product.dayOfWeek = diaDaSemana;
    product.adicionais.addAll(itens);

    await product.save();
    loading = false;
    UserManager userManager = Get.find();
    //Get.offAll(BaseScreen(userManager.userNormal));
    Get.back();
    Get.back();
  }

  Future<void> salvarImagens() async {
    for (PickedFile pickedFile in imagens) {
      //Referenciar arquivo para upload de imagens
      String nomeFoto = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      StorageReference pastaRaiz = firebaseStorage.ref();
      StorageReference arquivo =
          pastaRaiz.child("fotos_produtos").child("$nomeFoto.jpg");
      product.namePhotos.add(nomeFoto);
      StorageUploadTask task = arquivo.putFile(File(pickedFile.path));

      task.events.listen((storageEvent) {
        if (storageEvent.type == StorageTaskEventType.progress) {
          //loading
        } else if (storageEvent.type == StorageTaskEventType.success) {
          //loading
        } else {
          Get.rawSnackbar(
              message: "Falha ao fazer upload da foto!",
              backgroundColor: corVermelha);
        }
      });
      StorageTaskSnapshot taskSnapshot = await task.onComplete;

      String urlImagem = await taskSnapshot.ref.getDownloadURL();

      product.images.add(urlImagem);
    }
  }
}
