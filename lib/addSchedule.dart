import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'Home.dart';

class AddSchedule extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AddSchedule();
  }
}

class _AddSchedule extends State<AddSchedule>{
  final _formkey = GlobalKey<FormBuilderState>();
  late bool timeSet = false;
  FocusNode titleFocusNode = FocusNode();
  FocusNode memoFocusNode = FocusNode();
  late String title;
  late String? memo;
  late String? startDate;
  late String? dueDate;
  late bool timelined;
  late String? startTime;
  late String? endTime;
  late int? importance;
  late String? dayToDo;
  late String? when;
  late String? where;


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as addScheduleArguments;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text('Add schedule ${args.date}', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold,),),
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
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20,),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                FormBuilderTextField(
                  autofocus: true,
                  focusNode: titleFocusNode,
                  name: 'title',
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Title",
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    suffixIcon: IconButton(
                      icon : Icon(Icons.clear),
                      color: Colors.black38,
                      onPressed: () {
                        _formkey.currentState?.fields['title']?.reset();
                        FocusScope.of(context).requestFocus(titleFocusNode);
                      },
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(memoFocusNode);
                  },
                ),
                const SizedBox(height: 20,),
                FormBuilderTextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,//Normal textInputField will be displayed
                  maxLines: 100,// when user presses enter it will adapt to it
                  name: 'memo',
                  focusNode: memoFocusNode,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "memo",
                    suffixIcon: IconButton(
                      icon : Icon(Icons.clear),
                      color: Colors.black38,
                      onPressed: () {
                        _formkey.currentState?.fields['memo']?.reset();
                        FocusScope.of(context).requestFocus(memoFocusNode);
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 20,),
                FormBuilderDateRangePicker(
                  name: "date_range",
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2030),
                  format: DateFormat('yyyy-MM-dd'), // 2022-08-01
                  decoration: InputDecoration(
                    hintText: "select date",
                    suffixIcon: IconButton(
                      icon : Icon(Icons.clear),
                      color: Colors.black38,
                      onPressed: () { _formkey.currentState?.fields['date_range']?.reset();},
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                FormBuilderCheckbox(
                  name: 'timeSet',
                  title: Text('시간 설정'),
                  onChanged: (value){
                    if(value == true){
                      setState(() {
                        timeSet = true;
                      });
                    }
                    else{
                      setState(() {
                        timeSet = false;
                        _formkey.currentState?.fields['start_time']?.reset();
                        _formkey.currentState?.fields['start_time']?.didChange(null);
                        _formkey.currentState?.fields['end_time']?.reset();
                        _formkey.currentState?.fields['end_time']?.didChange(null);
                      });
                    }
                  },
                ),
                timeSet
                    ? FormBuilderDateTimePicker(
                  validator: _formkey.currentState?.fields['timeSet']?.value ? FormBuilderValidators.required():null,
                  name: 'start_time',
                  inputType: InputType.time,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon : Icon(Icons.clear),
                      color: Colors.black38,
                      onPressed: () {
                        _formkey.currentState?.fields['start_time']?.reset();
                        _formkey.currentState?.fields['start_time']?.didChange(null);
                      },
                    ),
                  ),
                )
                    : Container(),
                timeSet
                    ? FormBuilderDateTimePicker(
                  validator: _formkey.currentState?.fields['timeSet']?.value ? FormBuilderValidators.required():null,
                  name: 'end_time',
                  inputType: InputType.time,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon : Icon(Icons.clear),
                      color: Colors.black38,
                      onPressed: () {
                        _formkey.currentState?.fields['end_time']?.reset();
                        _formkey.currentState?.fields['end_time']?.didChange(null);
                      },
                    ),
                  ),
                )
                    : Container(),
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10,),
                const SizedBox(child: Text("Set importancy"),),
                FormBuilderSlider(
                  name: "rating",
                  initialValue: 0,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: Colors.blueAccent[100],
                  decoration: InputDecoration(
                    //hintText: '중요도',
                  ),
                ),
                const SizedBox(height: 20,),
                const SizedBox(child: Text("Set day to do"),),
                FormBuilderRadioGroup(
                  name: 'when',
                  options: <FormBuilderFieldOption>[
                    FormBuilderFieldOption(
                      value: 'when_today',
                      child: Text('오늘 일정에 추가하기'),
                    ),
                    FormBuilderFieldOption(
                      value: 'when_tomorrow',
                      child: Text('내일 일정에 추가하기'),
                    ),
                    FormBuilderFieldOption(
                      value: 'when_userSelect',
                      child: FormBuilderDateTimePicker(
                        name: 'when_selectedDate',
                        inputType: InputType.date,
                      ),
                    ),
                    FormBuilderFieldOption(
                      value: 'when_later',
                      child: Text('나중에 등록하기(단순 모듈 추가)'),
                    ),
                  ],
                  validator: (value){
                    FormBuilderValidators.required();
                    return null;
                  },
                  initialValue: args.date != 'today' ? 'when_tomorrow': 'when_today',
                ),
                const SizedBox(height: 20,),
                const SizedBox(child: Text("Set location"),),
                const SizedBox(height: 10,),
                FormBuilderDropdown(
                  initialValue: '집',
                  name: 'where',
                  items: [
                    DropdownMenuItem(
                      value: '집',
                      child: Row(
                        children: [
                          Text('집'),
                          Icon(Icons.home_outlined),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '학교',
                      child: Row(
                        children: [
                          Text('학교'),
                          Icon(Icons.school_outlined),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '직장',
                      child: Row(
                        children: [
                          Text('직장'),
                          Icon(Icons.work_outline),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Align(
                  alignment: Alignment(-0.9, 0.5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey),
                    ),
                    onPressed: (){
                      // Reset form
                      _formkey.currentState?.reset();

                      // Unfocus
                      FocusScope.of(context).unfocus();
                    },
                    child: Text('Reset'),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
            onChanged: (){print("Form has been changed");},
            autovalidateMode: AutovalidateMode.disabled,
            initialValue: {
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addSchedule',
        onPressed: () => submitAction(),
        label: Row(
          children: [
            Icon(Icons.add),
            Text('Save'),
          ],
        ),
      ),
    );
  }

  // show Dialog before adding schedule to Database
  void showConfirmDialog() {
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
                Text("추가 일정 정보"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("일정이 맞는지 확인해주세요."),
                Text('title      : $title'),
                Text(
                  'memo       : $memo',
                  overflow: TextOverflow.ellipsis,
                ),
                Text('start date : $startDate'),
                Text('due date   : $dueDate'),
                timelined ? Text('start time : $startTime') : Container(),
                timelined ? Text('end time : $endTime') : Container(),
                Text('importance : $importance'),
                Text('when       : $when'),
                Text('where      : $where'),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text('취소'),
              ),
              ElevatedButton(
                child: const Text("확인"),
                onPressed: () {
                  // Todo : upload to Database
                  //** Test Dode : create -> 테스트 성공 **//
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  final ref = FirebaseFirestore.instance.collection('schedules/$uid/$when').doc('$title');
                  timelined != null && timelined == true? ref.set({
                    "title" : title,
                    "docid" : title,
                    "memo" : memo,
                    "startDate" : startDate,
                    "dueDate" : dueDate,
                    "timelined" : timelined,
                    "startTime" : startTime,
                    "endTime" : endTime,
                    "importance" : importance,
                    "dayToDo" : when,
                    "where" : where,
                    "check" : false,
                  })
                  : ref.set({
                    "title" : title,
                    "docid" : title,
                    "memo" : memo,
                    "startDate" : startDate,
                    "dueDate" : dueDate,
                    "timelined" : timelined,
                    "startTime" : startTime,
                    // "endTime" : endTime,
                    "importance" : importance,
                    "dayToDo" : when,
                    "where" : where,
                    "check" : false,
                  });
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: '일정 추가!',
                      message:
                      '일정이 추가되었습니다. :)',

                      contentType: ContentType.success,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                  Navigator.pop(context);
                  showAddMoreDialog();
                },
              ),
            ],
          );
        }
    );
  }

  // show Dialog "일정을 더 추가하시겠습니까?"
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: Text("More"),
                onPressed: () {
                  _formkey.currentState?.reset(); // 새로운 정보 입력 위한 초기화
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }


  // action after submit button is clicked
  void submitAction() {
    // Validate
    final validationSuccess = _formkey.currentState?.validate(); // true or false
    // validation 결과와 상관 없이 save 하고 싶을 때 : saveAndValidate() 사용하기

    if(validationSuccess == true){
      // Save data
      _formkey.currentState?.save();

      // Get values from one field
      title = _formkey.currentState?.fields["title"]?.value;
      memo = _formkey.currentState?.fields["memo"]?.value;
      if(_formkey.currentState?.fields["date_range"] != null){
        final dateRange = _formkey.currentState?.fields["date_range"]?.value.toString();
        //String start = dateRange?.substring(0,10);
        // startDate = DateTime(int.parse(dateRange.substring(0,4)), dateRange?.substring(5, 7), dateRange?.substring(8, 10));
        // dueDate = DateTime(dateRange?.substring(26,30), dateRange?.substring(31, 33), dateRange?.substring(34, 36));
        startDate = dateRange?.substring(0,10);
        dueDate = dateRange?.substring(26, 36);
      }
      if(_formkey.currentState?.fields['timeSet']?.value != null && _formkey.currentState?.fields['timeSet']?.value == true){
        timelined = true;
        startTime = _formkey.currentState?.fields['start_time']?.value.toString().substring(11, 16);
        endTime = _formkey.currentState?.fields['end_time']?.value.toString().substring(11, 16);
      }
      else {
        timelined = false;
        startTime = "24:00";
      }
        importance = _formkey.currentState?.fields['rating']?.value.round();
        dayToDo = _formkey.currentState?.fields['when']?.value;
        where = _formkey.currentState?.fields['where']?.value;

        if(dayToDo == 'when_tomorrow'){
          when = DateTime.now().add(Duration(days:1)).toString().substring(0, 10);
        }
        else if(dayToDo == 'when_today'){
          when = DateTime.now().toString().substring(0, 10);
        }
        else if(dayToDo == 'when_later'){
          when = 'null';
        }
        else if(dayToDo == 'when_userSelect'){
          when = _formkey.currentState?.fields['when_selectedDate']?.value.toString().substring(0, 10);
        }

        // 입력값 확인
        print("title: ${title}");
        print("memo: ${memo}");
        print("startDate: ${startDate}");
        print("dueDate: ${dueDate}");
        print("timelined: ${timelined}");
        if(timelined){
          print("startTime: ${startTime}");
          print("endTime: ${endTime}");
        }
        print("importance: ${importance}");
        print("when: ${when}");
        print("where: ${where}");

        // Get whole form data
        final formData = _formkey.currentState?.value;

        // Unfocus
        FocusScope.of(context).unfocus();

        // Show Dialog
        showConfirmDialog();
      }
    }

}