import 'package:flutter/material.dart';
import 'package:plantao/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ResetPasswordTab extends StatelessWidget {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black38,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: ScopedModelDescendant<UserModel>(
          builder: (build, child, model){
            return Container(
              padding: EdgeInsets.only(top: 60, left: 40, right: 40),
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: Icon(Icons.cached, size: 150.0,),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Esqueceu sua senha?",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Por favor, informe o E-mail associado a sua conta que enviaremos um link para o mesmo com as instruções para restauração de sua senha.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) {
                                if (text.isEmpty || !text.contains("@"))
                                  return "E-mail inválido!";
                              },
                              decoration: InputDecoration(
                                labelText: "E-mail",
                                labelStyle: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w400,

                                  fontSize: 20,
                                ),
                              ),
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 60,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: SizedBox.expand(
                                child: FlatButton(
                                  child: Text(
                                    "Enviar",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {

                                    model.recoverPass(_emailController.text);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
      )
    );
  }
}
