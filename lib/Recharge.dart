import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:scheduling/restModel.dart';

var now = DateTime.now();

String format = DateFormat('M/d EEEE').format(now).toString();
String dateformat = DateFormat('yyyy-M-dd').format(now).toString();

class Recharge extends StatefulWidget{
  
  @override
  _RechargeState createState() {
    return _RechargeState();
  }
}

class _RechargeState extends State<Recharge>{
  final uid = FirebaseAuth.instance.currentUser?.uid;
  List<bool> isSelected = [true, false];
  late String when = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text('쉼 일정 추가하기', style: TextStyle(fontSize: 30, color: Colors.black),),
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
      body:
      StreamBuilder<List<restModel>>(
          stream: streamSch(),
          builder: (context, snapshot){
            if (snapshot.data == null) { //데이터가 없을 경우 로딩위젯
              return Center(child: Column(children: [CircularProgressIndicator(), Text(uid!)]));
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('오류가 발생했습니다.'),
              );
            } else {
              List<restModel> sch = snapshot.data!;
              return Padding(
                padding: EdgeInsets.only(left: 20, right: 20,),
                child: ListView(
                  children: [
                    Container(height: 80,),
                    Row(
                      children: [
                        const SizedBox(width: 20,),
                        Text(
                          '쉼 일정\n추가하기',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset('assets/rocket.png'),
                      ],
                    ),
                    const SizedBox(height : 50),
                    ToggleButtons(
                      onPressed: (index){
                        setState(() {
                          isSelected[index] = !isSelected[index];
                          if(index == 0) isSelected[1] = false;
                          else if(index == 1) isSelected[0] = false;
                        });
                      },
                      fillColor: Color.fromRGBO(234, 250, 231, 1),
                      borderRadius: BorderRadius.circular(20),
                      selectedColor: Color.fromRGBO(78, 203, 113, 1),
                      color: Color.fromRGBO(149, 150, 149, 1),
                      isSelected: isSelected,
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            child: Text(
                              'Card',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            child: Text(
                              'List',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )
                        ),
                      ],
                      renderBorder: false,
                    ),
                    const SizedBox(height : 40),
                    isSelected[0] ? Container(
                      height: 300,
                      child: Swiper(
                        itemCount:sch.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Lottie.network(sch[index].path),
                                width: 500,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:Color.fromRGBO(234, 250, 231, 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(78, 203, 113, 1).withOpacity(0.4),
                                      spreadRadius: 0,
                                      blurRadius: 5.0,
                                      offset: Offset(0, 10), // changes position of shadow
                                    ),
                                  ],
                                ),

                              ),
                              Container(
                                child:Text(
                                  sch[index].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
                              ),
                            ],
                          );
                        },
                        viewportFraction: 0.8,
                        scale: 0.8,
                        onTap: (index) async {
                          print("${sch[index].title} is cliked");
                          showDatePickerPop(sch[index]);
                        },
                      ),
                    )
                    :Column(
                      children: [
                        Divider(thickness: 2,color: Color.fromRGBO(78, 203, 113, 1).withOpacity(0.4),),
                      Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount:sch.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () async {
                                print("${sch[index].title} is cliked");
                                showDatePickerPop(sch[index]);
                              },
                              child: Column(
                                children: [
                                  Row(
                                  children: [
                                    Container(
                                      //padding: EdgeInsets.all(20),
                                      child: Lottie.network(sch[index].path),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(78, 203, 113, 1).withOpacity(0.4),
                                            spreadRadius: 0,
                                            blurRadius: 5.0,
                                            offset: Offset(0, 10), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    Container(
                                      child:Text(
                                        sch[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                                  const SizedBox(height:5),
                                  Divider(thickness: 2,color: Color.fromRGBO(78, 203, 113, 1).withOpacity(0.4),),
                                  const SizedBox(height: 5,),
                              ]
                              ),
                            );
                          },
                        ),
                      ),
            ]
                    ),

                  ],
                ),
              );
            }
          }
      ),
    );
  }

  Stream<List<restModel>> streamSch(){
    try{
      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance.collection('/originRest').snapshots();
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
        print("rest length : ${sch.length}");
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
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: '완료!',
                      message:
                      '쉼 일정이 추가 되엇습니다. :)',

                      contentType: ContentType.success,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
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

  void showDatePickerPop(restModel sch) {
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
        final ref = FirebaseFirestore.instance.collection('rests/${uid}/${when}').doc('${sch.title}');
        ref.set({
          "title" : sch.title,
          "docid" : sch.title,
          "dayToDo" : when,
          "path" : "https://assets5.lottiefiles.com/private_files/lf30_enlfzw3u.jsonhttps://assets5.lottiefiles.com/private_files/lf30_enlfzw3u.json",
          "check" : false,
        });
        final delRef = FirebaseFirestore.instance.collection('schedules/${uid}/null').doc('${sch.title}');
        delRef.delete();
        showAddMoreDialog();
      }
    });
  }

}


