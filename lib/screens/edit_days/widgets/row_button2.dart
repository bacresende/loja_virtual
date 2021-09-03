import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/screens/add_product/add_product_screen.dart';

class RowButton2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: [
                      Text('Não Listado',
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 22,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
              onTap: () {
                Get.to(AddProductScreen(diaDaSemana: 'Não Listado'));
              },
            ),
          )
        ],
      ),
    );
  }
}
