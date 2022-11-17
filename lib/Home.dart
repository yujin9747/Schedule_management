/*
Things to be done.

1. Fixing pod install fail error.
2. App bar title into specific form
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime now = DateTime.now();

var yoil = DateFormat.E('ko_KR').format(now).toString();
var format = DateFormat("dd/MM").format(now).toString();
final String formattedDate = format + yoil;

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(formattedDate),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,

        leading: Builder( // menu icon
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black,),
            onPressed: () => Scaffold.of(context).openDrawer(), // open drawer
          ),
        ),
      ),

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Text('data1'),
            Text('data2'),
            Text('data3'),
          ],
        ),
      ),
    );
  }

}