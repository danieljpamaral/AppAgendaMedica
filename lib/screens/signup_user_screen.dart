import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plantao/models/profissao.dart';
import 'package:plantao/models/user_model.dart';
import 'package:plantao/screens/signup_user_compl_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passControllerC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(child: CircularProgressIndicator(),);

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        hintText: "E-mail"
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "E-mail inválido!";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        hintText: "Senha"
                    ),
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha inválida!";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _passControllerC,
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        hintText: "Repita a Senha"
                    ),
                    obscureText: true,
                    validator: (text) {
                      if (text != _passController.text)
                        return "As senhas não são correspondentes";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Próxima etapa",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      onPressed: () {
                        Profissoes p = Profissoes();
                        p.carregarProfissoes();
                        if (_formKey.currentState.validate()) {

                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignUpScreenCompl(_emailController.text, _passController.text, p)
                              )
                          );

                          /*Map<String, dynamic> userData = {
                            //"name": _nameController.text,
                            "email": _emailController.text,
                            //"address": _addressController.text
                          };*/



                          /*model.signUp(
                              userData: userData,
                              pass: _passController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail
                          );*/
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        )
    );
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Usuário criado com sucesso!"),
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao criar usuário!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }

}

