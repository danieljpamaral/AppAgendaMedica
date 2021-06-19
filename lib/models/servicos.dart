import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Servico{
  String idServico;
  String nomeServico;
  String tipoRemuneracao;
  double valorRemuneracao;
  String horaInicial;
  String horaFinal;

  Servico();

  Map<String, dynamic> toMap(Servico s){
    return {
      "nameServico": s.nomeServico,
      "tipoRemuneracao": s.tipoRemuneracao,
      "valorRemuneracao": s.valorRemuneracao,
      "horaInicial": s.horaInicial,
      "horaFinal": s.horaFinal,
    };
  }

  Servico.fromDocument(DocumentSnapshot document){
    idServico = document.documentID;
    nomeServico = document.data["nomeServico"];
    tipoRemuneracao = document.data["tipoRemuneracao"];
    valorRemuneracao = document.data["valorRemuneracao"];
    horaInicial = document.data["horaInicial"];
    horaFinal = document.data["horaFinal"];
  }
}