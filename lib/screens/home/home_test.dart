


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _globalKey,
          drawer: Drawer(
            child: ListView(
              children: [

              ],
            ),
          ),
          body: Stack(
            children: [
              IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.black,
                  onPressed: (){
                    _globalKey.currentState!.openDrawer();
                  }
              ),
              Center(
                child: Text("Home", style: TextStyle(fontSize: 60),),
              )
            ],
          ),
        )
    );
  }
}

