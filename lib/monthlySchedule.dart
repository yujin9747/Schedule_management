import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
        title:Text('월별 일정'),
      ),
      body:TableCalendar(
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
              _selectedEvents = _getEventsForDay(selectedDay);
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
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
        eventLoader: (day) {
          return _getEventsForDay(day);
        },
      ),
    );
  }
}

List<String> _getEventsForDay(DateTime day){
  // 날짜 별 일정을 리스트나 맵으로 리턴하는 방법 고민하기
  return [];
}