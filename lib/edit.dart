import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:scheduling/schModel.dart';

class Edit extends StatefulWidget {
  final schModel sch;
  const Edit(this.sch, {Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formkey = GlobalKey<FormBuilderState>();
  late bool timeSet;

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
    DateTime? dtStTime = DateFormat("hh:mm").parse(widget.sch.startTime);
    DateTime? dtEdTime = DateFormat("hh:mm").parse(widget.sch.endTime);

    timeSet = widget.sch.timeLined;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Edit', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
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
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formkey,
          onChanged: (){print("Form has been changed");},
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              FormBuilderTextField(
                autofocus: true,
                focusNode: titleFocusNode,
                name: 'title',
                initialValue: widget.sch.title,
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
                name: 'memo',
                focusNode: memoFocusNode,
                initialValue: widget.sch.memo,
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
                //initial value를 넣어야함!!! => start랑 end를 가지고 date range 설정해서 initial value로 넣어주기
                decoration: InputDecoration(
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
                initialValue: timeSet,
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
                initialValue: dtStTime,
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
                initialValue: dtEdTime,
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
              FormBuilderSlider(
                name: "rating",
                initialValue: widget.sch.importance.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: Colors.blueAccent[100],
                decoration: InputDecoration(
                  //hintText: '중요도',
                ),
              ),
              const SizedBox(height: 20,),
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
                  if(value == 'when_userSelect' && _formkey.currentState?.fields['when_userSelect']?.value == null){
                    return  "You should select the date";
                  }
                  return null;
                },
                initialValue: 'when_today',
              ),
              const SizedBox(height: 20,),
              FormBuilderDropdown(
                initialValue: widget.sch.where,
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
                  DropdownMenuItem(
                    child: Text('직접 입력'),
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
              children: const <Widget>[
                Text(
                  "아래의 일정이 맞다면 확인을 눌러주세요",
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("확인"),
                onPressed: () {
                  // Todo : upload to Database
                  //** Test Dode : create -> 테스트 성공 **//
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  final ref = FirebaseFirestore.instance.collection('schedules/$uid/$when').doc(title);
                  ref.update({
                    "title" : title,
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
                  });
                  const snackbar = SnackBar(content: Text("Success : 일정이 추가되었습니다"),);
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
                  Navigator.pop(context); // pop dialog
                  Navigator.pop(context);
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
        dueDate = dateRange?.substring(26, 37);
      }
      if(_formkey.currentState?.fields['timeSet']?.value){
        timelined = true;
        startTime = _formkey.currentState?.fields['start_time']?.value.toString().substring(11, 16);
        endTime = _formkey.currentState?.fields['end_time']?.value.toString().substring(11, 16);
      }
      else timelined = false;
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
      print("startTime: ${startTime}");
      print("endTime: ${endTime}");
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
