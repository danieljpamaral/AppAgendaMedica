import 'package:flutter/material.dart';
import 'package:plantao/models/locais_model.dart';
import 'package:plantao/tabs/add_locias.dart';
import 'package:plantao/tiles/local_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CadastrarLocais(),
                )
              );
          },
        ),
        body: ScopedModelDescendant<LocaisModel>(
          builder: (build, child, model) {
            if (model.locais.isEmpty) {
              return Center(
                    child: Text("Nenhum Local Cadastrado"),
                  );
            } else {
              return ListView(
                    children: <Widget>[
                      Column(
                          children: model.locais.map((local) {
                        return LocalTile(local);
                      }).toList())
                    ],
                  );
            }
          },
        )
    );
  }
}
