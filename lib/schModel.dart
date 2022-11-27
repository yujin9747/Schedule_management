class schModel{
  final String title;
  final String memo;
  final String startDate;
  final bool timeLined;
  final String startTime;
  final String endTime;
  final int importance;
  final String dateToDo;
  final String where;
  final String dueDate;

  final bool check;

  schModel({
    this.title = '',
    this.memo = '',
    this.startDate = '',
    this.dateToDo = '',
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
      dateToDo: map['dateToDo']??'',
      where: map['where']??'',
      timeLined: map['timeLined']??false,
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
    data['dateToDo'] = dateToDo;
    data['where'] = where;
    data['timeLine'] = timeLined;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['importance'] = importance;
    data['check'] = check;
    data['dueDate'] = dueDate;
    return data;
  }
}