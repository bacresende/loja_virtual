import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/screens/add_product/add_product_screen.dart';

class RowButton extends StatelessWidget {
  final String primeiroDia;
  final String segundoDia;
  String diaFinal;

  RowButton({@required this.primeiroDia, @required this.segundoDia});
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
                      Text(
                        primeiroDia,
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                diaFinal = primeiroDia;

                Get.to(AddProductScreen(diaDaSemana: diaFinal));
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
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
                      Text(segundoDia,
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 22,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
              onTap: () {
                diaFinal = segundoDia;
                Get.to(AddProductScreen(diaDaSemana: diaFinal));
              },
            ),
          )
        ],
      ),
    );
  }
}
