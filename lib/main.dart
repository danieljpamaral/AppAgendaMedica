import 'package:flutter/material.dart';
import 'package:plantao/models/locais_model.dart';
import 'package:plantao/models/user_model.dart';
import 'package:plantao/screens/home_screen.dart';
import 'package:plantao/screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/profissao.dart';

void main(){
  initializeDateFormatting().then((_) => runApp(MyApp()));}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {


    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            return ScopedModel<LocaisModel>(
              model: LocaisModel(model),
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Gerenciador de Plantões',
                  theme: ThemeData(

                      primarySwatch: Colors.blue,
                      primaryColor: Color.fromARGB(255, 4, 125, 141)
                  ),
                  home: LoginScreen()
              ),
            );
          }
      )
    );
  }
}
