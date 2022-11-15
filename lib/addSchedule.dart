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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Schedule'),
      ),
      body: FormBuilder(
        key: _formkey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'title',
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Title",
              ),
              validator: FormBuilderValidators.required(),
            ),
            FormBuilderTextField(
              name: 'memo',
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "memo",
              ),
            ),
            // Date and Time picker
            // FormBuilderDateTimePicker(
            //     name: "start date",
            // ),
            // Date range picker
            FormBuilderDateRangePicker(
              name: "date_range",
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
              format: DateFormat('yyyy-MM-dd'), // 2022-08-01
              // onChanged: (){},
              // decoration: InputDecoration(),
            ),
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
            ElevatedButton(
              onPressed: (){
                // Reset form
                _formkey.currentState?.reset();

                // Unfocus
                FocusScope.of(context).unfocus();
              },
              child: Text('Reset'),
            ),
          ],
        ),
        onChanged: (){
          print("Form has been changed");
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: {
        },
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
                  final snackbar = SnackBar(content: Text("Success : 일정이 추가되었습니다"),);
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
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