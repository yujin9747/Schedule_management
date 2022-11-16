import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class AddSchedule extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AddSchedule();
  }
}

class _AddSchedule extends State<AddSchedule>{
  final _formkey = GlobalKey<FormBuilderState>();
  late bool timeSet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Schedule'),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formkey,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              FormBuilderTextField(
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
                    },
                  ),
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 20,),
              FormBuilderTextField(
                name: 'memo',
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "memo",
                  suffixIcon: IconButton(
                    icon : Icon(Icons.clear),
                    color: Colors.black38,
                    onPressed: () {
                      _formkey.currentState?.fields['memo']?.reset();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              FormBuilderDateRangePicker(
                name: "date_range",
                firstDate: DateTime(2022),
                lastDate: DateTime(2030),
                format: DateFormat('yyyy-MM-dd'), // 2022-08-01
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
              ElevatedButton(
                onPressed: (){
                  // Reset form
                  _formkey.currentState?.reset();

                  // Unfocus
                  FocusScope.of(context).unfocus();
                },
                child: Text('Reset'),
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
      //body:
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
              children: <Widget>[
                Text("추가 일정 정보"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "아래의 일정이 맞다면 확인을 눌러주세요",
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("확인"),
                onPressed: () {
                  // Todo : upload to Database
                  final snackbar = SnackBar(content: Text("Success : 일정이 추가되었습니다"),);
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
              children: <Widget>[
                Text("일정을 더 추가하시겠습니까?"),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("종료"),
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
      final title = _formkey.currentState?.fields["title"]?.value;
      final memo = _formkey.currentState?.fields["memo"]?.value;

      // Get whole form data
      final formData = _formkey.currentState?.value;

      // Unfocus
      FocusScope.of(context).unfocus();

      // Show Dialog
      showConfirmDialog();
    }
  }
}