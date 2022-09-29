import 'package:flutter/material.dart';
//import 'package:card_swiper/card_swiper.dart'; // card_swiper 이용해서 쉼 일정 보여주기

class Recharge extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: Text('route test : /recharge'),
      body: Column(
        children: [
          Row(
            children: [
              Text('쉼 일정 추가하기'),
              // 관련 이미지 추가
            ],
          ),
          Row(
            children: [
              // card or list 선택
            ],
          ),
          // card_swiper or list 보여주기
        ],
      ),
    );
  }

}