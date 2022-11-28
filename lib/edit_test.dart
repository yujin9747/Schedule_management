import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:scheduling/schModel.dart';
import 'Home.dart';

class EditTest extends StatefulWidget{
  final schModel sch;
  const EditTest(this.sch, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EditTest();
  }
}

class _EditTest extends State<EditTest>{
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('EditTEST', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
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
                print("TITLE");
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Edit date'),
              trailing: Icon(Icons.edit_calendar),
              onTap: (){
                print("TITLE");
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Edit time'),
              trailing: Icon(Icons.watch_later_outlined),
              onTap: (){
                print("TITLE");
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Edit importancy'),
              trailing: Icon(Icons.notification_important),
              onTap: (){
                print("TITLE");
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Edit location'),
              trailing: Icon(Icons.location_on),
              onTap: (){
                print("TITLE");
              },
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
    final ref = FirebaseFirestore.instance.collection('schedules/$uid/$dateTodo').doc(sch.title);

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
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,),
            child: TextField(
              controller: _text,
              decoration: InputDecoration(
                label: Text('Edit title', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800),),
              ),
            ),
          ),
          TextButton(
              onPressed: (){
                ref.update({
                  'title' : _text.text,
                });
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 15,),),
          ),
        ],
      ),
    );
  }
}
