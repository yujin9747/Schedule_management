//branch 정리용 commit
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:scheduling/schModel.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'Home.dart';
import 'detail.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Edit extends StatefulWidget{
  final schModel sch;
  const Edit(this.sch, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Edit();
  }
}

class _Edit extends State<Edit>{
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
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final String dateTodo = widget.sch.dayToDo;
    final ref = FirebaseFirestore.instance.collection('schedules/$uid/$dateTodo').doc(widget.sch.docid);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text('Edit', style: TextStyle(fontSize: 30, color: Colors.black),),
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
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('Edit title'),
              trailing: Icon(Icons.title),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => edtitle(widget.sch),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Edit memo'),
              trailing: Icon(Icons.note),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => edmemo(widget.sch),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Edit date'),
              trailing: Icon(Icons.edit_calendar),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => eddate(widget.sch),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              title: Text('Edit time'),
              trailing: Icon(Icons.watch_later_outlined),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => edtime(widget.sch),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              title: Text('Edit importancy'),
              trailing: Icon(Icons.notification_important),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => edimpt(widget.sch),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Edit location'),
              trailing: Icon(Icons.location_on),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => edloc(widget.sch),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 100,),
          Padding(
            padding: EdgeInsets.only(left: 120, right: 120,),
            child: Card(
              child: ListTile(
                title: Row(children: [SizedBox(width: 20,),Text('Delete', style: TextStyle(color: Colors.white),),]),
                trailing: Icon(Icons.delete),
                onTap: (){
                  ref.delete();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );

                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: '!!삭제!!',
                      message:
                      '삭제가 완료되었습니다.',
                      contentType: ContentType.warning,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                },
                tileColor: Colors.redAccent.shade200,
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent, width: 0),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class edtitle extends StatelessWidget {
  final schModel sch;
  edtitle(this.sch, {Key? key}) : super(key: key);
  final _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final String dateTodo = sch.dayToDo;
    final ref = FirebaseFirestore.instance.collection('schedules/$uid/$dateTodo').doc(sch.docid);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Editing Title' , style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
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

      body: ListView(
        children: [
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: Text('Before : ${sch.title}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: TextField(
              controller: _text,
              decoration: InputDecoration(
                label: Text('Edit title', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800),),
              ),
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: EdgeInsets.only(left: 150, right:  150,),
            child: TextButton(
              onPressed: (){
                ref.update({
                  'title' : _text.text,
                });
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: '수정완료!',
                    message:
                    '${_text.text}라고 제목이 수정되었습니다. :)',

                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.black, fontSize: 15,),),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class edmemo extends StatelessWidget {
  final schModel sch;
  edmemo(this.sch, {Key? key}) : super(key: key);
  final _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final String dateTodo = sch.dayToDo;
    final ref = FirebaseFirestore.instance.collection('schedules/$uid/$dateTodo').doc(sch.docid);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Editing Memo' , style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
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

      body: ListView(
        children: [
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: Text('Before : ${sch.memo}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: TextField(
              controller: _text,
              decoration: InputDecoration(
                label: Text('Edit memo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800),),
              ),
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: EdgeInsets.only(left: 150, right:  150,),
            child: TextButton(
              onPressed: (){
                ref.update({
                  'memo' : _text.text,
                });
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: '수정완료!',
                    message:
                    '${_text.text}라고 메모가 수정되었습니다. :)',

                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.black, fontSize: 15,),),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class eddate extends StatelessWidget {
  final schModel sch;
  eddate(this.sch, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final String dateTodo = sch.dayToDo;
    final ref = FirebaseFirestore.instance.collection('schedules/$uid/$dateTodo').doc(sch.docid);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Editing Date', style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Builder( // menu icon
          builder: (context) =>
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black,),
                onPressed: () => Navigator.pop(context), // open drawer
              ),
        ),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: Text('Before : ${sch.memo}', style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: Column(
                children: [
                  const SizedBox(height: 50,),
                  DateTimePicker(
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Start Date : ${sch.startDate}',
                    onChanged: (val) {
                      ref.update({
                        'startDate': val.toString(),
                      });
                      const snackbar = SnackBar(
                        content: Text("Success : 시작 날짜가 수정되었습니다"),);
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    },
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                  const SizedBox(height: 30,),
                  DateTimePicker(
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Day To Do : ${sch.dayToDo}',
                    onChanged: (val) {
                      ref.update({
                        'dueDate': val.toString(),
                      });
                      const snackbar = SnackBar(
                        content: Text("Success : due 날짜가 수정되었습니다"),);
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    },
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                ]
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: EdgeInsets.only(left: 150, right: 150,),
            child: TextButton(
              onPressed: () {
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: '수정완료!',
                    message:
                    '날짜가 수정되었습니다. :)',

                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              child: const Text(
                'Save', style: TextStyle(color: Colors.black, fontSize: 15,),),
            ),
          ),
        ],
      ),

    );
  }
}

class edtime extends StatelessWidget {
  final schModel sch;
  edtime(this.sch, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final String dateTodo = sch.dayToDo;
    final ref = FirebaseFirestore.instance.collection('schedules/$uid/$dateTodo').doc(sch.docid);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Editing Time', style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Builder( // menu icon
          builder: (context) =>
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black,),
                onPressed: () => Navigator.pop(context), // open drawer
              ),
        ),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: Text('Before Start Time: ${sch.startTime}\nBefore End Time: ${sch.endTime}', style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey),),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: Column(
              children: [
                TextButton(
                  onPressed: () async {
                    TimeRange? result = await showTimeRangePicker(
                        context: context,
                        start: const TimeOfDay(hour: 9, minute: 0),
                        end: const TimeOfDay(hour: 12, minute: 0),
                        // disabledTime: TimeRange(
                        //     startTime: const TimeOfDay(hour: 22, minute: 0),
                        //     endTime: const TimeOfDay(hour: 5, minute: 0)),
                        disabledColor: Colors.red.withOpacity(0.5),
                        strokeWidth: 4,
                        ticks: 24,
                        ticksOffset: -7,
                        ticksLength: 15,
                        ticksColor: Colors.grey,
                        labels: [
                          "12 am",
                          "3 am",
                          "6 am",
                          "9 am",
                          "12 pm",
                          "3 pm",
                          "6 pm",
                          "9 pm"
                        ].asMap().entries.map((e) {
                          return ClockLabel.fromIndex(
                              idx: e.key, length: 8, text: e.value);
                        }).toList(),
                        labelOffset: 35,
                        rotateLabels: false,
                        padding: 60);

                    if (kDebugMode) {
                      var st = result?.startTime.toString().split("TimeOfDay(",)[1].split(")")[0];
                      var end = result?.endTime.toString().split("TimeOfDay(",)[1].split(")")[0];

                      if(st!=null && end!=null){
                        if(sch.timeLined == false){
                          ref.update({
                            'timeLined': true,
                          });
                        }

                        ref.update({
                          'startTime': st.toString(),
                          'endTime': end.toString(),
                        });
                      }

                      print(end);
                    }
                  },
                  child: const Text("Edit Time range"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 150, right: 150,),
                  child: TextButton(
                    onPressed: () {
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: '수정완료!',
                          message:
                          '시간이 수정되었습니다. :)',

                          contentType: ContentType.success,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Save', style: TextStyle(color: Colors.black, fontSize: 15,),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}

class edimpt extends StatelessWidget {
  final schModel sch;
  edimpt(this.sch, {Key? key}) : super(key: key);
  final _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final String dateTodo = sch.dayToDo;
    final ref = FirebaseFirestore.instance.collection('schedules/$uid/$dateTodo').doc(sch.docid);

    double impt = sch.importance.toDouble();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Editing Importance' , style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
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

      body: ListView(
        children: [
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: Text('Before : ${sch.importance}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: FormBuilderSlider(
              name: "rating",
              initialValue: impt,
              min: 0,
              max: 10,
              divisions: 10,
              activeColor: Colors.blueAccent[100],
              decoration: InputDecoration(
                //hintText: '중요도',
              ),
              onChanged: (value){
                ref.update({
                  'importance': value?.toInt(),
                });
              },
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: EdgeInsets.only(left: 150, right:  150,),
            child: TextButton(
              onPressed: (){
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: '수정완료!',
                    message:
                    '중요도가 수정되었습니다. :)',

                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.black, fontSize: 15,),),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class edloc extends StatelessWidget {
  final schModel sch;
  edloc(this.sch, {Key? key}) : super(key: key);
  final _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final String dateTodo = sch.dayToDo;
    final ref = FirebaseFirestore.instance.collection('schedules/$uid/$dateTodo').doc(sch.docid);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Editing Location' , style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
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

      body: ListView(
        children: [
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: Text('Before : ${sch.where}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50,),
            child: FormBuilderDropdown(
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
                DropdownMenuItem(
                  child: Text('직접 입력'),
                ),
              ],
              onChanged: (value){
                ref.update({
                  'where': value,
                });
              },
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: EdgeInsets.only(left: 150, right:  150,),
            child: TextButton(
              onPressed: (){
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: '수정완료!',
                    message:
                    '장소가 수정되었습니다. :)',

                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.black, fontSize: 15,),),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
