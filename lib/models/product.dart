import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/adicional_product.dart';

class Product {
  String dayOfWeek;
  String name;
  String description;
  String price;
  List<String> images = [];
  List<AdicionalProduct> adicionais = [];
  List<String> namePhotos = [];
  String id;

  Product(
      {this.dayOfWeek,
      this.name,
      this.description,
      this.price,
      this.images,
      this.adicionais,
      this.namePhotos,
      this.id});

  Product.fromDocument(DocumentSnapshot document) {
    this.name = document.data['name'];
    this.description = document.data['description'];
    this.price = document.data['price'];
    this.images = List<String>.from(document.data['images'] as List<dynamic>);
    this.namePhotos =
        List<String>.from(document.data['namePhotos'] as List<dynamic>);
    this.adicionais = (document.data['adicionais'] as List<dynamic> ?? [])
        .map((e) => AdicionalProduct.fromMap(e as Map<String, dynamic>))
        .toList();
    this.id = document.documentID;
    this.dayOfWeek = document.data['dayOfWeek'];

    /*this.sizes = (document.data['sizes'] as List<dynamic> ?? [])
        .map((size) => ItemSize.fromMap(size as Map<String, dynamic>))
        .toList();*/
  }

  Product.fromMap(Map<String, dynamic> map) {
    this.description = map['description'];
    this.name = map['name'];
    this.images = List<String>.from(map['images'] as List<dynamic> ?? []);
  }

  Future<void> save() async {
    Firestore _db = Firestore.instance;
    _db.collection('products').add(toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': this.name,
      'description': this.description,
      'images': this.images,
      'adicionais':
          this.adicionais.map((AdicionalProduct e) => e.toMap()).toList(),
      'price': this.price,
      'dayOfWeek': this.dayOfWeek,
      'namePhotos': this.namePhotos
    };

    return map;
  }

  Map<String, dynamic> toMap2() {
    Map<String, dynamic> map = {
      'name': this.name,
      'description': this.description,
      'images': this.images,
    };

    return map;
  }

  Product clone() {
    List<AdicionalProduct> adicionaisLocal = [];
    for(AdicionalProduct addProduct in adicionais){
      addProduct.quantity = 0;
      adicionaisLocal.add(addProduct);
      
    }
    adicionais = List<AdicionalProduct>.from(adicionaisLocal);
    return new Product(
        dayOfWeek: dayOfWeek,
        name: name,
        description: description,
        price: price,
        images: images ?? [],
        adicionais: adicionais ?? [],
        namePhotos: namePhotos ??[],
        id: id);
  }

  @override
  String toString() {
    return 'Product(name: $name, description: $description, id: $id, images: $images, price: $price, dayOfWeek: $dayOfWeek, adicionais: $adicionais ';
  }
}
