import 'package:axplore/constants.dart';
import 'package:axplore/myfile/components/basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget {

  double width;
  double height;
  String label;
  var click;
  bool active;


  CustomButton({required this.width,required this.height,required this.label,required this.click,this.active=true});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: active ? click : null,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
              ),
              child: Center(
                child: MText(text: label,color: Colors.white,fontWeight: FontWeight.w600),
              )
            ),
          ),
          color: Colors.transparent,
        ),

      decoration: BoxDecoration(
          color:active ? primary_color:Colors.grey,
          borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}
