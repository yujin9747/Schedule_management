
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scheduling/Recharge.dart';
import 'package:scheduling/restModel.dart';
import 'package:scheduling/schModel.dart';
import 'detail.dart';
import 'timeline.dart';

var now = DateTime.now();

String format = DateFormat('M/d EEEE').format(now).toString();
String dateformat = DateFormat('yyyy-M-dd').format(now).toString();
late int finishedCount=0;
int length=1;
bool closeDay=false;
List<schModel> sch = [];
List<restModel> Rsch = [];

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home>{
  final uid = FirebaseAuth.instance.currentUser?.uid;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.transparent;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(format.toString(), style: TextStyle(color: Colors.black, fontSize: 20,),),
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
              height: 330,
              child: DrawerHeader(
                child: Column(
                  children: [
                    Progress(),
                    Text('$uid님 ${now.toString().substring(0, 11)} 일정 ${((finishedCount/length)*100).round()}% 진행중입니다.'),
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
            DrawerList(text: '오늘 일정 추가하기', icon: Icons.add_circle, route: '/addSchedule'),
            DrawerList(text: '내일 일정 추가하기', icon: Icons.schedule_rounded, route:'/addSchedule'),
            DrawerList(text: '내일 일정 미리보기', icon: Icons.notes, route:'/tomorrow'),
            DrawerList(text: '휴식 계획하기', icon: Icons.face_retouching_natural, route:'/recharge'),
            DrawerList(text: '등록된 일정에서 추가하기', icon: Icons.view_module_outlined, route:'/addModule'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        heroTag: 'addSchedule',
        onPressed: () {
          Navigator.pushNamed(context, '/addSchedule', arguments: addScheduleArguments('today'));
        },
      ),
      body: StreamBuilder<List<schModel>>(
          stream: streamSch(),
          builder: (context, snapshot){
            int currentHour = int.parse(DateTime.now().toString().substring(11, 13));
            //print(currentTime);
            if(currentHour >= 21){
              closeDay = true;
            }
            else {
              closeDay = false;
            }
            if (snapshot.data == null) { //데이터가 없을 경우 로딩위젯
              return Center(child: Column(children: [CircularProgressIndicator(), Text(uid!)]));
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('오류가 발생했습니다.'),
              );
            } else {
              sch = snapshot.data!;
              length = sch.length;
              print("length : $length");
              return ListView(
                children: [
                  closeDay == false ? Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 30,),
                    child: Container(
                      width: 50,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber,
                      ),
                      child: Column( // percentage
                        children: [
                          const SizedBox(height: 10,),
                          Progress(),
                          Align( // text1
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20, left: 20,),
                              child: Text('${((finishedCount/length)*100).round()}% 진행중이에요.'),
                            ),
                          ),
                          Align( // text2
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, left: 20,),
                              child: Text("${sch.length} 중에 ${finishedCount} 개 완료"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) :
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 30,),
                    child: InkWell(
                      child: Container(
                        width: 50,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.indigoAccent,
                        ),
                        child: Column( // percentage
                          children: [
                            const SizedBox(height: 10,),
                            // Progress(),
                            Expanded(
                              child: Container(
                                child: Lottie.network("https://assets6.lottiefiles.com/temp/lf20_Jj2Qzq.json"),
                              ),
                            ),
                            Align( // text1
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 20,),
                                child: Text('밤 9시가 지났어요!', style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                              ),
                            ),
                            Align( // text2
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 20,),
                                child: Text("오늘 하루를 마무리 하러 가볼까요?                       >> ", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, "/closeDay", arguments:closeDayArguments(sch, Rsch));
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.only(left: 37,),
                    child: const Text("시간 순 일정", style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 20,),
                  Padding( // time line
                    padding: EdgeInsets.only(left: 30,),
                    child: Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: sch.length,
                        itemBuilder: (context, index) {
                          return sch[index].timeLined == true ?IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(sch[index].startTime),
                                      Text(sch[index].endTime),
                                    ],
                                  ),
                                ),
                                VerticalDivider(thickness: 2,
                                    width: 10,
                                    color: Colors.black38),
                                InkWell(
                                  child: Container(
                                    height: 120,
                                    width: 270,
                                    child: Card(
                                      child:Padding(
                                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  sch[index].title,
                                                  style: TextStyle(fontSize: 25),
                                                ),
                                                Expanded(child: Container()),
                                                IconButton(
                                                  onPressed: (){
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Detail(sch[index]),
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(Icons.more_vert),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              sch[index].memo.split('\n').first,  // 여러줄일 경우 overflow.elipsis가 해결해주지 못하기 때문에 홈에서는 간단히 첫 줄만 표기
                                              style: TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,  // 첫 줄이 길이서 overflow 발생할 경우 생략 표기
                                            ),
                                            Row(
                                              children: [
                                                Text("장소 : ${sch[index].where}"),
                                                Expanded(child: Container(),),
                                                Checkbox(
                                                  checkColor: Colors.white,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith(getColor),
                                                  value: sch[index].check,
                                                  onChanged: (bool? value) {
                                                    // 내일 일정은 고려 안하고 오늘 일정에서 체크하는 것만 고려해서 짬
                                                    // 사실상 오늘 일정 완료하기 기능을 쓰는게 정상적이니 이대로 해도 될 듯?
                                                    print('schedules/$uid/$dateformat');
                                                    final docRef = FirebaseFirestore.instance.collection('schedules/$uid/$dateformat').doc('${sch[index].title}');
                                                    docRef.update({
                                                      'check': value,
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap:(){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Detail(sch[index]),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ):Container();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40,),
                  Padding(
                    padding: EdgeInsets.only(left: 37,),
                    child: const Text("오늘 마감해야 하는 일", style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    height: 250,
                    child: ListView.builder(
                      itemCount: sch.length,
                      itemBuilder: (context, index) {
                        return sch[index].timeLined == false && sch[index].dueDate == now.toString().substring(0, 11)? InkWell( // card 1
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 30, right: 30, top: 15,),
                            child: Container(
                              width: 50,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade400,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 400,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 10, right: 230, top: 5,),
                                          child: Icon(Icons.book_rounded,
                                            color: Colors.white, size: 40,),
                                        ),
                                        IconButton(
                                            onPressed:(){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Detail(sch[index]),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.more_vert,),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 20,),
                                        child: Text(sch[index].title),
                                      ),
                                      Expanded(child: Container(),),
                                      Checkbox(
                                        checkColor: Colors.white,
                                        fillColor: MaterialStateProperty
                                            .resolveWith(getColor),
                                        value: sch[index].check,
                                        onChanged: (bool? value) {
                                          // 내일 일정은 고려 안하고 오늘 일정에서 체크하는 것만 고려해서 짬
                                          // 사실상 오늘 일정 완료하기 기능을 쓰는게 정상적이니 이대로 해도 될 듯?
                                          print('schedules/$uid/$dateformat');
                                          final docRef = FirebaseFirestore.instance.collection('schedules/$uid/$dateformat').doc('${sch[index].title}');
                                          docRef.update({
                                            'check': value,
                                          });
                                        },
                                      ),
                                      const SizedBox(width : 5),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ) : Container();
                      },
                    ),
                  ),
                  const SizedBox(height: 40,),
                  Padding(
                    padding: EdgeInsets.only(left: 37,),
                    child: const Text("오늘 마감이 아닌 일정", style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    height: 250,
                    child: ListView.builder(
                      itemCount: sch.length,
                      itemBuilder: (context, index) {
                        return sch[index].timeLined == false && sch[index].dueDate != now.toString().substring(0, 11)? InkWell( // card 1
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 30, right: 30, top: 15,),
                            child: Container(
                              width: 50,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade400,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 400,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 10, right: 230, top: 5,),
                                          child: Icon(Icons.book_rounded,
                                            color: Colors.white, size: 40,),
                                        ),
                                        IconButton(
                                          onPressed:(){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Detail(sch[index]),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.more_vert,),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 20,),
                                        child: Text(sch[index].title),
                                      ),
                                      Expanded(child: Container(),),
                                      Checkbox(
                                        checkColor: Colors.white,
                                        fillColor: MaterialStateProperty
                                            .resolveWith(getColor),
                                        value: sch[index].check,
                                        onChanged: (bool? value) {
                                          // 내일 일정은 고려 안하고 오늘 일정에서 체크하는 것만 고려해서 짬
                                          // 사실상 오늘 일정 완료하기 기능을 쓰는게 정상적이니 이대로 해도 될 듯?
                                          print('schedules/$uid/$dateformat');
                                          final docRef = FirebaseFirestore.instance.collection('schedules/$uid/$dateformat').doc('${sch[index].title}');
                                          docRef.update({
                                            'check': value,
                                          });
                                        },
                                      ),
                                      const SizedBox(width : 5),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ) : Container();
                      },
                    ),
                  ),
                  const SizedBox(height: 40,),
                  Padding(
                    padding: EdgeInsets.only(left: 37,),
                    child: const Text("오늘 계획한 휴식", style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 10,),
                  StreamBuilder<List<restModel>>(
                    stream: streamRestSch(),
                    builder:(context, snapshot) {
                      if (snapshot.data == null) { //데이터가 없을 경우 로딩위젯
                        return Center(child: Column(children: [
                          CircularProgressIndicator(),
                          Text(uid!)
                        ]));
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('오류가 발생했습니다.'),
                        );
                      } else {
                        Rsch = snapshot.data!;
                        print("rest length : ${Rsch.length}");
                        return Expanded(
                          child: CarouselSlider.builder(
                            itemCount: Rsch.length,
                            itemBuilder: (BuildContext context, int index, int realIndex) {
                              return Container(
                                width: 300,
                                child: Card(
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 5,),
                                          Text('${Rsch[index].title}', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold ),),
                                          Expanded(child: Container(),),
                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty
                                                .resolveWith(getColor),
                                            value: Rsch[index].check,
                                            onChanged: (bool? value) {
                                              // 내일 일정은 고려 안하고 오늘 일정에서 체크하는 것만 고려해서 짬
                                              // 사실상 오늘 일정 완료하기 기능을 쓰는게 정상적이니 이대로 해도 될 듯?
                                              print('rests/$uid/$dateformat');
                                              final docRef = FirebaseFirestore.instance.collection('rests/$uid/$dateformat').doc('${Rsch[index].title}');
                                              docRef.update({
                                                'check': value,
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                        Expanded(
                                          //mainAxisAlignment: MainAxisAlignment.end,
                                          child:
                                            TextButton(
                                              child: Text("delete", style: TextStyle(color:Colors.black38,),),
                                              onPressed:(){
                                                final delRef = FirebaseFirestore.instance.collection("rests/$uid/$dateformat").doc("${sch[index].title}");
                                                delRef.delete();
                                              },
                                            ),

                                        ),
                                    ]
                                    ),
                                    onTap: () async {
                                      print("index $index 일정 모듈 is cliked!");
                                      // 디테일 페이지로 넘어가기
                                    },
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 100,
                              aspectRatio: 16/9,
                              viewportFraction: 0.6,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration: Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              //onPageChanged: callbackFunction,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            }
          }
      ),
    );
  }

  Stream<List<schModel>> streamSch(){
    try{
      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance.collection('schedules/$uid/$dateformat').orderBy('startTime').snapshots();
      return snapshots.map((querySnapshot){
        List<schModel> sch = [];
        finishedCount=0;
        querySnapshot.docs.forEach((element) {
          sch.add(
              schModel.fromMap(
                  id:element.id,
                  map:element.data() as Map<String, dynamic>
              )
          );
          if(element['check'] == true) finishedCount++;
        });
        print("uid : ${uid}");
        print("sch : ${sch.length}");
        return sch;
      });
    }catch(ex){
      log('error)', error : ex.toString(), stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }

  Stream<List<restModel>> streamRestSch(){
    try{
      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance.collection('rests/$uid/$dateformat').snapshots();
      return snapshots.map((querySnapshot){
        List<restModel> sch = [];
        querySnapshot.docs.forEach((element) {
          sch.add(
              restModel.fromMap(
                  id:element.id,
                  map:element.data() as Map<String, dynamic>
              )
          );
        });
        return sch;
      });
    }catch(ex){
      log('error)', error : ex.toString(), stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
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
        percent: finishedCount/length,
        center: Text(
          "${((finishedCount/length)*100).round()}%",
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
          else {
            Navigator.pushNamed(context, route);
          }
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

class closeDayArguments{
  late List<schModel> sch;
  late List<restModel> Rsch;
  closeDayArguments(this.sch, this.Rsch);
}