import 'dart:developer';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('휴식 일정 추가하기')),
      body:StreamBuilder<List<restModel>>(
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
              return ListView(
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
                    ),
                  )
                  :Container(
                    height: 300,
                    child: ListView.builder(
                      itemCount:sch.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
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
                            Container(
                              child:Text(
                                sch[index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              //margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),

                ],
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

}

class swipeCardBuilder extends StatelessWidget{
  List<restModel> list;
  swipeCardBuilder({required this.list});

  @override
  Widget build(BuildContext context) {
    // print List for test
    return Swiper(
      itemCount:list.length,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Lottie.network(list[index].path),
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
                list[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
            ),
          ],
        );
        //return Lottie.asset(list[index].assets);
      },
      viewportFraction: 0.8,
      scale: 0.8,
    );
  }
}

class cardListBuilder extends StatelessWidget{
  List<restModel> list;
  cardListBuilder({required this.list});

  @override
  Widget build(BuildContext context) {
    // print List for test
    return ListView.builder(
      itemCount:list.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Container(
              //padding: EdgeInsets.all(20),
              child: Lottie.network(list[index].path),
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
            Container(
              child:Text(
                list[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              //margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}


