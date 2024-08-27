import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<StatefulWidget> createState() {
    return _homePageState();
  }
}

class _homePageState extends State<HomePage> {
  _homePageState();

  late double _width, _height;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: _height * 1,
        width: _width * 1,
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 182, 93, 255)),
      ),
    );
  }
}
