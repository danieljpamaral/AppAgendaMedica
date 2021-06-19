import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:plantao/models/locais_model.dart';
import 'package:plantao/models/servicos.dart';
import 'package:plantao/models/user_model.dart';
import 'package:plantao/screens/signup_user_compl_screen.dart';
import 'package:plantao/tabs/add_servicos.dart';
import 'package:scoped_model/scoped_model.dart';

class CadastrarLocais extends StatefulWidget {
  @override
  _CadastrarLocaisState createState() => _CadastrarLocaisState();
}

GoogleMapsPlaces _places =
    GoogleMapsPlaces(apiKey: "AIzaSyAP3AVSsKC5aXgJQDQY9LpUQPmlFoQifyI");

class _CadastrarLocaisState extends State<CadastrarLocais> {
  final _formKey = GlobalKey<FormState>();

  // create some values

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

// raise the [showDialog] widget
  _showChoiseColor(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Selecione a cor!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
            enableLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
// Use Material color picker:
//
// child: MaterialPicker(
//   pickerColor: pickerColor,
//   onColorChanged: changeColor,
//   enableLabel: true, // only on portrait mode
// ),
//
// Use Block color picker:
//
// child: BlockPicker(
//   pickerColor: currentColor,
//   onColorChanged: changeColor,
// ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Selecionar'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /*_showAddService(BuildContext context) {
    Servico servico = Servico();
    return showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Adicionar serviço'),
        content: Container(
          width: double.maxFinite,
          height: 300.0,
          child: Form(
            child: ListView(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 120.0,
                      child: TextFormField(
                        controller: _horaInicialController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.hourglass_empty),
                            hintText: "Inicial"),
                        keyboardType: TextInputType.number,
                        onTap: () async {
                          Navigator.of(context).pop();
                          TimeOfDay time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 8, minute: 0));
                          if (time != null)
                            _horaInicialController.text = time.format(context);
                          _showAddService(context);
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
                        keyboardType: TextInputType.number,
                        onTap: () async {
                          Navigator.of(context).pop();
                          TimeOfDay time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 20, minute: 0));
                          if (time != null)
                            _horaFinalController.text = time.format(context);
                          _showAddService(context);
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
                Text("Remunerado Por:"),
                DropdownButton<String>(
                  value: tipoRemuneracao,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      tipoRemuneracao = newValue;
                      Navigator.of(context).pop();
                      _showAddService(context);
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
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Salvar'),
            onPressed: () {
              servico.nomeServico = _servicoNomeController.text;
              servico.tipoRemuneracao = tipoRemuneracao;
              servico.valorRemuneracao = double.parse(_valorRemuneracao.text);
              servico.horaInicial = _horaInicialController.text;
              servico.horaFinal = _horaFinalController.text;

              _servicoNomeController.text = "";
              tipoRemuneracao = "Dia";
              _valorRemuneracao.text = "";
              _horaInicialController.text = "";
              _horaFinalController.text = "";
              setState(() {
                servicos.add(servico);
              });

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }*/

  final _nomeLocalController = TextEditingController();
  final _addressController = TextEditingController();
  final _cepController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numController = TextEditingController();
  final _cityController = TextEditingController();
  final _ufController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  List<Servico> servicos = List<Servico>();

  bool habilitar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo local"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            List<Map<String, dynamic>> serv =
            List<Map<String, dynamic>>();
            for (Servico s in servicos) serv.add(s.toMap(s));

            String address = _addressController.text +
                ", " +
                _numController.text +
                " - " +
                _cityController.text +
                " - " +
                _ufController.text +
                ", " +
                apenasNumeros(_cepController.text);

            double lat = double.parse(_latController.text != ""
                ? _latController.text
                : "0.0");
            double long = double.parse(_longController.text != ""
                ? _longController.text
                : "0.0");

            Local local = Local(_nomeLocalController.text,
                currentColor.value.toString(), address, lat, long, serv, servicos);


              LocaisModel.of(context).addLocal(local);


            Navigator.pop(context);
          }

        },
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.only(
                  left: 16.0, top: 45.0, right: 16.0, bottom: 16.0),
              children: <Widget>[
                Text("Dados do Local"),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500])),
                ),
                TextFormField(
                  controller: _nomeLocalController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), hintText: "Nome do Local (*)"),
                  keyboardType: TextInputType.text,
                  validator: (text) {
                    if (text.isEmpty) return "Campo Obrigatório!";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.format_paint, color: Colors.grey[500]),
                    Text(
                      "Selecione a cor que identificará o local: ",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    Container(width: 16.0),
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: currentColor,
                      ),
                      onTap: () {
                        _showChoiseColor(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.0,
                ),
                Text("Endereço"),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500])),
                ),
                TextFormField(
                  controller: _cepController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.pin_drop), hintText: "CEP"),
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  validator: (text) {
                    if (text.isNotEmpty && habilitar) return "CEP Inválido!";
                  },
                  onChanged: (text) async {
                    if (text.isEmpty) {
                      setState(() {
                        habilitar = true;
                      });

                      _addressController.text = "";
                      _cityController.text = "";
                      _bairroController.text = "";
                      _ufController.text = "";
                    } else if (text.length == 8 || text.length == 9) {
                      String soNum = apenasNumeros(text);
                      Map end = await getCEP(soNum);
                      if (end != null && end.isNotEmpty) {
                        setState(() {
                          habilitar = false;
                        });

                        _addressController.text = end["logradouro"];
                        _cityController.text = end["localidade"];
                        _bairroController.text = end["bairro"];
                        _ufController.text = end["uf"];
                      }
                    }
                  },
                ),
                Row(
                  children: <Widget>[
//                      Flexible(
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: _addressController,
                          enabled: habilitar,
                          decoration: InputDecoration(
                              icon: Icon(Icons.home), hintText: "Endereço (*)"),
                          keyboardType: TextInputType.text,
                          validator: (text) {
                            if (text.isEmpty) return "Campo Obrigatório!";
                          },
                        ),
                      ),
//                        )
                    ),

                    Container(
                      width: 100.0,
                      child: TextFormField(
                        controller: _numController,
                        decoration: InputDecoration(hintText: "Número (*)"),
                        keyboardType: TextInputType.number,
                        validator: (text) {
                          if (text.isEmpty) return "Campo Obrigatório!";
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _bairroController,
                  enabled: habilitar,
                  decoration: InputDecoration(
                      icon: Icon(Icons.call_split), hintText: "Bairro (*)"),
                  keyboardType: TextInputType.text,
                  validator: (text) {
                    if (text.isEmpty) return "Campo Obrigatório!";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: <Widget>[
//                      Flexible(
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: _cityController,
                          enabled: habilitar,
                          decoration: InputDecoration(
                              icon: Icon(Icons.location_city),
                              hintText: "Cidade (*)"),
                          keyboardType: TextInputType.text,
                          validator: (text) {
                            if (text.isEmpty) return "Campo Obrigatório!";
                          },
                        ),
                      ),
//                        )
                    ),

                    Container(
                      width: 100.0,
                      child: TextFormField(
                        controller: _ufController,
                        enabled: habilitar,
                        decoration: InputDecoration(hintText: "UF (*)"),
                        keyboardType: TextInputType.text,
                        validator: (text) {
                          if (text.isEmpty) return "Campo Obrigatório!";
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      child: TextFormField(
                        controller: _latController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.map), hintText: "Lat"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
//
                    Container(
                      width: 150.0,
                      child: TextFormField(
                        controller: _longController,
                        decoration:
                            InputDecoration(icon: Icon(null), hintText: "Long"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: RaisedButton(
                          onPressed: () async {
                            // show input autocomplete with selected mode
                            // then get the Prediction selected
                            Prediction p = await PlacesAutocomplete.show(
                                mode: Mode.overlay,
                                context: context,
                                apiKey:
                                    "AIzaSyAP3AVSsKC5aXgJQDQY9LpUQPmlFoQifyI",
                                language: "pt",
                                components: [
                                  Component(Component.country, "br")
                                ]);
                            displayPrediction(p);
                          },
                          child: Center(child: Icon(Icons.location_on)),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      width: 130.0,
                      alignment: Alignment.center,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AdicionarServicos(servicos),
                            ));
                          });
                        },
                        color: Theme.of(context).primaryColor,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            Container(
                              width: 8.0,
                            ),
                            Text("Serviços", style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Theme.of(context).primaryColor)),
                      ),
                    ),

                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500])),
                ),
//                Container(
//                  width: double.maxFinite,
//                  height: 65.0 * (servicos.length + 1),

                servicos.length==0? Center(

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Nenhum serviço inserido."),
                  )
                ):
                Container(
                  height: 70.0*(servicos.length+1),
                  child: ListView.builder(

                        itemCount: servicos.length,
                        itemBuilder: (context, index) {
                          final item = servicos[index];

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
                                            item.nomeServico,
                                          ),
                                          Text(
                                            item.horaInicial +
                                                " às " +
                                                item.horaFinal,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "R\$ " +
                                          item.valorRemuneracao.toStringAsFixed(2) +
                                          "/" +
                                          item.tipoRemuneracao.toLowerCase(),
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            );

                        }
                        //children: profissoes.profissoes
                        ),
                ),
//                ),
               /* RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      List<Map<String, dynamic>> serv =
                          List<Map<String, dynamic>>();
                      for (Servico s in servicos) serv.add(s.toMap(s));

                      String address = _addressController.text +
                          ", " +
                          _numController.text +
                          " - " +
                          _cityController.text +
                          " - " +
                          _ufController.text +
                          ", " +
                          apenasNumeros(_cepController.text);

                      double lat = double.parse(_latController.text != ""
                          ? _latController.text
                          : "0.0");
                      double long = double.parse(_longController.text != ""
                          ? _longController.text
                          : "0.0");

                      Local local = Local(_nomeLocalController.text,
                          currentColor.toString(), address, lat, long, serv);

                      LocaisModel localModel = LocaisModel(model);
                      setState(() {
                        localModel.addLocal(local);
                      });

                      Navigator.pop(context);
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                      side: BorderSide(color: currentColor)),
                )*/

               Container(
                 height: 70.0,
               )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      _latController.text = lat.toString();
      _longController.text = lng.toString();

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
    }
  }
}
