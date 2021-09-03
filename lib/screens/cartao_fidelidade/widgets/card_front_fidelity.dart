import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/models/card_fidelity_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/cartao_fidelidade/widgets/card_front_info.dart';

class CardFrontFidelity extends StatelessWidget {
  final CardFidelityManager controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 16,
          color: corRosa,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardFrontInfo(
                          icon: Icons.person,
                          info: 'Nome',
                          text: controller.nomeUser),
                      CardFrontInfo(
                          icon: Icons.insert_chart_outlined_rounded,
                          info: 'Pontuação',
                          text: controller.items.length != 0
                              ? controller.qtdeItems
                              : 'Sem Pontos no momento'),
                      controller.items.length > 0
                          ? CardFrontInfo(
                              icon: Icons.monetization_on,
                              info: 'Valor do Cupom',
                              text:
                                  'R\$ ${MoedaUtil.formatarValor(controller.valorTotal.toString())} ')
                          : Container()
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: 50,
                ),
              )
            ],
          ),
        ));
  }
}
