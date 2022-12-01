import 'package:cloud_firestore/cloud_firestore.dart';

class restModel{
  late final String path;
  late final String title;
  final String dayToDo;
  final bool check;

  DocumentReference? reference;

  restModel({
    this.title = '',
    this.path = '',
    this.dayToDo = '',
    this.check = false,
  });

  factory restModel.fromMap({required String id, required Map<String,dynamic> map}){

    return restModel(
      title: map['title']??'',
      dayToDo: map['dayToDo']??'',
      check: map['check']??false,
      path: map['path']??'',
    );
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> data = {};
    data['title'] = title;
    data['path'] = path;
    data['dayToDo'] = dayToDo;
    data['check'] = check;
    return data;
  }

}