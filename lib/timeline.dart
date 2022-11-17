/*
* Timelines 패키지 연습 해 본 자료
*
* 타임 라인 축이 화면 정 가운데 위치해 있는 상태
* -> 왼쪽으로 치우쳐져 있어 일정 정보가 담긴 타일을 크게 만들 수 있도록 변경하는 방법 찾기
* ㄴ
* */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

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
        title: Text("time line test"),
      ),
      body: FixedTimeline.tileBuilder(
        builder: TimelineTileBuilder.connectedFromStyle(
          itemCount: 3,
          connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
          //indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
          contentsAlign: ContentsAlign.basic,
          oppositeContentsBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 40,
              child: Text('11:00'),
            ),
          ),
          contentsBuilder: (context, index) => TimeLineCard(),
        ),
      ),
    );
  }
}

class TimeLineCard extends StatelessWidget{
  late final title;
  late final memo;
  late final where;
  late final category;
  late final startTime;
  late final endTime;
  late final finished;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 500,
        height: 100,
        child: Center(child: Text('Elevated Card')),
      ),
    );
  }

}