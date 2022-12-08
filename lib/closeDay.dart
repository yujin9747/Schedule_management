import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduling/Home.dart';
var now = DateTime.now();
var tomorrow = now.add(Duration(days: 1));

String format = DateFormat('M/d EEEE').format(now).toString();
String dateformat = DateFormat('yyyy-M-dd').format(now).toString();
String dateformatTomorrow = DateFormat('yyyy-M-dd').format(tomorrow).toString();
class CloseDay extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CloseDay();
  }
}

class _CloseDay extends State<CloseDay>{
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
    final args = ModalRoute.of(context)!.settings.arguments as closeDayArguments;
    final list = [];
    final listRest = [];
    final checkList = [];
    final checkRList = [];
    for(var one in args.sch){
      list.add(one);
      checkList.add(false);
    }
    for(var one in args.Rsch){
      listRest.add(one);
      checkRList.add(false);
    }
    print("close day list length : ${list.length}");
    print("close day list rest length : ${listRest.length}");
    return Scaffold(
      appBar: AppBar(
        title: Text("하루 마무리 짓기"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("오늘 하루 마무리 하지 못한 일정입니다.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Text("내일로 미루고자 하는 일정에", style: TextStyle(fontWeight: FontWeight.bold),),
            Text("체크 표시를 한 후 확인을 눌러주세요.", style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Center(child: Text("< 일과 >", style: TextStyle(fontWeight: FontWeight.bold),)),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return list[index].check == false ? Padding(
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
                                    left: 10, right:200,top: 5,),
                                  child: Icon(Icons.book_rounded,
                                    color: Colors.white, size: 40,),
                                ),
                                IconButton(
                                  onPressed: (){
                                    final uid = FirebaseAuth.instance.currentUser?.uid;
                                    final ref = FirebaseFirestore.instance.collection("schedules/$uid/$dateformatTomorrow").doc(list[index].title);
                                    list[index].timeLined != null && list[index].timeLined == true? ref.set({
                                      "title" : list[index].title,
                                      "memo" : list[index].memo,
                                      "startDate" : list[index].startDate,
                                      "dueDate" : list[index].dueDate,
                                      "timelined" : list[index].timeLined,
                                      "startTime" : list[index].startTime,
                                      "endTime" : list[index].endTime,
                                      "importance" : list[index].importance,
                                      "dayToDo" : list[index].dayToDo,
                                      "where" : list[index].where,
                                      "check" : false,
                                    })
                                        : ref.set({
                                      "title" : list[index].title,
                                      "memo" : list[index].memo,
                                      "startDate" : list[index].startDate,
                                      "dueDate" : list[index].dueDate,
                                      "timelined" : list[index].timeLined,
                                      "startTime" : list[index].startTime,
                                      //"endTime" : list[index].endTime,
                                      "importance" : list[index].importance,
                                      "dayToDo" : list[index].dayToDo,
                                      "where" : list[index].where,
                                      "check" : false,
                                    });
                                    const snackbar = SnackBar(content: Text("Success : 내일 일정에 추가되었습니다"),);
                                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 20, top:20,),
                                child: Text(sch[index].title, style: TextStyle(fontSize: 20),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ):Container();
                },
              ),
            ),
            Center(child: Text("< 휴식 >", style:TextStyle(fontWeight: FontWeight.bold),),),
            Expanded(
              child: ListView.builder(
                itemCount: listRest.length,
                itemBuilder: (BuildContext context, int index) {
                  return listRest[index].check == false ? Padding(
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
                                    left: 10, right: 200, top: 5,),
                                  child: Icon(Icons.book_rounded,
                                    color: Colors.white, size: 40,),
                                ),
                                IconButton(
                                  onPressed: (){
                                    final uid = FirebaseAuth.instance.currentUser?.uid;
                                    final ref = FirebaseFirestore.instance.collection("rests/$uid/$dateformatTomorrow").doc(listRest[index].title);
                                    ref.set({
                                      "title" : listRest[index].title,
                                      "docid" : listRest[index].title,
                                      "path" : "https://assets5.lottiefiles.com/private_files/lf30_enlfzw3u.jsonhttps://assets5.lottiefiles.com/private_files/lf30_enlfzw3u.json",
                                      "dayToDo" : dateformatTomorrow,
                                      "check" : false,
                                    });
                                    const snackbar = SnackBar(content: Text("Success : 내일 휴식에 추가되었습니다"),);
                                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 20, top: 20),
                                child: Text(Rsch[index].title, style: TextStyle(fontSize: 20),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ):Container();
                },
              ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("하루 마무리 하기"),
              ),
            )
          ],
        ),
      ),
    );
  }
}