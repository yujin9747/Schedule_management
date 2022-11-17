import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime now = DateTime.now();

var yoil = DateFormat.E('ko_KR').format(now).toString();
var format = DateFormat("dd/MM").format(now).toString();
String formattedDate = format + yoil;


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
      ),
      body: Text('route 테스트 : Home입니다.'),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Text('data1'),
            Text('data2'),
            Text('data3'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        heroTag: 'addSchedule',
        onPressed: () {
          Navigator.pushNamed(context, '/addSchedule');
        },
      ),
    );
  }

}