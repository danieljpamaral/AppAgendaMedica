import 'package:flutter/material.dart';
import 'package:plantao/tabs/locations_screen.dart';
import 'package:plantao/tabs/home_tab.dart';
import 'package:plantao/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Plantões'),
          ),
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(

          appBar: AppBar(
            centerTitle: true,
            title: Text('Locais'),
          ),
          body: LocationScreen(),
          drawer: CustomDrawer(_pageController),
        ),
        Container(
          color: Colors.yellow,
        ),
        Container(
          color: Colors.green,
        )
      ],
    );
  }
}
