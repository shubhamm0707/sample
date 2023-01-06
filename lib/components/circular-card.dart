import 'package:axplore/myfile/components/basic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularCard extends StatelessWidget {

   double width;
   double height;
   String string;

   CircularCard({required this.width,required this.height,required this.string});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(width*41),
        width: width*156,
        height: height*156,
        decoration: BoxDecoration(
        color: Color(0xffE3F4FF),
            shape: BoxShape.circle
        ),
      child:  Image.asset(string,width: 30,height: 30),
    );
  }
}



