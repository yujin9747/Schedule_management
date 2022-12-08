import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:scheduling/schModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
var now = DateTime.now();

String format = DateFormat('M/d EEEE').format(now).toString();
String dateformat = DateFormat('yyyy-M-dd').format(now).toString();

class AddModule extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AddModule();
  }
}

class _AddModule extends State<AddModule>{
  final uid = FirebaseAuth.instance.currentUser?.uid;
  late String when = '';
  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("일정 모듈에서 추가히기", style: TextStyle(color: Colors.black, fontSize: 20,),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: Builder( // menu icon
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: ()=>Navigator.pop(context), // open drawer
          ),
        ),
      ),
      body:StreamBuilder<List<schModel>>(
        stream: streamSch(),
        builder: (context, snapshot){
          if (snapshot.data == null) { //데이터가 없을 경우 로딩위젯
            return Center(child: Column(children: [CircularProgressIndicator(), Text(uid!)]));
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('오류가 발생했습니다.'),
            );
          } else{
            List<schModel> sch = snapshot.data!;

            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Text('아직 추가되지 않은 일정입니다.', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold ),),
                  Text('마감일이 임박한 일정부터 추가해보세요!'),
                  const SizedBox(height: 10,),
                  sch.length != 0 ? Expanded(
                    child: CarouselSlider.builder(
                      itemCount: sch.length,
                      itemBuilder: (BuildContext context, int index, int realIndex) {
                        final _formKey = GlobalKey<FormState>();
                        return Card(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text('Due Date: ${sch[index].dueDate}', style: TextStyle(fontSize: 20, ),),
                                Text('${sch[index].title}', style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold ),),
                              ],
                            ),
                            onTap: () async {
                              print("index $index 일정 모듈 is cliked!");
                              showDatePickerPop(sch[index]);
                            },
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16/9,
                        viewportFraction: 0.6,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        //onPageChanged: callbackFunction,
                        scrollDirection: Axis.vertical,
                      ),
                    ),
                  )
                  : Expanded(
                      child: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("등록되지 않은 일정이 없습니다."),
                              Text("일정 모듈을 추가하세요."),
                            ]
                        ),
                      ),
                  ),

                ],
              ),
            );
          }
        },
      ),
    );
  }

  Stream<List<schModel>> streamSch(){
    try{
      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance.collection('schedules/$uid/null').orderBy('dueDate', descending: true).snapshots();
      return snapshots.map((querySnapshot){
        List<schModel> sch = [];
        querySnapshot.docs.forEach((element) {
          sch.add(
              schModel.fromMap(
                  id:element.id,
                  map:element.data() as Map<String, dynamic>
              )
          );
        });
        print("module length:${sch.length}");
        return sch;
      });
    }catch(ex){
      log('error)', error : ex.toString(), stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }

  void showAddMoreDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,  // 다른 화면 터치 X
        builder: (BuildContext context){
          return AlertDialog(
            // 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            // Dialog Main Title
            title: Column(
              children: const <Widget>[
                Text("일정을 더 추가하시겠습니까?"),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("종료"),
                onPressed: () {
                  Navigator.pop(context); // pop dialog
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text("More"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  void showDatePickerPop(schModel sch) {
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(), //초기값
      firstDate: DateTime.now(), //시작일
      lastDate: DateTime.now().add(Duration(days:365)), //마지막일
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), //light 테마
          child: child!,
        );
      },
    );

    selectedDate.then((dateTime) {
      if(dateTime != null){
        when = dateTime.toString().substring(0, 10);
        print(when);
        final uid = FirebaseAuth.instance.currentUser?.uid;
        final ref = FirebaseFirestore.instance.collection('schedules/${uid}/${when}').doc('${sch.title}');
        ref.set({
          "title" : sch.title,
          "docid" : sch.title,
          "memo" : sch.memo,
          "startDate" : sch.startDate,
          "dueDate" : sch.dueDate,
          "timelined" : sch.timeLined,
          "startTime" : sch.startTime,
          "endTime" : sch.endTime,
          "importance" : sch.importance,
          "dayToDo" : when,
          "where" : sch.where,
          "check" : false,
        });
        final delRef = FirebaseFirestore.instance.collection('schedules/${uid}/null').doc('${sch.title}');
        delRef.delete();
        showAddMoreDialog();
      }
    });
  }

}