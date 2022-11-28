import 'package:cloud_firestore/cloud_firestore.dart';

class schModel{
  late final String title;
  late final String memo;
  final String startDate;
  final bool timeLined;
  final String startTime;
  final String endTime;
  final int importance;
  final String dayToDo;
  final String where;
  final String dueDate;

  final bool check;

  DocumentReference? reference;

  schModel({
    this.title = '',
    this.memo = '',
    this.startDate = '',
    this.dayToDo = '',
    this.where = '',
    this.timeLined = false,

    this.startTime = '',
    this.endTime = '',
    this.importance = 0,
    this.check = false,
    this.dueDate = '',
  });

  factory schModel.fromMap({required String id, required Map<String,dynamic> map}){

    return schModel(
      title: map['title']??'',
      memo: map['memo']??'',
      startDate: map['startDate']??'',
      dayToDo: map['dayToDo']??'',
      where: map['where']??'',
      timeLined: map['timelined']??false,
      startTime: map['startTime']??'',
      endTime: map['endTime']??'',
      importance: map['importance']??0,
      check: map['check']??false,
      dueDate: map['dueDate']??'',
    );
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> data = {};
    data['title'] = title;
    data['memo'] = memo;
    data['startDate'] = startDate;
    data['dayToDo'] = dayToDo;
    data['where'] = where;
    data['timeLine'] = timeLined;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['importance'] = importance;
    data['check'] = check;
    data['dueDate'] = dueDate;
    return data;
  }

  // schModel fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
  //
  // }

  // schModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
  //   return this.fromJson(snapshot.data(), snapshot.reference);
  // }
  //
  // schModel.fromJson(dynamic json, this.reference, this.title, this.memo, this.startDate, this.timeLined, this.startTime, this.endTime, this.importance, this.dateToDo, this.where, this.dueDate, this.check) {
  //   title = json['title'];
  //   memo = json['memo'];
  //   startDate = json['startDate'];
  //   dateToDo = json['dateToDo'];
  //
  // }
}