import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_product.dart';

class Order {
  String idUsuario;
  String pagamentoSelecionado;
  int orderId;
  String valorTotal;
  List<CartProduct> items = [];
  Address address = new Address();
  Timestamp data;
  String status;

  

  Order();

  Order.fromDocument(DocumentSnapshot document){
    

    this.idUsuario = document.data['idUsuario'] as String;
    this.pagamentoSelecionado = document.data['pagamentoSelecionado'] as String;
    this.orderId =  document.data['orderId'] as int;
    this.valorTotal = document.data['valorTotal'] as String;
    this.items = (document.data['items'] as List<dynamic>).map((e) => CartProduct.fromMap(e as Map<String, dynamic>)).toList();
    this.address = Address.fromMapFirestore(document.data['address'] as Map<String, dynamic>);
    this.data = document.data['data'];
    this.status = document.data['status'];
  }

  String get formatDate{
    DateTime dateTime = data.toDate();
    String dataCompleta = dateTime.toUtc().toString();
    List<String> dataHora = dataCompleta.split(' ');
    String anoMesDia = dataHora.first;

    List<String> anoMesDias = anoMesDia.split('-');
    String diaMesAno = anoMesDias[2] + '/' + anoMesDias[1] + '/' + anoMesDias[0];
    return diaMesAno;
  }

  Future<void> save() async {
    Firestore db = Firestore.instance;
    db.collection('orders').document(this.orderId.toString()).setData(toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idUsuario': this.idUsuario,
      'pagamentoSelecionado': this.pagamentoSelecionado,
      'orderId': this.orderId,
      'items': this.items.map((e) => e.toMap()).toList(),
      'address': this.address.toMap(),
      'valorTotal': this.valorTotal,
      'data': DateTime.now(),
      'status': 'Pedido Enviado'
    };

    return map;
  }


  @override 
  String toString(){
    return 'idUsuario $idUsuario, pagamentoSelecionado: $pagamentoSelecionado, orderId: $orderId, valorTotal: $valorTotal, items $items, address: $address';
  }
}
