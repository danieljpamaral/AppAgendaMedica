import 'package:flutter/material.dart';
import 'package:plantao/models/profissao.dart';
import 'package:plantao/models/user_model.dart';
import 'package:plantao/screens/home_screen.dart';
import 'package:plantao/screens/reset_password_tab.dart';
import 'package:plantao/screens/signup_user_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        );

    final _emailController = TextEditingController();
    final _passController = TextEditingController();

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading)
          return Stack(children: <Widget>[
            _buildBodyBack(),
            Center(
              child: CircularProgressIndicator(),
            )
          ]);
        return Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Scaffold(
                key: _scaffoldKey,
                body: Container(
                  padding: EdgeInsets.only(top: 60, left: 40, right: 40),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                          width: 128,
                          height: 128,
                          child: Image.asset('images/doctor-wallet.png')),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email), hintText: "E-mail"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text.isEmpty || !text.contains("@"))
                            return "E-mail inválido!";
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: _passController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.vpn_key), hintText: "Senha"),
                        obscureText: true,
                        validator: (text) {
                          if (text.isEmpty || text.length < 6)
                            return "Senha inválida!";
                        },
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          child: Text(
                            "Recuperar Senha",
                            textAlign: TextAlign.right,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ResetPasswordTab(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          /* gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 1],
                      colors: [
                        Color(0xFFF58524),
                        Color(0XFFF92B7F),
                      ],
                    ),*/
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: SizedBox.expand(
                          child: FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  child: SizedBox(
                                    child: Image.asset("images/calendar.png"),
                                    height: 48,
                                    width: 48,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                model.signIn(
                                    email: _emailController.text,
                                    pass: _passController.text,
                                    onSuccess: _onSuccess,
                                    onFail: _onFail);
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Color(0xFF3C5A99),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: SizedBox.expand(
                          child: FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Login com Facebook",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  child: SizedBox(
                                    child: Image.asset("images/fb-icon.png"),
                                    height: 28,
                                    width: 28,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        child: FlatButton(
                          child: Text(
                            "Cadastre-se",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _onSuccess() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao Entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
