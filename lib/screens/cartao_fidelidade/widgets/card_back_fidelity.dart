import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/models/card_fidelity_manager.dart';
import 'package:loja_virtual/preferences.dart';

class CardBackFidelity extends StatelessWidget {
  final CardFidelityManager controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 16,
          color: corRosa,
          child: Container(
            height: 300,
            child: controller.items.length > 0
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Ganho',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: corBranca,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'R\$ ${MoedaUtil.formatarValor(controller.valorTotal.toString())}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: corBranca,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: corBranca,
                      ),
                      Expanded(
                        child: ListView.separated(
                            itemCount: controller.items.length,
                            separatorBuilder: (_, __) => Divider(),
                            itemBuilder: (_, index) {
                              double item = controller.items[index];
                              
                              return ListTile(
                                title: Text(
                                  'R\S ${MoedaUtil.formatarValor('$item')}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: corBranca,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      'Sem Valores no Momento',
                      style: TextStyle(
                          fontSize: 18,
                          color: corBranca,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ));
  }
}
