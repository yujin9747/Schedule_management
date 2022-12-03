import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduling/schModel.dart';

import 'edit.dart';
import 'edit_test.dart';

class Detail extends StatelessWidget {
  final schModel sch;

  const Detail(this.sch, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$Detail', style: TextStyle(fontSize: 30, color: Colors.black),),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Builder( // menu icon
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: ()=>Navigator.pop(context), // open drawer
          ),
        ),
        actions: [
          new IconButton(
            icon: new Icon(Icons.edit, color: Colors.black,),
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Edit(sch),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Text(sch.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
            const SizedBox(height: 10,),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),
            const SizedBox(height: 10,),
            Text(sch.memo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),),

            Flexible(
              fit: FlexFit.tight,
              child: Container(
                width: 50,
                height: 100,
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),

            Row(children: [
                Text('Start Date : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),),
                Text(sch.startDate, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    width: 50,
                    height: 20,
                  ),
                ),
                IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.calendar_month),
                ),
              ],
            ),

            Divider(
              thickness: 1,
              color: Colors.black,
            ),

            Row(children: [
                Text('Due Date : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),),
                Text(sch.dueDate, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    width: 50,
                    height: 20,
                  ),
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.calendar_month),
                ),
              ],
            ),

            Divider(
              thickness: 1,
              color: Colors.black,
            ),

            Row(children: [
              Text('Where : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),),
              Text(sch.where, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  width: 50,
                  height: 20,
                ),
              ),
              const SizedBox( height: 50,),
            ],
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}

