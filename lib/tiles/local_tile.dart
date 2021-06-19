import 'package:flutter/material.dart';
import 'package:plantao/models/locais_model.dart';

class LocalTile extends StatelessWidget {
  Local local;
  Color c;

  LocalTile(this.local) {
    int i = int.parse(local.cor);
    c = Color(i);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ExpansionTile(
        title: Row(
          children: <Widget>[
            Container(
              height: 20.0,
              child: CircleAvatar(
                backgroundColor: c,
              ),
            ),
            Container(
              width: 8.0,
            ),
            Text(
              "${local.nomeLocal}",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
          ],
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Endereço: ${local.address}"),
          ),
          Text("Serviços", textAlign: TextAlign.start,),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[500])),
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: local.listServicos.map((servico) {
                  return Card(
                    child: ListTile(
                      trailing: Icon(Icons.more_vert),
//                            leading: Icon(Icons.work),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  servico.nomeServico,
                                ),
                                Text(
                                  servico.horaInicial +
                                      " às " +
                                      servico.horaFinal,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "R\$ " +
                                servico.valorRemuneracao.toStringAsFixed(2) +
                                "/" +
                                servico.tipoRemuneracao.toLowerCase(),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  );
                }).toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}
