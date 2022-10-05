import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Recharge extends StatefulWidget{
  @override
  _RechargeState createState() {
    return new _RechargeState();
  }
}

class _RechargeState extends State<Recharge>{
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
                '쉼 추가하기',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(child: swipeCardBuilder()),
        ],
      ),
    );
  }

}

class swipeCardBuilder extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount:3,
      itemBuilder: (BuildContext context, int index) {
        return Lottie.asset('assets/rechargeCard$index.json');
      },
      viewportFraction: 0.8,
      scale: 0.5,
    );
  }

}
