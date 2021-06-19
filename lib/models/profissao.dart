import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Profissoes{
  List<Profissao> profissoes = List<Profissao>();
  
  Profissoes();


  Future<void> carregarProfissoes() async {

    Profissao profissao;

    Especialidade especialidade;
    QuerySnapshot consulta =
    await Firestore.instance.collection("profissao").getDocuments();

    if(consulta.documents.length>0)
      for(DocumentSnapshot d in consulta.documents){
        List<Especialidade> especialidades = List<Especialidade>();
        QuerySnapshot consulta2 =
        await Firestore.instance.collection("profissao").document(d.documentID).collection('especialidade').getDocuments();
        if(consulta2.documents.length>0){

          for(DocumentSnapshot e in consulta2.documents){
            especialidade = Especialidade(e.documentID, e.data['nomeEspecialidade']);
            especialidades.add(especialidade);
          }
          }
        profissao = Profissao(d.documentID, d.data['nome'], d.data['conselho'], especialidades);
        this.profissoes.add(profissao);
      }

  }
}


class Profissao{

  String idProfissao;
  String nomeProfissao;
  String conselhoProfissao;
  List<Especialidade> especialidades;

  Profissao(this.idProfissao, this.nomeProfissao, this.conselhoProfissao, this.especialidades);



}


class Especialidade{

  String idEspecialidade;
  String nomeEspecialidade;

  Especialidade(@required this.idEspecialidade, @required this.nomeEspecialidade);

}