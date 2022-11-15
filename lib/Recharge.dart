import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// appBar style 통일하기

class card{
  late String assets;
  late String name;
  
  card(String a, String n){
    this.assets = a;
    this.name = n;
  }
}
class Recharge extends StatefulWidget{

  // 기존에 있던 카드 리스트와 사용자가 추가한 리스트가 합쳐진 채로 recharge.dart 페이지가 넘어와야 함.
  List<card> rechargeCardList = [   
    card('assets/rechargeCard0.json', 'Driving'),
    card('assets/rechargeCard1.json', 'Running'),
    card('assets/rechargeCard2.json', 'Coffee'),
  ];
  
  @override
  _RechargeState createState() {
    return _RechargeState();
  }
}

class _RechargeState extends State<Recharge>{
  // initial state : card view
  List<bool> isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('recharge.dart')),
      body: Column(
        children: [
          Container(height: 80,),
          Row(
            children: [
              const SizedBox(width: 20,),
              Text(
                '쉼 일정\n추가하기',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset('assets/rocket.png'),
            ],
          ),
          const SizedBox(height : 50),
          ToggleButtons(
            onPressed: (index){
              setState(() {
                isSelected[index] = !isSelected[index];
                if(index == 0) isSelected[1] = false;
                else if(index == 1) isSelected[0] = false;
              });
            },
            fillColor: Color.fromRGBO(234, 250, 231, 1),
            borderRadius: BorderRadius.circular(20),
            selectedColor: Color.fromRGBO(78, 203, 113, 1),
            color: Color.fromRGBO(149, 150, 149, 1),
            isSelected: isSelected,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Text(
                    'Card',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Text(
                    'List',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
              ),
            ],
            renderBorder: false,
          ),
          const SizedBox(height : 40),
          isSelected[0]? Expanded(child: swipeCardBuilder(list: widget.rechargeCardList,))
              : Expanded(child: cardListBuilder(list: widget.rechargeCardList,)),
        ],
      ),
    );
  }

}

class swipeCardBuilder extends StatelessWidget{
  List<card> list;
  swipeCardBuilder({required this.list});

  @override
  Widget build(BuildContext context) {
    // print List for test
    printList(list);
    return Swiper(
      itemCount:list.length,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Lottie.asset(list[index].assets),
              width: 500,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color:Color.fromRGBO(234, 250, 231, 1),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(78, 203, 113, 1).withOpacity(0.4),
                    spreadRadius: 0,
                    blurRadius: 5.0,
                    offset: Offset(0, 10), // changes position of shadow
                  ),
                ],
              ),

            ),
            Container(
              child:Text(
                list[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
            ),
          ],
        );
        //return Lottie.asset(list[index].assets);
      },
      viewportFraction: 0.8,
      scale: 0.8,
    );
  }
}

class cardListBuilder extends StatelessWidget{
  List<card> list;
  cardListBuilder({required this.list});

  @override
  Widget build(BuildContext context) {
    // print List for test
    printList(list);
    return ListView.builder(
      itemCount:list.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Container(
              //padding: EdgeInsets.all(20),
              child: Lottie.asset(list[index].assets),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(78, 203, 113, 1).withOpacity(0.4),
                    spreadRadius: 0,
                    blurRadius: 5.0,
                    offset: Offset(0, 10), // changes position of shadow
                  ),
                ],
              ),
            ),
            Container(
              child:Text(
                list[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              //margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}

void printList(List<card> list){
  print('Length of rechargeCardList : ${list.length}');
  for(int i=0; i<list.length; i++){
    print('Item ${i+1} : ${list[i].name}');
  }
}

