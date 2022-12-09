
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:scheduling/schModel.dart';
import 'detail.dart';
import 'Home.dart';

var tomorrow = DateTime.now().add(Duration(days: 1));

List<schModel> tSch = [];
List<schModel> tSchYTime = [];
List<schModel> tSchNoTime = [];
List<schModel> tSchNoToday = [];

String format = DateFormat('M/d EEEE').format(tomorrow).toString();
String tdateformat = DateFormat('yyyy-M-dd').format(tomorrow).toString();

class Tomorrow extends StatefulWidget{
  const Tomorrow({super.key});

  @override
  State<StatefulWidget> createState() => _Tomorrow();
}

class _Tomorrow extends State<Tomorrow>{
  final uid = FirebaseAuth.instance.currentUser?.uid;
  int length=0;

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
        leading: IconButton(
          icon : Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () { Navigator.of(context).pop(); },
        ),
      ),
      body: StreamBuilder<List<schModel>>(
          stream: streamTSch(),
          builder: (context, snapshot){
            if (snapshot.data == null) { //데이터가 없을 경우 로딩위젯
              return Center(child: Column(children: [CircularProgressIndicator(), Text(uid!)]));
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('오류가 발생했습니다.'),
              );
            } else {
              List<schModel> tSch = snapshot.data!;
              tSchYTime = tSch.where((element) => element.timeLined == true).toList();
              tSchNoTime = tSch.where((element) => element.dueDate == tdateformat && element.timeLined == false).toList();

              return ListView(
                children: [

                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 20,),
                    child: InkWell(
                      child: Container(
                        width: 50,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: finishedCount == sch.length? Colors.blueGrey : Colors.black45,
                        ),
                        child: Column( // percentage
                          children: [
                            const Align( // text1
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 15, left: 20,),
                                child: Text('Tomorrow', style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              ),
                            ),
                            
                            const SizedBox(height: 5,),

                            Expanded(
                              child: Container(
                                child: finishedCount == sch.length?
                                Lottie.network("https://assets5.lottiefiles.com/packages/lf20_JioBzM286M.json"):
                                Lottie.network("https://assets9.lottiefiles.com/private_files/lf30_aprp5fnm.json"),
                              ),
                            ),

                            finishedCount == sch.length?
                            const Align( // text2
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 20,),
                                child: Text("오늘도 수고하셨어요! 내일 일정을 살펴볼까요? ", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 11,)),
                              ),
                            ):
                            const Align( // text2
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 20,),
                                child: Text("오늘 일정이 아직 안끝났어요 ㅠㅠ\n내일을 걱정하기 보다 오늘을 먼저 마무리해볼까요?", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 12,)),
                              ),
                            ),
                            const SizedBox(height: 15,),
                          ],
                        ),
                      ),
                      onTap: (){

                      },
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      const Padding(
                        padding: EdgeInsets.only(left: 37,),
                        child: Text("시간 순 일정", style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                      const SizedBox(height: 20,),

                      tSch.isNotEmpty && tSchYTime.isNotEmpty?

                      Padding( // time line
                        padding: const EdgeInsets.only(left: 30, bottom: 30,),
                        child: SizedBox(
                          height: 135,
                          child :
                          ListView.builder(
                            itemCount: tSchYTime.length,
                            itemBuilder: (context, index) {
                              return IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(tSchYTime[index].startTime),
                                          Text(tSchYTime[index].endTime),
                                        ],
                                      ),
                                    ),
                                    const VerticalDivider(
                                        thickness: 2,
                                        width: 10,
                                        color: Colors.black38),
                                    InkWell(
                                      child: SizedBox(
                                        height: 120,
                                        width: 270,
                                        child: Card(
                                          child:Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      tSchYTime[index].title,
                                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),
                                                    ),
                                                    Expanded(child: Container()),
                                                    IconButton(
                                                      onPressed: (){
                                                        print(tSchYTime.length);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => Detail(tSch[index]),
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(Icons.more_vert),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  tSchYTime[index].memo.split('\n').first,  // 여러줄일 경우 overflow.elipsis가 해결해주지 못하기 때문에 홈에서는 간단히 첫 줄만 표기
                                                  style: const TextStyle(fontSize: 13),
                                                  overflow: TextOverflow.ellipsis,  // 첫 줄이 길이서 overflow 발생할 경우 생략 표기
                                                ),
                                                Row(
                                                  children: [
                                                    Text("장소 : ${tSchYTime[index].where}"),
                                                    Expanded(child: Container(),),
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
                                            builder: (context) => Detail(tSchYTime[index]),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ):
                      InkWell( // default
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30,),
                          child: Container(
                            width: 450,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child: InkWell(
                              child: const Center(
                                child: Text("일정이 없어요 :)", style: TextStyle(color: Colors.black, fontSize: 13,),),
                              ),
                              onTap: (){

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 37, bottom: 10,),
                        child: Text("내일 마감해야 하는 일", style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),),
                      ),

                      tSch.isNotEmpty && tSchNoTime.isNotEmpty?

                      SizedBox(
                        height: tSchNoTime.length == 1? 110 : 160,
                        child: ListView.builder( // 여기 default 조건 넣어야함
                          itemCount: tSchNoTime.length,

                          itemBuilder: (context, index) {
                            return InkWell( // card 1
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 10,),
                                child:
                                  Container(
                                    margin: EdgeInsets.only(left: 10,),
                                    child: Row(children: [
                                      Text('${(index+1).toString()}. ${tSchNoTime[index].title}', style: TextStyle(fontSize: 18,),),
                                    ],
                                ),
                                  ),
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Detail(tSch[index]),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                          :
                      SizedBox(
                        width: 450,
                        child: InkWell( // default
                          child: Padding(
                            padding: const EdgeInsets.only(left:30, right: 30, bottom: 0,),
                            child: Container(
                              width: 50,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: InkWell(
                                child: const Center(
                                  child: Text("일정이 없어요 :)", style: TextStyle(color: Colors.black, fontSize: 13,),),
                                ),
                                onTap: (){

                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40,),
                ],
              );
            }
          }
      ),
    );
  }

  Stream<List<schModel>> streamTSch(){
    try{
      final Stream<QuerySnapshot> tsnapshots = FirebaseFirestore.instance.collection('schedules/$uid/$tdateformat').orderBy('startTime').snapshots();
      return tsnapshots.map((querySnapshot){
        List<schModel> tSch = [];
        querySnapshot.docs.forEach((element) {
          tSch.add(
              schModel.fromMap(
                  id:element.id,
                  map:element.data() as Map<String, dynamic>
              )
          );
        });
        return tSch;
      });
    }catch(ex){
      log('error)', error : ex.toString(), stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }

}

class addScheduleArguments{
  late String date;
  addScheduleArguments(this.date);
}