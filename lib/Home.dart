/*
Things to be done.

1. Fixing pod install fail error.
2. App bar title into specific form
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scheduling/Recharge.dart';

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

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        heroTag: 'addSchedule',
        onPressed: () {
          Navigator.pushNamed(context, '/addSchedule');
        },
      ),

      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 15,),
            child: Container(
              width: 50,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.purple,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 18,),
                    child: CircularPercentIndicator(
                      radius: 95.0,
                      lineWidth: 15.0,
                      percent: 0.8,
                      center: Text(
                        "80%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                      progressColor: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 20,),
                      child: Text("data"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 20,),
                      child: Text("data"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 15,),
              child: Container(
                width: 50,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(),
                      child: Text("아직 내일의 일정이 등록되지 않았어요"),
                    ),
                  ),
                ),
              ),
            onTap: (){
              Navigator.pushNamed(context, '/addSchedule');
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 15,),
              child: Container(
                width: 50,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(),
                    child: Text("쉼 계획하기"),
                  ),
                ),
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, '/recharge');
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 15,),
              child: Container(
                width: 50,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(),
                    child: Text("쉼 계획하기"),
                  ),
                ),
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, '/recharge');
            },
          ),
        ],
      ),

    );
  }

}
