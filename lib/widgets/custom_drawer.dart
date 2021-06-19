import 'package:flutter/material.dart';
import 'package:plantao/models/user_model.dart';
import 'package:plantao/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  Widget _buildDrawerBack() => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
      );

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: ScopedModelDescendant<UserModel>(
                  builder: (context, child, model){
                    return Stack(
                      children: <Widget>[
                            Positioned(
                              top: 8.0,
                              left: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Gerenciador\nPlantões",
                                      style: TextStyle(
                                          fontSize: 28.0, fontWeight: FontWeight.bold)),
                                  Container(width: 24.0),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(model.userData["foto"]),
                                    maxRadius: 30.0,
                                  ),
                                ]
                            ),

                        ),
                        Positioned(
                          left: 0.0,
                          bottom: 0.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Olá,  ${model.userData["name"]}",
                                  style: TextStyle(
                                      fontSize: 18.0, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                )
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(
                  Icons.location_on, "Locais de trabalho", pageController, 1),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              DrawerTile(Icons.group_add, "Profissionais", pageController, 2),
              DrawerTile(Icons.redo, "Plantões repassados", pageController, 3),
              DrawerTile(Icons.undo, "Plantões recebidos", pageController, 4),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              DrawerTile(Icons.list, "Relatório", pageController, 5),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              DrawerTile(Icons.close, "Sair", pageController, 6),
            ],
          )
        ],
      ),
    );
  }
}
