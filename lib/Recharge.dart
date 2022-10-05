import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

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
      body: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            "assets/hotel-prince.jpg",
            fit: BoxFit.fill,
          );
        },
        itemCount: 10,
        viewportFraction: 0.8,
        scale: 0.9,
      ),

      // Column(
      //   children: [
      //     // Container(height: 100,),
      //     // Row(
      //     //   children: [
      //     //     Text(
      //     //       '쉼 일정 추가하기',
      //     //       style: TextStyle(
      //     //         fontSize: 40,
      //     //         fontWeight: FontWeight.bold,
      //     //       ),
      //     //     ),
      //     //   ],
      //     // ),
      //     Swiper(
      //       itemBuilder: (BuildContext context, int index) {
      //         return new Image.network(
      //           "http://via.placeholder.com/288x188",
      //           fit: BoxFit.fill,
      //         );
      //       },
      //       itemCount: 10,
      //       viewportFraction: 0.8,
      //       scale: 0.9,
      //     ),
      //   ],
      // ),
    );
  }

}