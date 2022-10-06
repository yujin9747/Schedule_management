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
    card('assets/rechargeCard0.json', 'driving'),
    card('assets/rechargeCard1.json', 'running'),
    card('assets/rechargeCard2.json', 'coffee'),
  ];
  
  @override
  _RechargeState createState() {
    return new _RechargeState();
  }
}

class _RechargeState extends State<Recharge>{
  // initial state : card view
  bool isCardView = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('recharge.dart')),
      body: Column(
        children: [
          Container(height: 100,),
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
            ],
          ),
          const SizedBox(height : 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: (){
                  if(!isCardView){
                    setState(() {
                      isCardView = true;
                    });
                  }
                  // if isCardView is true, nothing to do
                },
                child: Text('List'),
              ),
              ElevatedButton(
                onPressed: (){
                  if(isCardView){
                    setState(() {
                      isCardView = false;
                    });
                  }
                  // if isCardView is false, nothing to do
                },
                child: Text('List'),
              ),
            ],
          ),
          const SizedBox(height : 50),
          isCardView? Expanded(child: swipeCardBuilder(list: widget.rechargeCardList,))
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
        return Lottie.asset(list[index].assets);
      },
      viewportFraction: 0.8,
      scale: 0.5,
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
        return Lottie.asset(list[index].assets);
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

