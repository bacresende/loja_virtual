import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/add_product/add_product_controller.dart';

class ListFotos extends StatelessWidget {
  final AddProductController controller;

  ListFotos(this.controller);

  @override
  Widget build(BuildContext context) {
    
    /*if(controller.product.images == null){
      controller.product.images = [];
    }*/
    return Obx(() => Padding(
      padding: const EdgeInsets.only(top:8.0, bottom: 15,left: 10),
      child: Container(
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.imagens.length + 1,
                itemBuilder: (context, index) {
                  if (controller.imagens.length == index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                          onTap: () {
                            controller.abrirDialogSelecionarFoto();
                          },
                          child: CircleAvatar(
                            backgroundColor: corRosa,
                            radius: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add_a_photo,
                                  size: 30,
                                  color: Colors.grey[100],
                                ),
                                Text(
                                  "Adicionar \nFotos",
                                  style: TextStyle(
                                      color: Colors.grey[100], fontSize: 13),
                                )
                              ],
                            ),
                          )),
                    );
                  }
                  if (controller.imagens.length > 0) {
                    return Obx(
                      () => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                            onTap: () {
                              controller.abrirDialogExclusao(index);
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  Image.file(File(controller.imagens[index].path))
                                      .image,
                              radius: 50,
                              child: Container(
                                color: Color.fromRGBO(255, 255, 255, 0.4),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            )),
                      ),
                    );
                  }
                  return Container();
                }),
          ),
    ));
  }
}
