class AdicionalProduct{
  
  String name;
  String price;
  int quantity = 0;

  AdicionalProduct();

    AdicionalProduct.fromMap(Map<String, dynamic> map){
      this.name = map['name'];
      this.price = map['price'];
    }

    AdicionalProduct.fromMap2(Map<String, dynamic> map){
      this.name = map['name'];
      this.price = map['price'];
      this.quantity = map['quantity'];
    }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'name': this.name,
      'price': this.price
    };
    

    return map;
  }

  Map<String, dynamic> toMap2(){
    Map<String, dynamic> map = {
      'name': this.name,
      'price': this.price,
      'quantity': this.quantity
    };
    

    return map;
  }

  @override 
  String toString(){
    return 'name: $name, price: $price, quantity: $quantity';
  }
}