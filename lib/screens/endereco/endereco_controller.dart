import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/helpers/delivery.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/services/cep_service.dart';

class EnderecoController extends GetxController {
  TextEditingController enderecoController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  String nomeEndereco;
  String numeroResidencia;
  String pontoDeReferencia = '';
  String telefone;
  Address address;

  bool cepValido = false;

  RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;

  RxBool _saving = false.obs;

  bool get saving => _saving.value;

  set saving(bool value) => _saving.value = value;

  Future<void> setCep(String cep) async {
    saving = true;
    address = await CepService.getAddressFromCep(cep);
    
    if (address == null) {
      enderecoController.text = '';
      complementoController.text = '';
      bairroController.text = '';
      cidadeController.text = '';
      estadoController.text = '';
      Get.rawSnackbar(
          message: "Cep não encontrado", backgroundColor: corVermelha);
      cepValido = false;
    } else {
      double taxaDeEntrega = await Delivery.calculateDelivery(address.latitude, address.longitude);
      
      if( taxaDeEntrega != null ){
      enderecoController.text = address.endereco;
      complementoController.text = address.complemento;
      bairroController.text = address.bairro;
      cidadeController.text = address.cidade;
      estadoController.text = address.estado;
      cepValido = true;
      }else{
        Get.rawSnackbar(
          message: "Endereço fora do raio de entrega :(", backgroundColor: corVermelha);
      cepValido = false;
      }
    }

    saving = false;
  }

  Future<void> save() async {
    loading = true;
    if (cepValido) {
      if (address == null) {
        address = Address();
      }
      address.nomeEndereco = nomeEndereco;
      address.numeroResidencia = numeroResidencia;
      address.pontoDeReferencia = pontoDeReferencia;
      address.telefone = telefone;
      address.endereco = enderecoController.text;
      address.complemento = complementoController.text;
      address.bairro = bairroController.text;
      address.cidade = cidadeController.text;
      address.estado = estadoController.text;
      
      await address.save();
      loading = false;
    } else {
      Get.rawSnackbar(
          message: "Informe um Cep Válido", backgroundColor: corVermelha);
          loading = false;
    }
  }
}
