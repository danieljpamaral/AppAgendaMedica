import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantao/models/servicos.dart';
import 'package:plantao/models/user_model.dart';
import 'package:plantao/tabs/add_locias.dart';
import 'package:scoped_model/scoped_model.dart';

class Local {
  String idLocal;
  String nomeLocal;
  String cor;
  String address;
  double lat;
  double long;
  List<Servico> listServicos = [];
  List<Map<String, dynamic>> servicos = List<Map<String, dynamic>>();

  Local(this.nomeLocal, this.cor, this.address, this.lat, this.long, this.servicos, this. listServicos);

  Map<String, dynamic> toMap(){
    return {
      "nameLocal": nomeLocal,
      "cor": cor,
      "address": address,
      "lat": lat,
      "long": long,
      "servicos": servicos
    };


  }
  Local.fromDocument(DocumentSnapshot document){
    Servico servico;
    idLocal = document.documentID;
    nomeLocal = document.data["nameLocal"];
    cor = document.data["cor"];
    address = document.data["address"];
    lat = document.data["lat"];

    long = document.data["long"];

    for(var s in document.data["servicos"]) {
      servico = Servico();
      servico.horaInicial = s["horaInicial"];
      servico.horaFinal = s["horaFinal"];
      servico.valorRemuneracao = s["valorRemuneracao"];
      servico.tipoRemuneracao = s["tipoRemuneracao"];
      servico.nomeServico = s["nameServico"];
      listServicos.add(servico);
    }
  }


}


class LocaisModel extends Model{
  UserModel user;

  List<Local> locais = [];

  LocaisModel(this.user){
    if(user.firebaseUser != null)
      CarregarLocais(user.firebaseUser.uid);
  }

  static LocaisModel of(BuildContext context) =>
      ScopedModel.of<LocaisModel>(context);

  void addLocal(Local local){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("locais").add(local.toMap()).then((doc){
      local.idLocal = doc.documentID;
    });

    locais.add(local);

    notifyListeners();
  }

  void CarregarLocais(String idUsers) async{
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("locais")
        .getDocuments();

    for(DocumentSnapshot doc in query.documents){
      locais.add(Local.fromDocument(doc));
    }

//    locais = query.documents.map((doc) => Local.fromDocument(doc)).toList();

    /*for(Local l in locais){
      QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("locais")
          .collection("locais");
    }*/

    notifyListeners();

  }

  void removeCartItem(Local local){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("locais").document(local.idLocal).delete();

    locais.remove(local);

    notifyListeners();
  }

}