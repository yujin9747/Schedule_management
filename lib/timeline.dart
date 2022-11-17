/*
* Timelines 패키지 연습 해 본 자료
*
* 타임 라인 축이 화면 정 가운데 위치해 있는 상태
* -> 왼쪽으로 치우쳐져 있어 일정 정보가 담긴 타일을 크게 만들 수 있도록 변경하는 방법 찾기
* ㄴ
* */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLine extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TimeLine();
  }
}

class _TimeLine extends State<TimeLine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("timeline test"),
      ),
      body: Container(
        height: 200,
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index){
            return IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("11pm"),
                        Text("12pm"),
                      ],
                    ),
                  ),
                  VerticalDivider(thickness: 2, width: 10, color: Colors.black38),
                  Container(
                    height: 150,
                    width: 300,
                    child: Card(
                      child: Text("Contents"),
                    ),
                  ),

                ],
              ),
            );

          },
        ),
      ),
    );
  }
}

