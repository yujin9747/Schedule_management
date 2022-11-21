class schModel{
  final String id;
  final String datetodo;

  schModel({this.id = '', this.datetodo = ''});

  factory schModel.fromMap({required String id, required Map<String,dynamic> map}){
    return schModel(
      id : id,
      datetodo: map['datetodo']??'',
    );
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> data = {};
    data['datetodo'] = datetodo;
    return data;
  }
}