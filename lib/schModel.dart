class schModel{
  final String id;
  final String startdate;
  final String enddate;
  final String description;
  final bool check;
  final int starttime;
  final int endtime;

  schModel({this.id = '', this.enddate = '', this.startdate = '', this.description = '', this.check = false, this.starttime = 0, this.endtime = 0});

  factory schModel.fromMap({required String id, required Map<String,dynamic> map}){

    return schModel(
      id : id,
      description : map['description']??'',
      enddate: map['enddate']??'',
      startdate : map['startdate']??'',
      check: map['check']??false,
      starttime:  map['starttime']??0,
      endtime:  map['endtime']??0,
    );
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> data = {};
    data['enddate'] = enddate;
    data['startdate'] = startdate;
    data['description'] = description;
    data['check'] = check;
    data['starttime'] = starttime;
    data['endtime'] = endtime;
    return data;
  }
}