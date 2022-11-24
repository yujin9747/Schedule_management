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
            SizedBox(
              height: 300,
              child: DrawerHeader(
                child: Column(
                  children: [
                    Progress(),
                    Text('장유진님 9월 11일 일정 80% 진행중입니다.'),
                    Row(
                      children: [
                        Text('오늘도 좋은 하루 되세요'),
                        Icon(Icons.tag_faces),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color:Colors.yellow,
                ),
              ),
            ),
            DrawerList(text: '홈', icon: Icons.home, route:'/'),
            DrawerList(text: '월별 일정 보기', icon: Icons.calendar_today, route:'/monthly'),
            DrawerList(text: '오늘 일정 추가하기', icon: Icons.add_circle,route: '/addSchedule'),
            DrawerList(text: '내일 일정 추가하기', icon: Icons.schedule_rounded,route:'/addSchedule'),
            DrawerList(text: '휴식 계획하기', icon: Icons.face_retouching_natural,route:'/recharge'),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        heroTag: 'addSchedule',
        onPressed: () {
          Navigator.pushNamed(context, '/addSchedule', arguments: addScheduleArguments('일정 추가하기'));
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
                  SizedBox(height: 9,),
                  Progress(),
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
        ],
      ),

    );
  }

}

class Progress extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProgressState();
  }
}

class _ProgressState extends State<Progress>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 9, bottom: 9),
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
    );
  }
}

class DrawerList extends StatelessWidget{
  late String text;
  late IconData icon;
  late String route;
  DrawerList({required String text, required IconData icon, required String route}){
    this.text = text;
    this.icon = icon;
    this.route = route;
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[850],
      ),
      title: Text(text),
      onTap: () {
        print('${text} is clicked');
        Navigator.pop(context);
        if(route != '/') {
          if(text == '오늘 일정 추가하기') Navigator.pushNamed(context, route, arguments: addScheduleArguments('today'));
          else if(text == '내일 일정 추가하기') Navigator.pushNamed(context, route, arguments: addScheduleArguments('tomorrow'));
          else Navigator.pushNamed(context, route);
        }
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}

class addScheduleArguments{
  late String date;
  addScheduleArguments(this.date);
}




