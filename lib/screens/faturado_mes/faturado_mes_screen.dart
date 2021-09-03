import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loja_virtual/helpers/data.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/faturado_mes/faturado_mes_controller.dart';

class FaturadoMesScreen extends StatelessWidget {
  final FaturadoMesController controller = new FaturadoMesController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Ganhos'),
        centerTitle: true,
      ),
      body: Container(
        child: Obx(() => controller.datas.isNotEmpty ? ListView.separated(
            separatorBuilder: (_, __) => Divider(),
            itemCount: controller.datas.length,
            itemBuilder: (_, index) {
              String data = controller.datas[index];
              String dataFormatada = DataHelper.getMounthAndYear(data);
              return ListTile(
                title: Text(
                  dataFormatada,
                  style: flatButtonRosaStyle,
                ),
                onTap: ()async {
                  await controller.openMesSelecionadoFaturamento(data);
                },
              );
            }) : Container(
              child: Center(
                child: Text('Sem Faturamento no Momento', style: flatButtonRosaStyle),
              ),
            ) ),
      ),
    );
  }
}
