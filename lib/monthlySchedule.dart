import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduling/schModel.dart';
import 'package:table_calendar/table_calendar.dart';

import 'detail.dart';

final uid = FirebaseAuth.instance.currentUser?.uid;
var now = DateTime.now();
List<schModel> sch = [];
String dateformat = DateFormat('yyyy-M-dd').format(now).toString();

class monthlySchedule extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _monthlySchedule();
  }

}

class _monthlySchedule extends State<monthlySchedule>{
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late dynamic _focusedDay;
  late dynamic _selectedDay = DateTime.now();
  late dynamic _selectedEvents;
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Monthly', style: TextStyle(fontSize: 30, color: Colors.black),),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Builder( // menu icon
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: ()=>Navigator.pop(context), // open drawer
          ),
        ),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay:DateTime.utc(today.year-1, today.month, today.day),  // 사용자가 접근할 수 있는 첫 날짜
            lastDay: DateTime.utc(today.year+10, today.month, today.day), // 사용자가 접근할 수 있는 마지막 날짜
            focusedDay: today,  // 자동 포커스 된 오늘 날짜
            calendarFormat: _calendarFormat,  // month , 2 weeks, week
            onFormatChanged: (format){   // month, 2 weeks, week 모드 바꿀 때 상태 변화
              setState((){
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day){  // 오늘이 아닌 다른 날짜를 선택했을 경우 포커스
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay){
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  print(_selectedDay.toString().split(" ",)[0]);
                  //_selectedEvents = _getEventsForDay(selectedDay);
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              print(focusedDay);
            },
            calendarBuilders: CalendarBuilders( // Custom ui
              dowBuilder: (context, day) {
                if (day.weekday == DateTime.sunday || day.weekday == DateTime.saturday) {
                  final text = DateFormat.E().format(day);
                  return Center(
                    child: Text(
                      text,
                      style: day.weekday == DateTime.sunday ? TextStyle(color: Colors.red) : TextStyle(color: Colors.blue),
                    ),
                  );
                }
              },
            ),
          ),
          Divider(
              color: Colors.black
          ),
          Padding(padding: EdgeInsets.only(left: 20, top: 10,),child: Text("일정 List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),)),
          StreamBuilder<List<schModel>>(
            stream: streamSch(_selectedDay),
            builder: (context, snapshot){
              if (snapshot.data == null) { //데이터가 없을 경우 로딩위젯
                return Center(child: Column(children: [CircularProgressIndicator(), Text(uid!)]));
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('오류가 발생했습니다.'),
                );
              }else{
                sch = snapshot.data!;
                return sch.isNotEmpty?
                    Padding(
                        padding: EdgeInsets.only(left: 30, top: 10,),
                        child: Column(
                          children: [
                            Container(
                            height: 220,
                            child: ListView.builder(
                                itemCount: sch.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 20,),
                                    child: Card(
                                      elevation: 0,
                                      child: ListTile(
                                        title:
                                        Row(
                                            children: [
                                              Text(sch[index].title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    decoration: sch[index].check?
                                                    TextDecoration.lineThrough : TextDecoration.none,
                                                    color: sch[index].check? Colors.grey : Colors.black,
                                                    fontStyle: sch[index].check? FontStyle.italic : FontStyle.normal,)),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Container(
                                                  width: 50,
                                                ),
                                              ),
                                              sch[index].timeLined ?
                                              Column(children: [
                                                Text(sch[index].startTime,),
                                                Text(sch[index].endTime,
                                                  style: TextStyle(
                                                      color: Colors.grey),),
                                              ])
                                                  : Container(),
                                            ]
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Detail(sch[index]),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                    )
                    :
                const SizedBox(
                  height: 150,
                  child:
                  Center(
                    child: Text('일정이 없습니다!'),
                  ),
                );
              }
            }
          ),
        ],
      ),

    );
  }

  Stream<List<schModel>> streamSch(date){
    date = date.toString().split(" ",)[0];

    try{

      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance.collection('schedules/$uid/$date').snapshots();
      print('schedule/$uid/$date');
      return snapshots.map((querySnapshot){
        List<schModel> sch = [];
        for (var element in querySnapshot.docs) {
          sch.add(
              schModel.fromMap(
                  id:element.id,
                  map:element.data() as Map<String, dynamic>
              )
          );
        }
        return sch;
      });
    }catch(ex){
      log('error)', error : ex.toString(), stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }
}