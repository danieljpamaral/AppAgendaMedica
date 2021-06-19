import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantao/models/profissao.dart';
import 'package:plantao/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import 'home_screen.dart';

const request = "https://viacep.com.br/ws/";
File _imagemFile;

Future<Map> getCEP(String cep) async {
  http.Response response = await http.get(request + cep + "/json/");
  return json.decode(response.body);
}

String apenasNumeros(String text) {
  String soNum = "";
  for (int i = 0; i < text.length; i++) {
    if (text[i] == "1" ||
        text[i] == "2" ||
        text[i] == "3" ||
        text[i] == "4" ||
        text[i] == "5" ||
        text[i] == "6" ||
        text[i] == "7" ||
        text[i] == "8" ||
        text[i] == "9" ||
        text[i] == "0") soNum += text[i];
  }
  return soNum;
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 2) {
      newText.write('+');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ' ');
      if (newValue.selection.end >= 2) selectionIndex += 1;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

final _mobileFormatter = NumberTextInputFormatter();

class SignUpScreenCompl extends StatefulWidget {
  final String email;
  final String pass;
  final Profissoes profissoes;

  SignUpScreenCompl(this.email, this.pass, this.profissoes);

  @override
  _SignUpScreenComplState createState() => _SignUpScreenComplState(email, pass, profissoes);
}

class _SignUpScreenComplState extends State<SignUpScreenCompl> {
  final String email;
  final String pass;
  final Profissoes profissoes;
  _SignUpScreenComplState(this.email, this.pass, this.profissoes);

  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _addressController = TextEditingController();
  final _cepController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numController = TextEditingController();
  final _cityController = TextEditingController();
  final _ufController = TextEditingController();
  final _cellController = TextEditingController();
  bool habilitar = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _abrirCamera(BuildContext context) async {
    var img = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if (img != null)
      this.setState(() {
        _imagemFile = img;
      });

    Navigator.of(context).pop();
  }

  void _abrirGaleria(BuildContext context) async {
    var img = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (img != null)
      this.setState(() {
        _imagemFile = img;
      });
    Navigator.of(context).pop();
  }

  Future<void> showChoiseDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Faça a escolha"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera_enhance),
                        Container(width: 20.0),
                        Text("Câmera")
                      ],
                    ),
                    onTap: () {
                      _abrirCamera(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.grid_on),
                        Container(width: 20.0),
                        Text("Galeria")
                      ],
                    ),
                    onTap: () {
                      _abrirGaleria(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> showChoiseProfissao(
      BuildContext context, Profissoes profissoes) {
    List<Profissao> items = profissoes.profissoes;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Escolha sua profissao"),
              content: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                      return ListTile(
                        title: Text(
                          item.nomeProfissao,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      onTap: (){

                      },
                      );

                  }
                  //children: profissoes.profissoes
                  ));
        });
  }

  _showChoiseProfissao2(
      BuildContext context, Profissoes profissoes) {
    List<Profissao> items = profissoes.profissoes;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Escolha sua profissao"),
              content: Container(
                  width: double.maxFinite,
                  height: 300.0,
                  child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ListTile(
                      title: Text(
                        item.nomeProfissao,
                        style: Theme.of(context).textTheme.headline,
                      ),
                      onTap: (){

                      },
                    );

                  }
                //children: profissoes.profissoes
              )
          )
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _cellController.text = "+55 ";
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment(0.0, 1.15),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showChoiseDialog(context);
                          });

                          return;
                        },
                        child: CircleAvatar(
                          backgroundImage: _imagemFile != null
                              ? FileImage(_imagemFile)
                              : AssetImage("images/person.png"),
                          /*child: _imagemFile == null
                                ? Icon(
                                    Icons.camera_enhance,
                                    size: 100.0,
                                  )
                                : null,*/
                          maxRadius: 75.0,
//                            backgroundColor: Theme.of(context).primaryColor
                        ),
                      )),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text("Dados Pessoais"),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[500])),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: "Nome Completo (*)"),
                    keyboardType: TextInputType.text,
                    validator: (text) {
                      if (text.isEmpty) return "Campo Obrigatório!";
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _cpfController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.crop_din), hintText: "CPF (*)"),
                    keyboardType: TextInputType.number,
                    validator: (text) {
                      if (!CPFValidator.isValid(text)) {
                        return "CPF Inválido!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    maxLength: 15,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      _mobileFormatter,
                    ],
                    controller: _cellController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone_iphone),
                      hintText: "Celular (*)",
                    ),
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
                        icon: Icon(Icons.pin_drop), hintText: "CEP (*)"),
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                    validator: (text) {
                      if (text.isEmpty)
                        return "Campo Obrigatório!";
                      else if (habilitar) return "CEP Inválido!";
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
                                icon: Icon(Icons.home),
                                hintText: "Endereço (*)"),
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
                  Text("Dados Profissionais"),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[500])),
                  ),

                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        "prof",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _showChoiseProfissao2(context, this.profissoes);
                        }
                      ,
                    ),
                  ),


              SizedBox(
                height: 16.0
              ),


                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        "Criar Conta",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> userData = {
                            "name": _nameController.text,
                            "email": email,
                            "address": _addressController.text +
                                ", " +
                                _numController.text +
                                " - " +
                                _cityController.text +
                                " - " +
                                _ufController.text +
                                ", " +
                                apenasNumeros(_cepController.text),
                            "cpf": apenasNumeros(_cpfController.text),
                            "cell": _cellController.text
                          };

                          model.signUp(
                              userData: userData,
                              pass: pass,
                              onSuccess: _onSuccess,
                              onFail: _onFail,
                              imagemFile: _imagemFile);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
