import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/helpers/data.dart';
import 'package:loja_virtual/models/product.dart';

class ProductManager extends GetxController {
  Firestore _db = Firestore.instance;
  RxList<Product> _allProducts = <Product>[].obs;

  RxString _search = ''.obs;

  String get search => _search.value;

  set search(String valor) {
    _search.value = valor;
  }

  ProductManager() {
    _loadAllProducts();
  }

  List<Product> get filteredProducts {
    final RxList<Product> filteredProducts = <Product>[].obs;

    if (search.isEmpty) {
      filteredProducts.clear();
      filteredProducts.addAll(_allProducts);
    } else {
      filteredProducts.clear();
      filteredProducts.addAll(allProducts
          .where((Product product) =>
              product.name.toLowerCase().contains(search.toLowerCase()))
          .toList());
    }

    return filteredProducts;
  }

  List<Product> get allProducts => _allProducts.value;

  Future<void> _loadAllProducts() async {
    _db
        .collection('products')
        .where('dayOfWeek', isEqualTo: DataHelper.getWeek())
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _allProducts.value = snapshot.documents
          .map((DocumentSnapshot e) => Product.fromDocument(e))
          .toList();

    });
  }
}
