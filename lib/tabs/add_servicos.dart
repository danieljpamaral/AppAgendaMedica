import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantao/models/servicos.dart';
import 'package:plantao/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

String tipoRemuneracao;
final _formKey = GlobalKey<FormState>();
final _servicoNomeController = TextEditingController();
final _horaInicialController = TextEditingController();
final _horaFinalController = TextEditingController();
final _valorRemuneracao = TextEditingController();

class AdicionarServicos extends StatefulWidget {
  List<Servico> servs;

  AdicionarServicos(this.servs);

  @override
  _AdicionarServicosState createState() => _AdicionarServicosState(servs);
}

class _AdicionarServicosState extends State<AdicionarServicos> {
  List<Servico> servicos;

  _AdicionarServicosState(this.servicos);

  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(
          title: Text("Novo serviço"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: (){

            Servico servico = Servico();
            servico.nomeServico = _servicoNomeController.text;
            servico.tipoRemuneracao = tipoRemuneracao;
            servico.valorRemuneracao = double.parse(_valorRemuneracao.text);
            servico.horaInicial = _horaInicialController.text;
            servico.horaFinal = _horaFinalController.text;

            _servicoNomeController.text = "";
//            tipoRemuneracao = "";
            _valorRemuneracao.text = "";
            _horaInicialController.text = "";
            _horaFinalController.text = "";
            setState(() {
              servicos.add(servico);
            });

            Navigator.of(context).pop();
          },
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.only(
                  left: 16.0, top: 45.0, right: 16.0, bottom: 16.0),
              children: <Widget>[
                Text("Dados do Serviço"),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500])),
                ),
                TextFormField(
                  controller: _servicoNomeController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.work), hintText: "Nome do Serviço (*)"),
                  keyboardType: TextInputType.text,
                  validator: (text) {
                    if (text.isEmpty) return "Campo Obrigatório!";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      child: TextFormField(
                        controller: _horaInicialController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.hourglass_empty),
                            hintText: "Inicial"),
                        onTap: () async {
//                      Navigator.of(context).pop();
                          TimeOfDay time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 8, minute: 0));
                          if (time != null)
                            _horaInicialController.text = time.format(context);
//                      _showAddService(context);
                        },
                      ),
                    ),
//
                    Container(
                      width: 150.0,
                      child: TextFormField(
                        controller: _horaFinalController,
                        decoration: InputDecoration(
                            icon: Icon(null), hintText: "Final"),
                        onTap: () async {
//                      Navigator.of(context).pop();
                          TimeOfDay time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 20, minute: 0));
                          if (time != null)
                            _horaFinalController.text = time.format(context);
//                      _showAddService(context);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text("Remuneração:"),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500])),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: <Widget>[
                    Text("Remunerado Por:"),
                    Container(width: 16.0),
                    Expanded(
                      child: DropdownButton<String>(

                        value: tipoRemuneracao,

                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String newValue) {


                            setState(() {
                              tipoRemuneracao = newValue;
                            });

                        },
                        items: <String>['Dia', 'Quantidade']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _valorRemuneracao,
                  decoration: InputDecoration(
                      icon: Icon(Icons.attach_money), hintText: "Valor (R\$)"),
                  keyboardType: TextInputType.number,
                  validator: (text) {
                    if (text.isEmpty) return "Campo Obrigatório!";
                  },
                ),
              ],
            ),
          );
        }));
  }
}
