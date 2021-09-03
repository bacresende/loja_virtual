import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/screens/edit_days/widgets/row_button.dart';
import 'package:loja_virtual/screens/edit_days/widgets/row_button2.dart';
import 'package:loja_virtual/screens/see_all_products/see_all_products_screen.dart';

class EditDaysScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dias da Semana'),
        actions: [
          IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                Get.to(SeeAllProductsSreen());
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                RowButton(
                  primeiroDia: 'Segunda-Feira',
                  segundoDia: 'Terça-Feira',
                ),
                RowButton(
                  primeiroDia: 'Quarta-Feira',
                  segundoDia: 'Quinta-Feira',
                ),
                RowButton(
                  primeiroDia: 'Sexta-Feira',
                  segundoDia: 'Sábado',
                ),
                RowButton2()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
