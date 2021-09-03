import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  String number;
  String holder;
  String expirationDate;
  String securityCode;
  String brand;
  String cpf;

  void setHolder(String name) => this.holder = name;

  void setCPF(String cpf) {
    this.cpf = cpf;
  }

  void setExpirationDate(String expirationDate) =>
      this.expirationDate = expirationDate;

  void setCVV(String cvv) => this.securityCode = cvv;

  void setNumber(String number) {
    this.number = number;
    brand = detectCCType(this.number.replaceAll(' ', '')).toString().toUpperCase().replaceAll('CREDITCARDTYPE.', '');
  }

  Map<String, dynamic> toMap() {
    // 12/28
    //12, 28
    // 20 + 28
    List<String> mesAnos = this.expirationDate.split('/');
    String ano = '20' + mesAnos[1];
    
    String mesAno = mesAnos[0] + '/' + ano;
    Map<String, dynamic> map = {
      'cardNumber': this.number.replaceAll(' ', ''),
      'holder': this.holder,
      'expirationDate': mesAno,
      'securityCode': this.securityCode,
      'brand': this.brand
    };

    return map;
  }

  @override
  String toString() {
    return 'number : $number, holder : $holder, expirationDate : $expirationDate, securityCode : $securityCode, brand : $brand, cpf : $cpf';
  }
}
