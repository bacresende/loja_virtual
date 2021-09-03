import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Address {
  String nomeEndereco;
  String pontoDeReferencia;
  String id;
  String cep;
  String endereco;
  String numeroResidencia;
  String complemento;
  String bairro;
  String cidade;
  String estado;
  String telefone;
  double altitude;
  double latitude;
  double longitude;

  Address();

  Address.fromMap(Map<String, dynamic> map) {
    this.cep = map['cep'];
    this.endereco = map['logradouro'];
    this.complemento = map['complemento'];
    this.bairro = map['bairro'];
    this.cidade = map['cidade']['nome'];
    this.estado = map['estado']['sigla'];
    this.altitude = map['altitude'];
    this.latitude = double.tryParse(map['latitude'] as String);
    this.longitude = double.tryParse(map['longitude'] as String);
  }

  Address.fromMapFirestore(Map<String, dynamic> map) {
    this.nomeEndereco = map['nomeEndereco'];
    this.pontoDeReferencia = map['pontoDeReferencia'];
    this.cep = map['cep'];
    this.endereco = map['endereco'];
    this.numeroResidencia = map['numeroResidencia'];
    this.complemento = map['complemento'];
    this.bairro = map['bairro'];
    this.cidade = map['cidade'];
    this.estado = map['estado'];
    this.telefone = map['telefone'];
    this.altitude = map['altitude'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
  }

  Address.fromDocument(DocumentSnapshot document) {
    this.nomeEndereco = document.data['nomeEndereco'];
    this.pontoDeReferencia = document.data['pontoDeReferencia'];
    this.id = document.documentID;
    this.cep = document.data['cep'];
    this.endereco = document.data['endereco'];
    this.numeroResidencia = document.data['numeroResidencia'];
    this.complemento = document.data['complemento'];
    this.bairro = document.data['bairro'];
    this.cidade = document.data['cidade'];
    this.estado = document.data['estado'];
    this.telefone = document.data['telefone'];
    this.altitude = document.data['altitude'];
    this.latitude = document.data['latitude'];
    this.longitude = document.data['longitude'];
  }

  Future<void> save() async {
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    db
        .collection('users')
        .document(firebaseUser.uid)
        .collection('address')
        .add(toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nomeEndereco': this.nomeEndereco,
      'cep': this.cep,
      'endereco': this.endereco,
      'numeroResidencia': this.numeroResidencia,
      'complemento': this.complemento,
      'bairro': this.bairro,
      'cidade': this.cidade,
      'estado': this.estado,
      'telefone': this.telefone,
      'pontoDeReferencia': this.pontoDeReferencia,
      'altitude': this.altitude,
      'latitude': this.latitude,
      'longitude': this.longitude
    };

    return map;
  }

  @override
  String toString() {
    return 'latitude: $latitude, altitude: $altitude, longitude: $longitude, id: $id, cep: $cep, endereco: $endereco, numeroResidencia: $numeroResidencia, complemento: $complemento, bairro: $bairro, cidade: $cidade, estado: $estado, telefone: $telefone';
  }
}
